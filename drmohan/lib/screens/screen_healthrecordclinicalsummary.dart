import 'package:drmohan/models/model_healthrecordclinicalsummary.dart';
import 'package:drmohan/screens/screen_healthrecord.dart';
import 'package:drmohan/screens/screen_healthrecordlabreports.dart';
import 'package:drmohan/screens/screen_healthrecordprescription.dart';
import 'package:drmohan/widgets/appbar.dart';
import 'package:drmohan/widgets/bottombar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../models/model_healthrecorditem.dart';
import '../services/http_service.dart';

class HealthRecordClinicalSummaryScreenStateful extends StatefulWidget {
  createState() {
    return HealthRecordClinicalSummaryScreen();
  }
}

class HealthRecordClinicalSummaryScreen extends State<HealthRecordClinicalSummaryScreenStateful> {
  final HttpService httpService = HttpService();
  static List<String> clinicalsummaryTitles = [];
  static List<String> clinicalsummaryImgUrl = [];
  static List<String> clinicalsummaryScreens = [];
  static List<ClinicalSummayItem> clinicalSummayItems = [];
  static List<String> yAxisStartValueList = [];
  static List<String> yAxisEndValueList = [];
  static List<String> yAxisRangeValueList = [];
  static List<String> refStartRangeList = [];
  static List<String> refEndRangeList = [];
  static List<String> testNamesList = [];
  static List<String> testIdsList = [];
  static List<String> visitDateList = [];
  static List<String> resultList = [];
  static List<String> refRangeList = [];
  static List<String> gridDataList = [];
  static List<FlSpot> spotsList = [];
  static double minimumX = 0;
  static double minimumY = 0;
  static double maximumX = 0;
  static double maximumY = 0;
  static double intervalBy = 10;
  static double startRange = 0;
  static double endRange = 0;
  static String selectedTest = "";
  static String selectedTestId = "1";
  static String selectedTestDropdownItemChanged = "false";
  callToSetAppBarTitle() => createState().setAppBarTitle("Health Record,Clinical Summary");
  @override
  AppBarWidget createState() => AppBarWidget();
  void initState() {
    selectedTestDropdownItemChanged = "false";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    callToSetAppBarTitle();
    const cutOffYValue = 0.0;
    const yearTextStyle = TextStyle(fontSize: 12, color: Colors.black);
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      extendBody: true,
      //drawer: MenuDrawerWidget(),
      appBar: AppBarWidget(),
      body: FutureBuilder(
        future: httpService.getHealthRecordClinicalSummaryItems(),
        builder: (BuildContext context, AsyncSnapshot<List<HealthRecorditem>> snapshot) {
          if (snapshot.hasData) {
            List<HealthRecorditem>? healthrecorditems = snapshot.data;
            print("visitDateList.length " + visitDateList.length.toString());
            if (visitDateList.length > 0) {
              print("ifhelathrecord");
              return Container(
                  height: MediaQuery.of(context).size.height * 0.79,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    color: Colors.white38,
                  ),
                  child: SingleChildScrollView(
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
                          itemCount: clinicalsummaryTitles.length,
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
                                              String srn = clinicalsummaryScreens[index];
                                              loadHealthRecordScreen(context, srn);
                                            },
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Container(height: MediaQuery.of(context).size.height * 0.1, width: MediaQuery.of(context).size.width * 0.8, margin: EdgeInsets.only(right: 0), child: CircleAvatar(backgroundColor: Colors.white, child: Image.network(DrMohanApp.appinfoitems![0].srntxt2 + clinicalsummaryImgUrl[index]))),
                                                Container(
                                                    margin: EdgeInsets.all(1),
                                                    child: Align(
                                                        alignment: Alignment.center,
                                                        child: Text(
                                                          clinicalsummaryTitles[index],
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
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: MediaQuery.of(context).size.width * 1,
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              bottom: BorderSide(width: 01.0, color: Colors.transparent),
                            ),
                          ),
                          child: Row(
                            children: <Widget>[
                              Container(
                                  //color: Colors.yellow,
                                  width: MediaQuery.of(context).size.width * 0.4,
                                  margin: const EdgeInsets.only(left: 10),
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        OTPVerification.appscreensdataitems![21].srntxt4.split(",")[0],
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context).size.width * 0.037,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ))),
                              Container(
                                  //color: Colors.yellow,
                                  width: MediaQuery.of(context).size.width * 0.45,
                                  margin: const EdgeInsets.only(left: 10),
                                  child: DropdownButton<String>(
                                    icon: Icon(Icons.arrow_drop_down_outlined, color: Colors.black),
                                    iconSize: 24,
                                    elevation: 5,
                                    items: HealthRecordClinicalSummaryScreen.testNamesList.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (text) {
                                      setState(() {
                                        selectedTestDropdownItemChanged = "true";
                                        selectedTest = text.toString();
                                        selectedTestId = testIdsList[testNamesList.indexOf(selectedTest)];
                                        httpService.getHealthRecordClinicalSummaryTestResultItems();
                                      });
                                    },
                                    value: selectedTest,
                                  ))
                            ],
                          )),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: MediaQuery.of(context).size.width * 0.9,
                        margin: EdgeInsets.only(top: 20, bottom: 20),
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: <BoxShadow>[
                              new BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                            color: Colors.white),
                        child: LineChart(
                          LineChartData(
                            extraLinesData: ExtraLinesData(horizontalLines: [
                              HorizontalLine(
                                y: startRange,
                                color: Colors.red.withOpacity(0.8),
                                strokeWidth: 3,
                                dashArray: [20, 2],
                              ),
                              HorizontalLine(
                                y: endRange,
                                color: Colors.green.withOpacity(0.8),
                                strokeWidth: 3,
                                dashArray: [20, 2],
                              ),
                            ]),
                            borderData: FlBorderData(
                              show: true,
                              border: const Border(
                                bottom: BorderSide(color: Color.fromRGBO(0, 0, 0, 1), width: 2),
                                left: BorderSide(color: Color.fromRGBO(0, 0, 0, 1), width: 2),
                                right: BorderSide(color: Colors.transparent),
                                top: BorderSide(color: Colors.transparent),
                              ),
                            ),
                            minY: minimumY,
                            minX: minimumX,
                            maxX: maximumX,
                            maxY: maximumY,
                            lineBarsData: [
                              LineChartBarData(
                                spots: spotsList,
                                /*spots: [
                                const FlSpot(10, 126),
                                const FlSpot(20, 96),
                                const FlSpot(30,
                                    114), //250, 267, 246 [126, 96, 114, 146]
                              ],*/
                                isCurved: false,
                                barWidth: 2,
                                colors: [
                                  Color.fromRGBO(240, 128, 128, 1),
                                ],
                                dotData: FlDotData(
                                  show: true,
                                ),
                              )
                            ],
                            gridData: FlGridData(
                              show: true,
                              /*checkToShowHorizontalLine: (double value) {
                              return value == 21 ||
                                  value == 25 ||
                                  value == 27 ||
                                  value == 4;
                            },*/
                            ),
                            titlesData: FlTitlesData(
                              /*bottomTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 10,
                              margin: 10,
                              interval: 1,
                              getTextStyles: (context, value) =>
                                  const TextStyle(
                                color: Color(0xff72719b),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              getTitles: (value) {
                                switch (value.toInt()) {
                                  case 1:
                                    return 'SEPT';
                                  case 2:
                                    return 'OCT';
                                  case 3:
                                    return 'DEC';
                                }
                                return '';
                              },
                            ),*/
                              leftTitles: SideTitles(
                                showTitles: true,
                                margin: 5,
                                interval: intervalBy,
                                textAlign: TextAlign.left,
                                reservedSize: 30,
                              ),
                              bottomTitles: SideTitles(showTitles: true, margin: 5, interval: intervalBy),
                              rightTitles: SideTitles(showTitles: false),
                              topTitles: SideTitles(showTitles: false),

                              /*leftTitles: SideTitles(
                              getTitles: (value) {
                                switch (value.toInt()) {
                                  case 2:
                                    return 'SEPT';
                                  case 7:
                                    return 'OCT';
                                  case 10:
                                    return 'DEC';
                                }
                                return '';
                              },
                              showTitles: true,
                              margin: 8,
                              interval: 1,
                              reservedSize: 40,
                              getTextStyles: (context, value) =>
                                  const TextStyle(
                                color: Color(0xff75729e),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),*/
                            ),
                          ),
                        ),
                      ),
                      Container(
                          height: MediaQuery.of(context).size.height * 0.4,
                          width: MediaQuery.of(context).size.width * 0.6,
                          margin: EdgeInsets.all(5),
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: MediaQuery.of(context).size.height * 0.07,
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.lightBlueAccent,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                    ),
                                  ),
                                  child: Center(
                                      child: Text(
                                    selectedTest + "(" + OTPVerification.appscreensdataitems![21].srntxt4.split(",")[1] + " " + resultList.length.toString() + " " + OTPVerification.appscreensdataitems![21].srntxt4.split(",")[2] + " " + ")",
                                    style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.037, fontWeight: FontWeight.bold, color: Colors.white),
                                  )),
                                ),
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height * 0.3,
                                child: GridView.count(
                                  // Create a grid with 2 columns. If you change the scrollDirection to
                                  // horizontal, this produces 2 rows.
                                  shrinkWrap: true,
                                  crossAxisCount: 2,
                                  childAspectRatio: 3,
                                  // Generate 100 widgets that display their index in the List.
                                  children: List.generate(gridDataList.length, (index) {
                                    return Container(
                                        height: MediaQuery.of(context).size.height * 0.002,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Color.fromRGBO(217, 217, 217, 1),
                                            width: 1,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            gridDataList[index],
                                            style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.037, fontWeight: FontWeight.normal, color: Color.fromRGBO(0, 0, 0, 1)),
                                          ),
                                        ));
                                  }),
                                ),
                              ),
                            ],
                          )),
                    ],
                  )));
            } else {
              print("elsehelathrecord");
              return Container(
                  height: MediaQuery.of(context).size.height * 0.79,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    color: Colors.white38,
                  ),
                  child: SingleChildScrollView(
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
                          itemCount: clinicalsummaryTitles.length,
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
                                              String srn = clinicalsummaryScreens[index];
                                              loadHealthRecordScreen(context, srn);
                                            },
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Container(height: MediaQuery.of(context).size.height * 0.1, width: MediaQuery.of(context).size.width * 0.8, margin: EdgeInsets.only(right: 0), child: CircleAvatar(backgroundColor: Colors.white, child: Image.network(DrMohanApp.appinfoitems![0].srntxt2 + clinicalsummaryImgUrl[index]))),
                                                Container(
                                                    margin: EdgeInsets.all(1),
                                                    child: Align(
                                                        alignment: Alignment.center,
                                                        child: Text(
                                                          clinicalsummaryTitles[index],
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
                  )));
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
    if (lVal.toLowerCase() == "healthrecordscreenvisitsummary") {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HealthRecordScreen(),
          ));
    } else if (lVal.toLowerCase() == "healthrecordscreenclinicalsummary") {
      /*Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HealthRecordClinicalSummaryScreen(),
          ));*/
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
