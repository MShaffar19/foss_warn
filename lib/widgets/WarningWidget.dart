// widget für die einzelnen Warnungen als Card
import 'package:flutter/material.dart';
import 'package:foss_warn/services/helperFunctionToTranslateAndChooseColorTyp.dart';
import 'package:foss_warn/widgets/dialogs/MessageTypExplanation.dart';
import 'package:provider/provider.dart';
import '../services/markWarningsAsRead.dart';
import '../class/class_WarnMessage.dart';
import '../class/class_Area.dart';
import '../class/class_Geocode.dart';
import '../views/WarningDetailView.dart';
import '../services/updateProvider.dart';
import '../services/listHandler.dart';
import 'dialogs/CategoryExplanation.dart';

class WarningWidget extends StatelessWidget {
  final WarnMessage warnMessage;
  const WarningWidget({Key? key, required this.warnMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> geocodeNameList = [];
    /*print("Warnug schon gesehen? " +
        myPlaceList
            .any((place) => place.alreadyReadWarnings
                .any((warning) => warning.headline == warnMessage.headline))
            .toString());*/
    updatePrevView() {
      final updater = Provider.of<Update>(context, listen: false);
      updater.updateReadStatusInList();
    }

    List<String> generateGeocodeList() {
      List<String> tempList = [];
      for (Area myArea in warnMessage.areaList) {
        for (Geocode myGeocode in myArea.geocodeList) {
          tempList.add(myGeocode.geocodeName);
        }
      }
      return tempList;
    }

    geocodeNameList = generateGeocodeList();

    return Consumer<Update>(
      builder: (context, counter, child) => Card(
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailScreen(warnMessage: warnMessage)),
            ).then((value) => updatePrevView());
          },
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                readWarnings.contains(warnMessage.identifier)
                    ? IconButton(
                        onPressed: () {
                          markOneWarningAsUnread(warnMessage, context);
                        },
                        icon: Icon(
                          Icons.mark_chat_read,
                          color: Colors.green,
                        ))
                    : IconButton(
                        onPressed: () {
                          markOneWarningAsRead(warnMessage, context);
                        },
                        icon: Icon(
                          Icons.warning_amber_outlined,
                          color: Colors.red,
                        )),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CategoryExplanation();
                                  },
                                );
                              },
                              child: Text(
                                translateCategory(warnMessage.category),
                                style: Theme.of(context).textTheme.headline3,
                              ),
                            ),
                            color: Colors.indigo,
                            padding: EdgeInsets.all(5),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return MessageTypExplanation();
                                  },
                                );
                              },
                              child: Text(
                                translateMessageTyp(warnMessage.messageTyp),
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white),
                              ),
                            ),
                            color:
                                chooseMessageTypColor(warnMessage.messageTyp),
                            padding: EdgeInsets.all(5),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: SizedBox(
                              width: 100,
                              child: Text(
                                geocodeNameList.length > 1
                                    ? geocodeNameList.first +
                                    " und " +
                                    (geocodeNameList.length - 1)
                                        .toString() +
                                    " andere"
                                    : geocodeNameList.isNotEmpty
                                    ? geocodeNameList.first
                                    : "unbekannt",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        warnMessage.headline,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Text(
                              formatSentDate(warnMessage.sent),
                              style: TextStyle(fontSize: 12),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              warnMessage.source,
                              style: TextStyle(fontSize: 12),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DetailScreen(warnMessage: warnMessage)),
                      ).then((value) => updatePrevView());
                    },
                    icon: Icon(Icons.read_more))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
