import 'dart:developer';

import 'package:drmohan/models/model_healthrecordprescription.dart';
import 'package:drmohan/screens/screen_healthrecord.dart';
import 'package:drmohan/screens/screen_healthrecordclinicalsummary.dart';
import 'package:drmohan/screens/screen_healthrecordlabreports.dart';
import 'package:drmohan/widgets/appbar.dart';
import 'package:drmohan/widgets/bottombar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../main.dart';
import '../models/model_healthrecorditem.dart';
import '../services/http_service.dart';

class HealthRecordPrescriptionScreen extends StatelessWidget {
  final HttpService httpService = HttpService();
  static List<String> prescriptionTitles = [];
  static List<String> prescriptionImgUrl = [];
  static List<String> prescriptionScreens = [];
  static List<PrescriptionItem> prescriptionItems = [];
  callToSetAppBarTitle() => createState().setAppBarTitle("Health Record,Prescription");
  @override
  AppBarWidget createState() => AppBarWidget();
  @override
  Widget build(BuildContext context) {
    callToSetAppBarTitle();
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      extendBody: true,
      //drawer: MenuDrawerWidget(),
      appBar: AppBarWidget(),
      body: FutureBuilder(
        future: httpService.getHealthRecordPrescriptionItems(),
        builder: (BuildContext context, AsyncSnapshot<List<HealthRecorditem>> snapshot) {
          log('data: $snapshot.hasData');
          if (snapshot.hasData) {
            List<HealthRecorditem>? healthrecorditems = snapshot.data;
            /*return ListView(
              children: profiles!
                  .map(
                    (Profile post) => ListTile(
                      title: Text(post.name),
                      subtitle: Text("${post.userId}"),
                    ),
                  )
                  .toList(),
            );*/
            if (prescriptionItems!.length > 0) {
              return Container(
                  height: MediaQuery.of(context).size.height * 0.79,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    color: Colors.white38,
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        //width: MediaQuery.of(context).size.width * 0.9,
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            bottom: BorderSide(width: 5.0, color: Colors.grey),
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            print("tapped");
                            /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DashboardScreen(),
                              ));*/
                          },
                          child: Row(
                            children: <Widget>[
                              Container(
                                height: MediaQuery.of(context).size.height * 0.07,
                                width: MediaQuery.of(context).size.width * 0.2,
                                margin: EdgeInsets.only(left: 3),
                                child: CircleAvatar(
                                    backgroundColor: Colors.blue,
                                    child: Text(
                                      ProfileScreen.selectedProfile.PatientName[0],
                                      style: TextStyle(fontFamily: 'Arial', fontStyle: FontStyle.normal, fontWeight: FontWeight.bold, color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.055),
                                    )),
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height * 0.07,
                                width: 0.7,
                                color: Colors.blue,
                              ),
                              Container(
                                //color: Colors.yellow,
                                height: MediaQuery.of(context).size.height * 0.09,
                                width: MediaQuery.of(context).size.width * 0.6,
                                margin: EdgeInsets.only(left: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                            margin: EdgeInsets.all(0),
                                            color: Colors.white,
                                            height: MediaQuery.of(context).size.height * 0.03,
                                            width: MediaQuery.of(context).size.width * 0.45,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                ProfileScreen.selectedProfile.PatientName,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: MediaQuery.of(context).size.width * 0.032,
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ))
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                            margin: EdgeInsets.all(0),
                                            height: MediaQuery.of(context).size.height * 0.03,
                                            width: MediaQuery.of(context).size.width * 0.12,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                DrMohanApp.appinfoitems[0].srntxt4.split(',')[0] + ":",
                                                style: TextStyle(
                                                  fontSize: MediaQuery.of(context).size.width * 0.034,
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )),
                                        Container(
                                            height: MediaQuery.of(context).size.height * 0.03,
                                            width: MediaQuery.of(context).size.width * 0.4,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                ProfileScreen.selectedProfile.MrNo,
                                                style: TextStyle(
                                                  fontSize: MediaQuery.of(context).size.width * 0.034,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                            margin: EdgeInsets.all(0),
                                            height: MediaQuery.of(context).size.height * 0.03,
                                            width: MediaQuery.of(context).size.width * 0.1,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                DrMohanApp.appinfoitems[0].srntxt4.split(',')[1] + ": ",
                                                style: TextStyle(
                                                  fontSize: MediaQuery.of(context).size.width * 0.034,
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )),
                                        Container(
                                            height: MediaQuery.of(context).size.height * 0.03,
                                            width: MediaQuery.of(context).size.width * 0.35,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                ProfileScreen.selectedProfile.DOB.split(" ")[0],
                                                style: TextStyle(
                                                  fontSize: MediaQuery.of(context).size.width * 0.034,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(height: MediaQuery.of(context).size.height * 0.15, width: MediaQuery.of(context).size.width * 0.15, margin: EdgeInsets.only(left: 2), child: Image.network(DrMohanApp.appinfoitems[0].srntxt2 + "/images/" + ProfileScreen.selectedProfile.Gender.toLowerCase() + ".png"))
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            bottom: BorderSide(width: 5.0, color: Colors.grey),
                          ),
                        ),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(4),
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: prescriptionTitles.length,
                          itemBuilder: (BuildContext context, int index) {
                            return MouseRegion(
                                onHover: (event) {
                                  // appContainer.style.cursor = 'pointer';
                                },
                                child: Container(
                                    height: MediaQuery.of(context).size.height * 0.2,
                                    width: MediaQuery.of(context).size.width * 0.23,
                                    margin: const EdgeInsets.all(1),
                                    /* decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: <BoxShadow>[
                                    new BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                  color: Colors.white),*/
                                    child: Card(
                                        child: InkWell(
                                            onTap: () {
                                              print("tapped");
                                              String srn = prescriptionScreens[index];
                                              loadHealthRecordScreen(context, srn);
                                            },
                                            child: Column(
                                              children: <Widget>[
                                                Container(height: MediaQuery.of(context).size.height * 0.1, width: MediaQuery.of(context).size.width * 0.8, margin: EdgeInsets.only(right: 0), child: CircleAvatar(backgroundColor: Colors.white, child: Image.network(DrMohanApp.appinfoitems![0].srntxt2 + prescriptionImgUrl[index]))),
                                                Container(
                                                    margin: EdgeInsets.all(1),
                                                    child: Align(
                                                        child: Text(
                                                      prescriptionTitles[index],
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: MediaQuery.of(context).size.width * 0.030,
                                                        color: Colors.blue,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ))),
                                              ],
                                            )))));
                          },
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.46,
                        margin: EdgeInsets.all(0),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(0),
                          shrinkWrap: true,
                          //physics: NeverScrollableScrollPhysics(),
                          itemCount: prescriptionItems.length,
                          itemBuilder: (BuildContext context, int index) {
                            print(prescriptionItems.length.toString() + " prescriptionItems.length ");
                            return MouseRegion(
                                onHover: (event) {
                                  // appContainer.style.cursor = 'pointer';
                                },
                                child: Container(
                                    margin: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: <BoxShadow>[
                                          new BoxShadow(
                                            color: Colors.white.withOpacity(1),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(3, 3),
                                          ),
                                        ],
                                        color: Colors.black12),
                                    child: Card(
                                        color: Colors.white,
                                        child: InkWell(
                                            /*onTap: () {
                                        print("tapped");
                                        String srn = healthrecordScreens[index];
                                      },*/
                                            child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                                //color: Colors.yellow,
                                                padding: const EdgeInsets.all(1),
                                                height: MediaQuery.of(context).size.height * 0.03,
                                                width: MediaQuery.of(context).size.width * 0.9,
                                                //decoration: BoxDecoration(borderRadius: BorderRadius.circular(0), color: Colors.transparent),
                                                margin: EdgeInsets.only(left: 5),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                        //color: Colors.red,
                                                        height: MediaQuery.of(context).size.height * 0.03,
                                                        width: MediaQuery.of(context).size.width * 0.42,
                                                        child: Align(
                                                          alignment: Alignment.centerLeft,
                                                          child: Text(
                                                            prescriptionItems![index].ItemName,
                                                            textAlign: TextAlign.left,
                                                            style: TextStyle(
                                                              fontSize: MediaQuery.of(context).size.width * 0.030,
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        )),
                                                    Container(
                                                        //color: Colors.greenAccent,
                                                        height: MediaQuery.of(context).size.height * 0.03,
                                                        width: MediaQuery.of(context).size.width * 0.45,
                                                        child: Align(
                                                          alignment: Alignment.centerRight,
                                                          child: Text(
                                                            prescriptionItems![index].Morning + " - " + prescriptionItems![index].Afternoon + " - " + prescriptionItems![index].Night,
                                                            textAlign: TextAlign.left,
                                                            style: TextStyle(
                                                              fontSize: MediaQuery.of(context).size.width * 0.030,
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ))
                                                  ],
                                                )),
                                            Container(
                                                //color: Colors.red,
                                                padding: const EdgeInsets.all(1),
                                                height: MediaQuery.of(context).size.height * 0.025,
                                                width: MediaQuery.of(context).size.width * 0.9,
                                                // decoration: BoxDecoration(borderRadius: BorderRadius.circular(0), color: Colors.transparent),
                                                margin: EdgeInsets.only(left: 5),
                                                child: Html(
                                                  data: prescriptionItems![index].generic,
                                                  defaultTextStyle: TextStyle(
                                                    fontSize: MediaQuery.of(context).size.width * 0.025,
                                                    color: Colors.blueGrey,
                                                    fontWeight: FontWeight.normal,
                                                  ),
                                                )),
                                            Container(
                                                //color: Colors.yellow,
                                                padding: const EdgeInsets.all(1),
                                                height: MediaQuery.of(context).size.height * 0.02,
                                                width: MediaQuery.of(context).size.width * 0.9,
                                                //decoration: BoxDecoration(borderRadius: BorderRadius.circular(0), color: Colors.transparent),
                                                margin: EdgeInsets.only(left: 5, bottom: 5),
                                                child: Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Text(
                                                      prescriptionItems![index].rate,
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontSize: MediaQuery.of(context).size.width * 0.025,
                                                        color: Colors.blueGrey,
                                                        fontWeight: FontWeight.normal,
                                                      ),
                                                    ))),
                                            /*Container(
                                              padding: const EdgeInsets.all(1),
                                              width: MediaQuery.of(context).size.width * 0.9,
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(0), color: Colors.transparent),
                                              margin: EdgeInsets.all(5),
                                              child: Html(
                                                data: prescriptionItems![index].duration + "<br>",
                                                defaultTextStyle: TextStyle(
                                                  fontSize: MediaQuery.of(context).size.width * 0.025,
                                                  color: Colors.blueGrey,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              )),*/
                                          ],
                                        )))));
                          },
                        ),
                      ),
                    ],
                  ));
            } else {
              return Container(
                  height: MediaQuery.of(context).size.height * 0.79,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    color: Colors.white38,
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        //width: MediaQuery.of(context).size.width * 0.9,
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            bottom: BorderSide(width: 5.0, color: Colors.grey),
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            print("tapped");
                            /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DashboardScreen(),
                              ));*/
                          },
                          child: Row(
                            children: <Widget>[
                              Container(
                                height: MediaQuery.of(context).size.height * 0.07,
                                width: MediaQuery.of(context).size.width * 0.2,
                                margin: EdgeInsets.only(left: 3),
                                child: CircleAvatar(
                                    backgroundColor: Colors.blue,
                                    child: Text(
                                      ProfileScreen.selectedProfile.PatientName[0],
                                      style: TextStyle(fontFamily: 'Arial', fontStyle: FontStyle.normal, fontWeight: FontWeight.bold, color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.055),
                                    )),
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height * 0.07,
                                width: 0.7,
                                color: Colors.blue,
                              ),
                              Container(
                                //color: Colors.yellow,
                                height: MediaQuery.of(context).size.height * 0.09,
                                width: MediaQuery.of(context).size.width * 0.6,
                                margin: EdgeInsets.only(left: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                            margin: EdgeInsets.all(0),
                                            color: Colors.white,
                                            height: MediaQuery.of(context).size.height * 0.03,
                                            width: MediaQuery.of(context).size.width * 0.45,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                ProfileScreen.selectedProfile.PatientName,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: MediaQuery.of(context).size.width * 0.032,
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ))
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                            margin: EdgeInsets.all(0),
                                            height: MediaQuery.of(context).size.height * 0.03,
                                            width: MediaQuery.of(context).size.width * 0.12,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                DrMohanApp.appinfoitems[0].srntxt4.split(',')[0] + ":",
                                                style: TextStyle(
                                                  fontSize: MediaQuery.of(context).size.width * 0.034,
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )),
                                        Container(
                                            height: MediaQuery.of(context).size.height * 0.03,
                                            width: MediaQuery.of(context).size.width * 0.4,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                ProfileScreen.selectedProfile.MrNo,
                                                style: TextStyle(
                                                  fontSize: MediaQuery.of(context).size.width * 0.034,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                            margin: EdgeInsets.all(0),
                                            height: MediaQuery.of(context).size.height * 0.03,
                                            width: MediaQuery.of(context).size.width * 0.1,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                DrMohanApp.appinfoitems[0].srntxt4.split(',')[1] + ": ",
                                                style: TextStyle(
                                                  fontSize: MediaQuery.of(context).size.width * 0.034,
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )),
                                        Container(
                                            height: MediaQuery.of(context).size.height * 0.03,
                                            width: MediaQuery.of(context).size.width * 0.35,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                ProfileScreen.selectedProfile.DOB.split(" ")[0],
                                                style: TextStyle(
                                                  fontSize: MediaQuery.of(context).size.width * 0.034,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(height: MediaQuery.of(context).size.height * 0.15, width: MediaQuery.of(context).size.width * 0.15, margin: EdgeInsets.only(left: 2), child: Image.network(DrMohanApp.appinfoitems[0].srntxt2 + "/images/" + ProfileScreen.selectedProfile.Gender.toLowerCase() + ".png"))
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            bottom: BorderSide(width: 5.0, color: Colors.grey),
                          ),
                        ),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(4),
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: prescriptionTitles.length,
                          itemBuilder: (BuildContext context, int index) {
                            return MouseRegion(
                                onHover: (event) {
                                  // appContainer.style.cursor = 'pointer';
                                },
                                child: Container(
                                    height: MediaQuery.of(context).size.height * 0.2,
                                    width: MediaQuery.of(context).size.width * 0.23,
                                    margin: const EdgeInsets.all(1),
                                    /* decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: <BoxShadow>[
                                    new BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                  color: Colors.white),*/
                                    child: Card(
                                        child: InkWell(
                                            onTap: () {
                                              print("tapped");
                                              String srn = prescriptionScreens[index];
                                              loadHealthRecordScreen(context, srn);
                                            },
                                            child: Column(
                                              children: <Widget>[
                                                Container(height: MediaQuery.of(context).size.height * 0.1, width: MediaQuery.of(context).size.width * 0.8, margin: EdgeInsets.only(right: 0), child: CircleAvatar(backgroundColor: Colors.white, child: Image.network(DrMohanApp.appinfoitems![0].srntxt2 + prescriptionImgUrl[index]))),
                                                Container(
                                                    margin: EdgeInsets.all(1),
                                                    child: Align(
                                                        child: Text(
                                                      prescriptionTitles[index],
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: MediaQuery.of(context).size.width * 0.030,
                                                        color: Colors.blue,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ))),
                                              ],
                                            )))));
                          },
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.46,
                        margin: EdgeInsets.all(0),
                        child: Align(alignment: Alignment.center, child: Text(OTPVerification.appscreensdataitems![32].srntxt2, textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Arial', fontStyle: FontStyle.normal, fontWeight: FontWeight.bold, color: Colors.blue, fontSize: MediaQuery.of(context).size.width * 0.055))),
                      ),
                    ],
                  ));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        tooltip: 'Dr. Mohan\'s',
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

  loadHealthRecordScreen(context, lVal) {
    print("lVal " + lVal.toLowerCase());
    if (lVal.toLowerCase() == "healthrecordscreenvisitsummary") {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HealthRecordScreen(),
          ));
    } else if (lVal.toLowerCase() == "healthrecordscreenclinicalsummary") {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HealthRecordClinicalSummaryScreenStateful(),
          ));
    } else if (lVal.toLowerCase() == "healthrecordscreenprescription") {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HealthRecordPrescriptionScreen(),
          ));
    } else if (lVal.toLowerCase() == "healthrecordscreenlabreports") {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HealthRecordLabReportsScreen(),
          ));
    }
  }
}
