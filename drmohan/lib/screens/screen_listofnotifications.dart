import 'package:drmohan/models/model_notifiesitem.dart';
import 'package:drmohan/widgets/appbar.dart';
import 'package:drmohan/widgets/bottombar.dart';
import 'package:drmohan/widgets/menu_drawer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../services/http_service.dart';

class ListOfNotificationsScreen extends StatelessWidget {
  final HttpService httpService = HttpService();
  callToSetAppBarTitle() => createState().setAppBarTitle("My Notifications");
  @override
  AppBarWidget createState() => AppBarWidget();

  @override
  Widget build(BuildContext context) {
    callToSetAppBarTitle();
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      extendBody: true,
      drawer: MenuDrawerWidget(),
      appBar: AppBarWidget(),
      body: FutureBuilder(
        future: httpService.getNotificationItems(),
        builder: (BuildContext context, AsyncSnapshot<List<Notifiesitem>> snapshot) {
          if (snapshot.hasData) {
            List<Notifiesitem>? notifiesitems = snapshot.data;
            return SingleChildScrollView(
                child: Container(
                    height: MediaQuery.of(context).size.height * 0.75,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      color: Colors.white38,
                    ),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      shrinkWrap: true,
                      //physics: NeverScrollableScrollPhysics(),
                      itemCount: notifiesitems?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                            child: Row(
                          children: <Widget>[
                            Container(
                                width: MediaQuery.of(context).size.width * 0.85,
                                height: MediaQuery.of(context).size.height * 0.1,
                                margin: EdgeInsets.all(10),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      notifiesitems![index].Text, // + "<br>" + notifiesitems![index].enDate,
                                      style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.042, color: Colors.blue, fontWeight: FontWeight.bold),
                                    )))
                          ],
                        ));
                      },
                    )));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        tooltip: 'My orders',
        //child: Icon(Icons.add, color: Colors.blue),
        child: CircleAvatar(
          radius: 30.0,
          backgroundImage: NetworkImage(OTPVerification.appscreensdataitems![36].srntxt2 + '/images/dmdscLOGOsmall.png'),
          backgroundColor: Colors.transparent,
        ),
        onPressed: () {},
      ),
      bottomNavigationBar: BottomAppBarWidget(),
    );
  }
}
