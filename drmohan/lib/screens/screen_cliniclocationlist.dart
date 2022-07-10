import 'package:drmohan/models/model_bookappointmentlocationitem.dart';
import 'package:drmohan/widgets/appbar.dart';
import 'package:drmohan/widgets/bottombar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../main.dart';
import '../services/http_service.dart';

class ClinicLocationScreenState extends StatefulWidget {
  createState() {
    return ClinicLocationScreen();
  }
}

class ClinicLocationScreen extends State<ClinicLocationScreenState> {
  final HttpService httpService = HttpService();
  late GoogleMapController clinicmapController;

  static LatLng _center = const LatLng(12.9716, 77.5946);
  static List<Marker> _clinicmarkers = <Marker>[];

  void _onMapCreated(GoogleMapController controller) {
    clinicmapController = controller;
  }

  static Locationitem clinicselectedLocator = [] as Locationitem;
  static String clinicdatareceived = "false";
  static List<Locationitem> duplicateclinicSearchLocationitems = [];
  static List<Locationitem> clinicSearchLocationitems = [];

  callToSetAppBarTitle() => createState().setAppBarTitle(OTPVerification.appscreensdataitems![6].srntxt1);
  static String clinicsearchString = "";

  @override
  AppBarWidget createState() => AppBarWidget();

  clinicFilterSearchResults(String query) {
    if (query.isNotEmpty) {
      List<Locationitem> dummySearchList = <Locationitem>[];
      clinicSearchLocationitems.forEach((item) {
        if (item.City.toLowerCase().toString().contains(query.toString())) {
          dummySearchList.add(item);
        }
      });
      setState(() {
        clinicSearchLocationitems.clear();
        clinicSearchLocationitems.addAll(dummySearchList);
        /*clinicSearchLocationitems = clinicSearchLocationitems.where((o) =>
            o.City.toLowerCase().toString() ==
            query.toLowerCase().toString()).toList();*/
      });

      /*List<Locationitem> dummyListData = <Locationitem>[];
      dummySearchList.forEach((item) {
        print(item.City.toLowerCase().toString().contains(query.toString()));
        print(item.City.toLowerCase().toString() +
            " contains " +
            query.toString());
        if (item.City.toLowerCase().toString().contains(query.toString())) {
          dummyListData.add(item);
        }
      });
      print(dummyListData.length);
      setState(() {
        clinicSearchLocationitems.clear();
        clinicSearchLocationitems.addAll(dummyListData);
        //clinicSearchLocationitems = dummyListData;
        */ /*items.clear();
        items.addAll(dummyListData);*/ /*
      });
      return;*/
    } else {
      setState(() {
        clinicdatareceived = "false";
        //clinicSearchLocationitems.clear();
        //clinicSearchLocationitems.addAll(duplicateclinicSearchLocationitems);
      });
    }
  }

  void setCenterClinic(index) {
    setState(() {
      double lat = double.parse(clinicSearchLocationitems[index].Lattitude);
      double lon = double.parse(clinicSearchLocationitems[index].Longitude);
      _center = LatLng(lat, lon);
      clinicmapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: _center, zoom: 11)
          //17 is new zoom level
          ));
    });
  }

  static setClinicMarkers() {
    if (clinicSearchLocationitems.length > 0) {
      double lat = double.parse(clinicSearchLocationitems[0].Lattitude);
      double lon = double.parse(clinicSearchLocationitems[0].Longitude);
      _center = LatLng(lat, lon);
      for (var i = 0; i < clinicSearchLocationitems.length; i++) {
        _clinicmarkers.add(Marker(markerId: MarkerId(clinicSearchLocationitems[i].LocID), position: LatLng(double.parse(clinicSearchLocationitems[i].Lattitude), double.parse(clinicSearchLocationitems[i].Longitude)), infoWindow: InfoWindow(title: clinicSearchLocationitems[i].LocName)));
      }
    }
  }

  @override
  void initState() {
    clinicdatareceived = "false";
    if (clinicSearchLocationitems.length > 0) {
      setClinicMarkers();
    }
    super.initState();
  }

  Widget build(BuildContext context) {
    callToSetAppBarTitle();
    //clinicdatareceived = "false";
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      extendBody: true,
      //drawer: MenuDrawerWidget(),
      appBar: AppBarWidget(),
      body: FutureBuilder(
        future: httpService.getClinicLocationItems(),
        builder: (BuildContext context, AsyncSnapshot<List<Locationitem>> snapshot) {
          if (snapshot.hasData) {
            List<Locationitem>? locationitems = snapshot.data;
            print(locationitems!.length);
            print(locationitems);
            print("locationitems");
            if (locationitems!.length > 0) {
              return Container(
                  height: MediaQuery.of(context).size.height * 0.83,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1),
                    color: Colors.white10,
                  ),
                  child: SingleChildScrollView(
                      child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.1,
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
                                      style: TextStyle(fontFamily: 'Arial', fontStyle: FontStyle.normal, fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25),
                                    )),
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height * 0.07,
                                width: 0.7,
                                color: Colors.blue,
                              ),
                              Container(
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
                                                  fontSize: MediaQuery.of(context).size.width * 0.030,
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
                                            width: MediaQuery.of(context).size.width * 0.09,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                DrMohanApp.appinfoitems![0].srntxt4.split(',')[0] + ":",
                                                style: TextStyle(
                                                  fontSize: MediaQuery.of(context).size.width * 0.030,
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
                                                ProfileScreen.selectedProfile.MrNo,
                                                style: TextStyle(
                                                  fontSize: MediaQuery.of(context).size.width * 0.030,
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
                                                DrMohanApp.appinfoitems![0].srntxt4.split(',')[1] + ": ",
                                                style: TextStyle(
                                                  fontSize: MediaQuery.of(context).size.width * 0.030,
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
                                                  fontSize: MediaQuery.of(context).size.width * 0.030,
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
                              /*Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                width: MediaQuery.of(context).size.width * 0.5,
                                margin: EdgeInsets.only(left: 10),
                                child: Html(
                                  data:
                                      //'${profiles![index].name + "<br>Dob: " + profiles![index].dob + "<br>MRN: " + profiles![index].mrn.toString()}',
                                      ProfileScreen
                                              .selectedProfile.PatientName +
                                          "<br>" +
                                          DrMohanApp.appinfoitems![0].srntxt4
                                              .split(',')[0] +
                                          ": " +
                                          ProfileScreen.selectedProfile.MrNo +
                                          "<br>" +
                                          DrMohanApp.appinfoitems![0].srntxt4
                                              .split(',')[1] +
                                          ": " +
                                          ProfileScreen.selectedProfile.DOB
                                              .split(" ")[0],
                                )),*/
                              Container(height: MediaQuery.of(context).size.height * 0.15, width: MediaQuery.of(context).size.width * 0.15, margin: EdgeInsets.only(left: 2), child: Image.network(DrMohanApp.appinfoitems![0].srntxt2 + "/images/" + ProfileScreen.selectedProfile.Gender.toLowerCase() + ".png"))
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.25,
                        width: MediaQuery.of(context).size.width * 0.95,
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            bottom: BorderSide(width: 0.0, color: Colors.transparent),
                          ),
                        ),
                        child: GoogleMap(
                            /*mapType: MapType.normal,
                          rotateGesturesEnabled: false,
                          tiltGesturesEnabled: false,
                          mapToolbarEnabled: false,
                          myLocationEnabled: false,
                          myLocationButtonEnabled: false,
                          zoomControlsEnabled: false,*/
                            markers: Set<Marker>.of(_clinicmarkers),
                            onMapCreated: _onMapCreated,
                            initialCameraPosition: CameraPosition(
                              target: _center,
                              zoom: 7.0,
                            )),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.45,
                        margin: EdgeInsets.all(0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    clinicsearchString = value.toLowerCase();
                                    clinicFilterSearchResults(clinicsearchString);
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: 'Search  ',
                                  suffixIcon: Icon(Icons.search),
                                ),
                              ),
                            ),
                            Expanded(
                                child: ListView.builder(
                                    padding: const EdgeInsets.all(0),
                                    shrinkWrap: true,
                                    //physics: NeverScrollableScrollPhysics(),
                                    itemCount: clinicSearchLocationitems?.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return MouseRegion(
                                          onHover: (event) {
                                            // appContainer.style.cursor = 'pointer';
                                          },
                                          child: Container(
                                              /*height:
                                          MediaQuery.of(context).size.height *
                                              0.1,*/
                                              margin: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(width: 1.0, color: Colors.blue),
                                                    top: BorderSide(width: 1.0, color: Colors.blue),
                                                    right: BorderSide(width: 1.0, color: Colors.blue),
                                                    left: BorderSide(width: 1.0, color: Colors.blue),
                                                  ),
                                                  borderRadius: BorderRadius.circular(5),
                                                  boxShadow: <BoxShadow>[
                                                    new BoxShadow(
                                                      color: Colors.grey.withOpacity(0.5),
                                                      spreadRadius: 5,
                                                      blurRadius: 7,
                                                      offset: Offset(0, 3),
                                                    ),
                                                  ],
                                                  color: Colors.white),
                                              child: InkWell(
                                                  onTap: () {
                                                    clinicselectedLocator = clinicSearchLocationitems![index];
                                                    /* BookAppointmentScreen.lastVisitedLocId = clinicselectedLocator.LocID;
                                                    BookAppointmentScreen.lastVisitedLocName = clinicselectedLocator.LocName;
                                                    BookAppointmentScreen.lastVisitedLocationDetailsChanged = "true";
                                                    RazorPaymentScreenState.selectedLat = clinicselectedLocator.Lattitude;
                                                    RazorPaymentScreenState.selectedLon = clinicselectedLocator.Longitude;*/
                                                    setCenterClinic(index);
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                          decoration: BoxDecoration(
                                                            border: Border(
                                                              bottom: BorderSide(width: 1.0, color: Colors.black),
                                                              top: BorderSide(width: 1.0, color: Colors.black),
                                                              right: BorderSide(width: 1.0, color: Colors.black),
                                                              left: BorderSide(width: 1.0, color: Colors.black),
                                                            ),
                                                          ),
                                                          margin: EdgeInsets.only(left: 0),
                                                          height: MediaQuery.of(context).size.height * 0.2,
                                                          width: MediaQuery.of(context).size.width * 0.3,
                                                          child: Image.network(clinicSearchLocationitems![index].ImgUrl, fit: BoxFit.fill)),
                                                      Container(
                                                        width: MediaQuery.of(context).size.width * 0.6,
                                                        child: Column(
                                                          children: <Widget>[
                                                            Container(
                                                                padding: const EdgeInsets.all(1),
                                                                width: MediaQuery.of(context).size.width * 0.9,
                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(0), color: Colors.transparent),
                                                                margin: EdgeInsets.all(5),
                                                                child: Html(
                                                                  data: clinicSearchLocationitems![index].LocName,
                                                                  defaultTextStyle: TextStyle(
                                                                    fontSize: MediaQuery.of(context).size.width * 0.037,
                                                                    color: Colors.blue,
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                )),
                                                            Container(
                                                                padding: const EdgeInsets.all(1),
                                                                width: MediaQuery.of(context).size.width * 0.9,
                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(0), color: Colors.transparent),
                                                                margin: EdgeInsets.all(5),
                                                                child: Html(
                                                                  data: clinicSearchLocationitems![index].Address,
                                                                  defaultTextStyle: TextStyle(
                                                                    fontSize: MediaQuery.of(context).size.width * 0.025,
                                                                    color: Colors.blueGrey,
                                                                    fontWeight: FontWeight.normal,
                                                                  ),
                                                                )),
                                                            /*Container(
                                                padding:
                                                    const EdgeInsets.all(1),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.9,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0),
                                                    color: Colors.transparent),
                                                margin: EdgeInsets.all(5),
                                                child: Html(
                                                  data: OTPVerification
                                                      .appscreensdataitems![7]
                                                      .srntxt2,
                                                  defaultTextStyle: TextStyle(
                                                    fontSize: MediaQuery.of(context).size.width * 0.025,
                                                    color: Colors.blueGrey,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                )),*/
                                                            /*Container(
                                              padding: const EdgeInsets.all(1),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(0),
                                                  color: Colors.transparent),
                                              margin: EdgeInsets.all(5),
                                              child: Html(
                                                data:
                                                    locationitems![index].Phone,
                                                defaultTextStyle: TextStyle(
                                                  fontSize: MediaQuery.of(context).size.width * 0.025,
                                                  color: Colors.blueGrey,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ))*/
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ))));
                                    })),
                          ],
                        ),
                      ),
                    ],
                  )));
            } else {
              return Align(alignment: Alignment.center, child: Text(OTPVerification.appscreensdataitems![32].srntxt2, textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Arial', fontStyle: FontStyle.normal, fontWeight: FontWeight.bold, color: Colors.blue, fontSize: MediaQuery.of(context).size.width * 0.055)));
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
}
