import 'dart:convert';

// ignore: import_of_legacy_library_into_null_safe
import 'package:drmohan/main.dart';
import 'package:drmohan/models/model_appinfo.dart';
import 'package:drmohan/models/model_appscreensdata.dart';
import 'package:drmohan/models/model_bookappointmentlocationitem.dart';
import 'package:drmohan/models/model_fooddetailitem.dart';
import 'package:drmohan/models/model_foodportiondetail.dart';
import 'package:drmohan/models/model_healthrecordclinicalsummary.dart';
import 'package:drmohan/models/model_healthrecordlabreport.dart';
import 'package:drmohan/models/model_healthrecordprescription.dart';
import 'package:drmohan/models/model_healthrecordvisitsummary.dart';
import 'package:drmohan/models/model_healthtrackeritem.dart';
import 'package:drmohan/models/model_healthtrackerrecord.dart';
import 'package:drmohan/models/model_notifiesitem.dart';
import 'package:drmohan/models/model_spotlightitem.dart';
import 'package:drmohan/models/model_testlistdetailitem.dart';
import 'package:drmohan/models/model_testresultitem.dart';
import 'package:drmohan/screens/screen_cliniclocationlist.dart';
import 'package:drmohan/screens/screen_healthrecord.dart';
import 'package:drmohan/screens/screen_healthrecordclinicalsummary.dart';
import 'package:drmohan/screens/screen_healthrecordlabreports.dart';
import 'package:drmohan/screens/screen_healthrecordprescription.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';

import '../models/model_dashboarditem.dart';
import '../models/model_healthrecorditem.dart';
import '../models/model_ordersitem.dart';
import '../models/model_profile.dart';

class HttpService {
  String postsURL = ""; //"https://jsonplaceholder.typicode.com/posts";
  //"https://rsolutions7.com/drmohan/languages/en_us/profiles.json";
  static Map<String, String> headersWithBearer = {"Content-Type": "application/json", "authorization": "Bearer " + OTPVerification.tokenstr};

  getHeadersWithBearer() {
    return headersWithBearer = {"Content-Type": "application/json", "authorization": "Bearer " + OTPVerification.tokenstr};
  }

  Future<List<AppInfoItem>> getAppInfoData() async {
    //postsURL = "https://rsolutions7.com/drmohan/languages/en_us/appscreensdata.json";

    postsURL = "https://rsolutions7.com/drmohan/languages/en_us/appinfo.json";
    Response res = await get(Uri.parse(postsURL));
    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);

      List<AppInfoItem> appinfoitemitems = body
          .map(
            (dynamic item) => AppInfoItem.fromJson(item),
          )
          .toList();
      print(appinfoitemitems.toString());
      return appinfoitemitems;
    } else {
      throw "Unable to retrieve posts.";
    }
  }

  Future<List<AppScreensDataItem>> getAppScreensData() async {
    //postsURL = "https://rsolutions7.com/drmohan/languages/en_us/appscreensdata.json";
    postsURL = "https://rsolutions7.com/drmohan/languages/" + DrMohanApp.appinfoitems![0].srntxt1 + "/appscreensdata.json";

    Response res = await get(Uri.parse(postsURL));

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);

      List<AppScreensDataItem> appscreensdataitem = body
          .map(
            (dynamic item) => AppScreensDataItem.fromJson(item),
          )
          .toList();
      return appscreensdataitem;
    } else {
      throw "Unable to retrieve posts.";
    }
  }

  Future createArray() async {
    Map<String, dynamic> myObject = {'Code': "mycode", 'Name': "", 'Rate': "", 'Type': "", 'Qty': "", 'Amount': "", 'TotalAmount': ""};

    List<Map<String, dynamic>> send = [];
    send.add(myObject);
    send[0]["Code"] = "code123";
  }

  Future getOTP() async {
    postsURL = "http://drmohansdiabetes.net/dmdscwebapi/api/SendOTP";
    var body = "";
    ProfileScreen.requestTypeStr = "mrn";
    if (OTPVerification.getotpstr.length > 10) {
      final postData = {"UserID": "Rihas", "Pwd": "Riha123", "MrNo": OTPVerification.getotpstr, "Channel": "App"};
      body = json.encode(postData);
    } else {
      final postData = {"UserID": "Rihas", "Pwd": "Riha123", "Phone": OTPVerification.getotpstr, "Channel": "App"};
      ProfileScreen.requestTypeStr = "mobile";
      body = json.encode(postData);
    }

    //"TEMPTNGPM004238",
    //{"Phone":"9698694094","Mrno":"TEMPTNGPM004238","OTP":"1234","TokenValue":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJSaWhhcyIsImp0aSI6IjUxYTUyY2RjLTA4NDYtNDYzZi1iMjRjLWY3ZGViMDA1NTIzYyIsImV4cCI6MTY0NjU2NTcxMiwiaXNzIjoiaHR0cDovL2xvY2FsaG9zdCIsImF1ZCI6Imh0dHA6Ly9sb2NhbGhvc3QifQ.eYKhJtQOaZOop2FmRTmM4M5Z5yydqpb86OlQUKlT7Z8","Status":"Success","Channel":"App"}
    //encode Map to JSON
    var res = await post(Uri.parse(postsURL), headers: {"Content-Type": "application/json"}, body: body);
    if (res.statusCode == 200) {
      var jsonData = jsonDecode(res.body);
      if ((jsonData["Status"].toString().toLowerCase().replaceAll(" ", "") == "fails")) {
        Fluttertoast.showToast(msg: OTPVerification.appscreensdataitems[1].srntxt7, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.SNACKBAR, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
        return;
      }
      if (jsonData["Status"].toString().toLowerCase().replaceAll(" ", "") != "norecords") {
        //final data = jsonDecode(res.body).decoded['OTP'];
        OTPVerification.phone = jsonData["Phone"].toString();
        OTPVerification.OTPsenttophonemsg = OTPVerification.appscreensdataitems[1].srntxt3 + OTPVerification.phone;
        /*OTPVerification.otptxt1 = jsonData["OTP"][0];
      OTPVerification.otptxt2 = jsonData["OTP"][1];
      OTPVerification.otptxt3 = jsonData["OTP"][2];
      OTPVerification.otptxt4 = jsonData["OTP"][3];*/
        OTPVerification.updateOTPTexts(jsonData["OTP"]);
        OTPVerification.verifyotpstr = jsonData["OTP"].toString();
        OTPVerification.tokenstr = jsonData["TokenValue"].toString();
        OTPVerification.OTPreceived = true;
      } else {
        Fluttertoast.showToast(msg: OTPVerification.appscreensdataitems[1].srntxt7, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.SNACKBAR, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 20.0);
      }
    } else {
      throw "Unable to retrieve posts.";
    }
  }

  Future verifyOTP() async {
    postsURL = "http://drmohansdiabetes.net/dmdscwebapi/api/VerifyOTP";
    var body = "";
    final postData = {"Phone": OTPVerification.phone, "OTP": OTPVerification.verifyotpstr, "Channel": "App"};
    body = json.encode(postData);

    //"TEMPTNGPM004238",
    //{"Phone":"9698694094","Mrno":"TEMPTNGPM004238","OTP":"1234","TokenValue":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJSaWhhcyIsImp0aSI6IjUxYTUyY2RjLTA4NDYtNDYzZi1iMjRjLWY3ZGViMDA1NTIzYyIsImV4cCI6MTY0NjU2NTcxMiwiaXNzIjoiaHR0cDovL2xvY2FsaG9zdCIsImF1ZCI6Imh0dHA6Ly9sb2NhbGhvc3QifQ.eYKhJtQOaZOop2FmRTmM4M5Z5yydqpb86OlQUKlT7Z8","Status":"Success","Channel":"App"}
    //encode Map to JSON
    final headersWithBearer = {"Content-Type": "application/json", "authorization": "Bearer " + OTPVerification.tokenstr};
    var res = await post(Uri.parse(postsURL), headers: headersWithBearer, body: body);

    if (res.statusCode == 200) {
      print(res.body);
      print("verifyOTP");
      if (res.body.replaceAll('"', '') == '1') {
        OTPVerification.loadProfileScreen();
      }
    } else {
      throw "Unable to retrieve posts.";
    }
  }

  Future checkUserLoggedin() async {
    postsURL = "http://drmohansdiabetes.net/dmdscwebapi/api/VerifyOTP";
    var body = "";
    final postData = {"Phone": OTPVerification.phone, "OTP": OTPVerification.verifyotpstr, "Channel": "App"};
    body = json.encode(postData);

    //"TEMPTNGPM004238",
    //{"Phone":"9698694094","Mrno":"TEMPTNGPM004238","OTP":"1234","TokenValue":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJSaWhhcyIsImp0aSI6IjUxYTUyY2RjLTA4NDYtNDYzZi1iMjRjLWY3ZGViMDA1NTIzYyIsImV4cCI6MTY0NjU2NTcxMiwiaXNzIjoiaHR0cDovL2xvY2FsaG9zdCIsImF1ZCI6Imh0dHA6Ly9sb2NhbGhvc3QifQ.eYKhJtQOaZOop2FmRTmM4M5Z5yydqpb86OlQUKlT7Z8","Status":"Success","Channel":"App"}
    //encode Map to JSON
    final headersWithBearer = {"Content-Type": "application/json", "authorization": "Bearer " + OTPVerification.tokenstr};
    var res = await post(Uri.parse(postsURL), headers: headersWithBearer, body: body);

    if (res.statusCode == 200) {
      print(res.body);
      print("checkUserLoggedin");
      if (res.body.replaceAll('"', '') == '1') {
      } else {}
    } else {
      throw "Unable to retrieve posts.";
    }
  }

  Future<List<Profile>> getProfiles() async {
    var body = "";
    if (ProfileScreen.requestTypeStr == "mrn") {
      final postData = {"MrNo": OTPVerification.getotpstr, "Channel": "App"};
      body = json.encode(postData);
      postsURL = "http://drmohansdiabetes.net/dmdscwebapi/api/GetPatientDetails";
    } else {
      final postData = {"Phone": OTPVerification.phone, "Channel": "App"};
      body = json.encode(postData);
      postsURL = "http://drmohansdiabetes.net/dmdscwebapi/api/GetPatientDetailsbyMobile";
    }
    var res = await post(Uri.parse(postsURL), headers: getHeadersWithBearer(), body: body);
    if (res.statusCode == 200) {
      var jsonData = jsonDecode(res.body);
      List<dynamic> body = jsonData["lstdata"];
      List<Profile> profiles = body
          .map(
            (dynamic item) => Profile.fromJson(item),
          )
          .toList();
      ProfileScreen.profilescreenloaded = "true";
      if (profiles.length == 1) {
        ProfileScreen.selectedProfile = profiles[0];
        ProfileScreen.loadDashboardForSingleProfile();
      }
      return profiles;
      /*List<dynamic> body = jsonDecode(res.body);
      List<Profile> profiles = body
          .map(
            (dynamic item) => Profile.fromJson(item),
          )
          .toList();
      return profiles;*/
    } else {
      throw "Unable to retrieve posts.";
    }
  }

  Future<List<Dashboarditem>> getDashboardItems() async {
    DashboardScreen.dashboardTitles = OTPVerification.appscreensdataitems![3].srntxt5.split(',');
    DashboardScreen.dashboardImgUrl = OTPVerification.appscreensdataitems![3].srntxt6.split(',');
    DashboardScreen.dashboardScreens = OTPVerification.appscreensdataitems![3].srntxt7.split(',');
    var body = "";
    postsURL = 'http://drmohansdiabetes.net/dmdscwebapi/api/GetDashboard';
    final postData = {"MrNo": ProfileScreen.selectedProfile.MrNo, "Channel": "App"};
    body = json.encode(postData);
    final headersWithBearer = {"Content-Type": "application/json", "authorization": "Bearer " + OTPVerification.tokenstr};
    var res = await post(Uri.parse(postsURL), headers: headersWithBearer, body: body);
    if (res.statusCode == 200) {
      var jsonData = jsonDecode(res.body);
      List<dynamic> tempspotLights = jsonData["spotLights"];
      DashboardScreen.spotLights = tempspotLights
          .map(
            (dynamic item) => SpotLightitem.fromJson(item),
          )
          .toList();
      List<dynamic> tempnotifies = jsonData["notifies"];
      DashboardScreen.notifies = tempnotifies
          .map(
            (dynamic item) => Notifiesitem.fromJson(item),
          )
          .toList();
      DashboardScreen.carouselList = [];
      for (var i = 0; i < jsonData["spotLights"].length; i++) {
        if (jsonData["spotLights"][i]["linkType"].toString().toLowerCase() == "image") {
          DashboardScreen.carouselList.add(jsonData["spotLights"][i]["link"]);
          DashboardScreen.carousellinkTypeList.add(jsonData["spotLights"][i]["linkType"]);
        }
      }
      return [];
    } else {
      throw "Unable to retrieve posts.";
    }
  }

  Future<String> uploadFiles(List<String> paths) async {
    Uri uri = Uri.parse('https://rsolutions7.com/drmohan');
    MultipartRequest request = MultipartRequest('POST', uri);
    for (String path in paths) {
      request.files.add(await MultipartFile.fromPath('files', path));
    }

    StreamedResponse response = await request.send();
    var responseBytes = await response.stream.toBytes();
    var responseString = utf8.decode(responseBytes);
    print('\n\n');
    print('RESPONSE WITH HTTP');
    print(responseString);
    print('\n\n');
    return responseString;
  }

  Future<List<Locationitem>> getClinicLocationItems() async {
    postsURL = "http://drmohansdiabetes.net/dmdscwebapi/api/GetBranchList";
    var body = "";
    final postData = {"Channel": "App"};
    body = json.encode(postData);

    final headersWithBearer = {"Content-Type": "application/json", "authorization": "Bearer " + OTPVerification.tokenstr};
    var res = await post(Uri.parse(postsURL), headers: headersWithBearer, body: body);

    if (res.statusCode == 200) {
      var jsonData = jsonDecode(res.body);
      List<dynamic> body = jsonData["brnLst"];
      List<Locationitem> locationitems = body
          .map(
            (dynamic item) => Locationitem.fromJson(item),
          )
          .toList();

      if (ClinicLocationScreen.clinicsearchString.isEmpty) {
        ClinicLocationScreen.clinicSearchLocationitems = locationitems;
        ClinicLocationScreen.duplicateclinicSearchLocationitems = locationitems;
        ClinicLocationScreen.setClinicMarkers();
        //ClinicLocationScreen.clinicdatareceived = "true";
        //return [];
      }
      print(locationitems.length);
      print("locationitems");
      return locationitems;
    } else {
      throw "Unable to retrieve posts.";
    }
  }

  Future<List<HealthRecorditem>> getHealthRecordClinicalSummaryItems() async {
    HealthRecordClinicalSummaryScreen.clinicalsummaryTitles = OTPVerification.appscreensdataitems![21].srntxt2.split(',');
    HealthRecordClinicalSummaryScreen.clinicalsummaryImgUrl = OTPVerification.appscreensdataitems![21].srntxt5.split(',');
    HealthRecordClinicalSummaryScreen.clinicalsummaryScreens = OTPVerification.appscreensdataitems![21].srntxt6.split(',');
    var body = "";
    postsURL = 'http://drmohansdiabetes.net/dmdscwebapi/api/GetTestList';
    final postData = {
      //"MrNo": ProfileScreen.selectedProfile.MrNo,
      //"MrNo": "TNGPM0000219100",
      "Channel": "App"
    };
    body = json.encode(postData);

    final headersWithBearer = {"Content-Type": "application/json", "authorization": "Bearer " + OTPVerification.tokenstr};
    var res = await post(Uri.parse(postsURL), headers: headersWithBearer, body: body);
    if (res.statusCode == 200) {
      var jsonData = jsonDecode(res.body);
      List<dynamic> tempClinicalSummaryItems = jsonData["testList"];
      HealthRecordClinicalSummaryScreen.clinicalSummayItems = tempClinicalSummaryItems
          .map(
            (dynamic item) => ClinicalSummayItem.fromJson(item),
          )
          .toList();
      HealthRecordClinicalSummaryScreen.testNamesList = [];
      HealthRecordClinicalSummaryScreen.testIdsList = [];
      HealthRecordClinicalSummaryScreen.yAxisStartValueList = [];
      HealthRecordClinicalSummaryScreen.yAxisEndValueList = [];
      HealthRecordClinicalSummaryScreen.yAxisRangeValueList = [];
      HealthRecordClinicalSummaryScreen.refStartRangeList = [];
      HealthRecordClinicalSummaryScreen.refEndRangeList = [];
      for (var i = 0; i < tempClinicalSummaryItems.length; i++) {
        HealthRecordClinicalSummaryScreen.testNamesList.add(tempClinicalSummaryItems[i]["TestShName"]);
        HealthRecordClinicalSummaryScreen.testIdsList.add(tempClinicalSummaryItems[i]["TestID"]);

        HealthRecordClinicalSummaryScreen.yAxisStartValueList.add(tempClinicalSummaryItems[i]["YAxisStartValue"]);
        HealthRecordClinicalSummaryScreen.yAxisEndValueList.add(tempClinicalSummaryItems[i]["YAxisEndValue"]);
        HealthRecordClinicalSummaryScreen.yAxisRangeValueList.add(tempClinicalSummaryItems[i]["YAxisRange"]);
        HealthRecordClinicalSummaryScreen.refStartRangeList.add(tempClinicalSummaryItems[i]["StartReferenceRange"]);
        HealthRecordClinicalSummaryScreen.refEndRangeList.add(tempClinicalSummaryItems[i]["EndReferenceRange"]);
      }
      if (HealthRecordClinicalSummaryScreen.selectedTestDropdownItemChanged == "false") {
        HealthRecordClinicalSummaryScreen.selectedTest = HealthRecordClinicalSummaryScreen.testNamesList[0];
        HealthRecordClinicalSummaryScreen.selectedTestId = HealthRecordClinicalSummaryScreen.testIdsList[HealthRecordClinicalSummaryScreen.testNamesList.indexOf(HealthRecordClinicalSummaryScreen.selectedTest)];
        getHealthRecordClinicalSummaryTestResultItems();
      }
      return [];
    } else {
      throw "Unable to retrieve posts.";
    }
  }

  Future<List<HealthRecorditem>> getHealthRecordClinicalSummaryTestResultItems() async {
    var body = "";
    postsURL = 'http://drmohansdiabetes.net/dmdscwebapi/api/GetTestResultList';
    final postData = {
      //"MrNo": "TNGPM0000050459",
      "MrNo": ProfileScreen.selectedProfile.MrNo,
      "TestID": HealthRecordClinicalSummaryScreen.selectedTestId,
      "Channel": "App"
    };
    body = json.encode(postData);
    final headersWithBearer = {"Content-Type": "application/json", "authorization": "Bearer " + OTPVerification.tokenstr};
    var res = await post(Uri.parse(postsURL), headers: headersWithBearer, body: body);
    if (res.statusCode == 200) {
      var jsonData = jsonDecode(res.body);
      List<dynamic> tempClinicalSummaryTestResultItems = [];
      tempClinicalSummaryTestResultItems = jsonData["testResults"];
      print(tempClinicalSummaryTestResultItems);
      print(tempClinicalSummaryTestResultItems.length);
      print("tempClinicalSummaryTestResultItems");
      if (tempClinicalSummaryTestResultItems.length > 1) {
        print(tempClinicalSummaryTestResultItems.length);
        print("---");
        HealthRecordClinicalSummaryScreen.visitDateList = [];
        HealthRecordClinicalSummaryScreen.resultList = [];
        HealthRecordClinicalSummaryScreen.refRangeList = [];
        HealthRecordClinicalSummaryScreen.gridDataList = [];
        for (var i = 0; i < tempClinicalSummaryTestResultItems.length; i++) {
          HealthRecordClinicalSummaryScreen.visitDateList.add(tempClinicalSummaryTestResultItems[i]["VisitDate"]);
          HealthRecordClinicalSummaryScreen.resultList.add(tempClinicalSummaryTestResultItems[i]["Result"]);
          HealthRecordClinicalSummaryScreen.refRangeList.add(tempClinicalSummaryTestResultItems[i]["RefRange"]);
          HealthRecordClinicalSummaryScreen.gridDataList.add(tempClinicalSummaryTestResultItems[i]["VisitDate"].split(" ")[0]);
          HealthRecordClinicalSummaryScreen.gridDataList.add(tempClinicalSummaryTestResultItems[i]["Result"].toString());
        }
        //String xVal = HealthRecordClinicalSummaryScreen.yAxisStartValueList
        int incrementIndex = HealthRecordClinicalSummaryScreen.testIdsList.indexOf(HealthRecordClinicalSummaryScreen.selectedTestId);
        int incrementBy = int.parse(HealthRecordClinicalSummaryScreen.yAxisRangeValueList[incrementIndex]);
        HealthRecordClinicalSummaryScreen.intervalBy = incrementBy.toDouble();

        HealthRecordClinicalSummaryScreen.minimumX = double.parse(HealthRecordClinicalSummaryScreen.yAxisStartValueList[incrementIndex]);
        HealthRecordClinicalSummaryScreen.minimumY = double.parse(HealthRecordClinicalSummaryScreen.yAxisStartValueList[incrementIndex]);
        HealthRecordClinicalSummaryScreen.maximumX = double.parse(HealthRecordClinicalSummaryScreen.yAxisEndValueList[incrementIndex]);
        HealthRecordClinicalSummaryScreen.maximumY = double.parse(HealthRecordClinicalSummaryScreen.yAxisEndValueList[incrementIndex]);

        HealthRecordClinicalSummaryScreen.startRange = double.parse(HealthRecordClinicalSummaryScreen.refStartRangeList[incrementIndex]);
        HealthRecordClinicalSummaryScreen.endRange = double.parse(HealthRecordClinicalSummaryScreen.refEndRangeList[incrementIndex]);

        List<int> xValList = [];
        int xStart = int.parse(HealthRecordClinicalSummaryScreen.yAxisStartValueList[incrementIndex]);
        for (var i = 0; i < HealthRecordClinicalSummaryScreen.resultList.length; i++) {
          xStart = xStart + incrementBy;
          xValList.add(xStart);
        }

        HealthRecordClinicalSummaryScreen.spotsList = HealthRecordClinicalSummaryScreen.resultList.asMap().entries.map((e) {
          return FlSpot(xValList[e.key.toInt()].toDouble(), int.parse(HealthRecordClinicalSummaryScreen.resultList[e.key.toInt()]).toDouble());
        }).toList();
      } else {}
      return [];
    } else {
      throw "Unable to retrieve posts.";
    }
  }

  Future<List<HealthRecorditem>> getHealthRecordVisitSummaryItems() async {
    HealthRecordScreen.healthrecordTitles = OTPVerification.appscreensdataitems![21].srntxt2.split(',');
    HealthRecordScreen.healthrecordImgUrl = OTPVerification.appscreensdataitems![21].srntxt5.split(',');
    HealthRecordScreen.healthrecordScreens = OTPVerification.appscreensdataitems![21].srntxt6.split(',');
    var body = "";
    postsURL = 'http://drmohansdiabetes.net/dmdscwebapi/api/GetVisitSummary';
    final postData = {
      "MrNo": ProfileScreen.selectedProfile.MrNo,
      //"MrNo": "TNGPM0000219100",
      "Channel": "App"
    };
    body = json.encode(postData);

    final headersWithBearer = {"Content-Type": "application/json", "authorization": "Bearer " + OTPVerification.tokenstr};
    var res = await post(Uri.parse(postsURL), headers: headersWithBearer, body: body);
    if (res.statusCode == 200) {
      var jsonData = jsonDecode(res.body);
      List<dynamic> tempVisitSummaryItems = jsonData["Visits"];
      if (tempVisitSummaryItems != null) {
        HealthRecordScreen.visitSummayItems = tempVisitSummaryItems
            .map(
              (dynamic item) => VisitSummayItem.fromJson(item),
            )
            .toList();
      } else {
        HealthRecordScreen.visitSummayItems = [];
      }
      return [];
    } else {
      throw "Unable to retrieve posts.";
    }
  }

  Future<List<HealthRecorditem>> getHealthRecordPrescriptionItems() async {
    HealthRecordPrescriptionScreen.prescriptionTitles = OTPVerification.appscreensdataitems![21].srntxt2.split(',');
    HealthRecordPrescriptionScreen.prescriptionImgUrl = OTPVerification.appscreensdataitems![21].srntxt5.split(',');
    HealthRecordPrescriptionScreen.prescriptionScreens = OTPVerification.appscreensdataitems![21].srntxt6.split(',');
    var body = "";
    postsURL = "http://drmohansdiabetes.net/dmdscwebapi/api/GetPrescriptionList";
    final postData = {
      "MrNo": ProfileScreen.selectedProfile.MrNo,
      //"MrNo": "TNGPM0000234757",
      "Channel": "App"
    };
    body = json.encode(postData);
    final headersWithBearer = {"Content-Type": "application/json", "authorization": "Bearer " + OTPVerification.tokenstr};
    var res = await post(Uri.parse(postsURL), headers: headersWithBearer, body: body);
    if (res.statusCode == 200) {
      var jsonData = jsonDecode(res.body);
      List<dynamic> tempPrescriptionItems = jsonData["presList"];
      if (tempPrescriptionItems != null) {
        HealthRecordPrescriptionScreen.prescriptionItems = tempPrescriptionItems
            .map(
              (dynamic item) => PrescriptionItem.fromJson(item),
            )
            .toList();
      } else {
        HealthRecordPrescriptionScreen.prescriptionItems = [];
      }
      return [];
    } else {
      throw "Unable to retrieve posts.";
    }
  }

  Future<List<HealthRecorditem>> getHealthLabreportItems() async {
    HealthRecordLabReportsScreen.labreportTitles = OTPVerification.appscreensdataitems![21].srntxt2.split(',');
    HealthRecordLabReportsScreen.labreportImgUrl = OTPVerification.appscreensdataitems![21].srntxt5.split(',');
    HealthRecordLabReportsScreen.labreportScreens = OTPVerification.appscreensdataitems![21].srntxt6.split(',');
    var body = "";
    postsURL = 'http://drmohansdiabetes.net/dmdscwebapi/api/GetLabResult';
    final postData = {
      //"MrNo": ProfileScreen.selectedProfile.MrNo,
      "MrNo": "TNGPM0000050459",
      "Channel": "App"
    };
    body = json.encode(postData);

    final headersWithBearer = {"Content-Type": "application/json", "authorization": "Bearer " + OTPVerification.tokenstr};
    var res = await post(Uri.parse(postsURL), headers: headersWithBearer, body: body);

    if (res.statusCode == 200) {
      var jsonData = jsonDecode(res.body);
      List<dynamic> tempabreportItems = jsonData["LabResults"];
      if (tempabreportItems != null) {
        HealthRecordLabReportsScreen.labreportItems = tempabreportItems
            .map(
              (dynamic item) => LabResultItem.fromJson(item),
            )
            .toList();
      } else {
        HealthRecordLabReportsScreen.labreportItems = [];
      }
      return [];
    } else {
      throw "Unable to retrieve posts.";
    }
  }

  Future<List<Ordersitem>> getMyOrdersItems() async {
    postsURL = "http://drmohansdiabetes.net/dmdscwebapi/api/GetOrderList";
    var body = "";
    final postData = {
      //"MrNo": "TEMPTNGPM004238",
      "MrNo": ProfileScreen.selectedProfile.MrNo,
      "Channel": "App"
    };
    body = json.encode(postData);
    final headersWithBearer = {"Content-Type": "application/json", "authorization": "Bearer " + OTPVerification.tokenstr};
    var res = await post(Uri.parse(postsURL), headers: headersWithBearer, body: body);
    if (res.statusCode == 200) {
      var jsonData = jsonDecode(res.body);
      List<dynamic> body = jsonData["S_orders"];
      List<Ordersitem> ordersitems = body
          .map(
            (dynamic item) => Ordersitem.fromJson(item),
          )
          .toList();
      return ordersitems;
      /*var jsonData = jsonDecode(res.body);
      print("jsonData " + jsonData);
      List<dynamic> body = jsonData["S_orders"];

      List<Ordersitem> ordersitems = body
          .map(
            (dynamic item) => Ordersitem.fromJson(item),
          )
          .toList();
      //List<Ordersitem> ordersitems = [];
      return ordersitems;*/
    } else {
      throw "Unable to retrieve posts.";
    }

    /*if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);

      List<Ordersitem> ordersitems = body
          .map(
            (dynamic item) => Ordersitem.fromJson(item),
          )
          .toList();

      return ordersitems;
    } else {
      throw "Unable to retrieve posts.";
    }*/
  }

  Future<List<Notifiesitem>> getNotificationItems() async {
    return DashboardScreen.notifies;
  }

  Future<List<TestResultItem>> getTestResultList() async {
    postsURL = "http://drmohansdiabetes.net/dmdscwebapi/api/GetTestResultList";
    var body = "";
    print(ProfileScreen.selectedProfile.MrNo);
    print("mr");
    final postData = {"MrNo": ProfileScreen.selectedProfile.MrNo, "Channel": "App", "TestID": "62"};
    body = json.encode(postData);
    print(body.toString());

    final headersWithBearer = {"Content-Type": "application/json", "authorization": "Bearer " + OTPVerification.tokenstr};
    var res = await post(Uri.parse(postsURL), headers: headersWithBearer, body: body);
    if (res.statusCode == 200) {
      var jsonData = jsonDecode(res.body);
      print(res.body);

      List<TestResultItem> testResultItems = (jsonData["testResults"] as List).map((e) => TestResultItem.fromMap(e)).toList();
      if (testResultItems != null) {
        return testResultItems;
      }
    }
    return [];
  }

  // Future<List<HealthTrackerItem>> getHealthTrackerList() async {
  //   postsURL =
  //       "http://drmohansdiabetes.net/dmdscwebapi/api/GetHealthTrackerList";
  //   var body = "";
  //   final postData = {
  //     "Channel": "App",
  //   };
  //   body = json.encode(postData);
  //   print(body.toString());
  //
  //   final headersWithBearer = {
  //     "Content-Type": "application/json",
  //     "authorization": "Bearer " + OTPVerification.tokenstr
  //   };
  //   var res =
  //       await post(Uri.parse(postsURL), headers: headersWithBearer, body: body);
  //   if (res.statusCode == 200) {
  //     var jsonData = jsonDecode(res.body);
  //     print(res.body);
  //
  //     List<HealthTrackerItem> healthTrackerListItems =
  //         (jsonData["list"] as List)
  //             .map((e) => HealthTrackerItem.fromMap(e))
  //             .toList();
  //     if (healthTrackerListItems != null) {
  //       return healthTrackerListItems;
  //     }
  //   }
  //   return [];
  // }

  Future<int> saveBloodPressure(int vitalId, int value1, int value2) async {
    postsURL = "http://drmohansdiabetes.net/dmdscwebapi/api/SaveVitals";
    var body = "";

    final postData = {"Channel": "App", "MrNo": ProfileScreen.selectedProfile.MrNo, "VitalID": vitalId, "Value1": value1, "Value2": value2};

    body = json.encode(postData);
    print(body.toString());

    final headersWithBearer = {"Content-Type": "application/json", "authorization": "Bearer " + OTPVerification.tokenstr};
    var res = await post(Uri.parse(postsURL), headers: headersWithBearer, body: body);
    return res.statusCode;
  }

  Future<int> saveBloodGlucose(int vitalId, int value1) async {
    postsURL = "http://drmohansdiabetes.net/dmdscwebapi/api/SaveVitals";
    var body = "";
    final postData = {"Channel": "App", "MrNo": ProfileScreen.selectedProfile.MrNo, "VitalID": vitalId, "Value1": value1};

    body = json.encode(postData);
    print(body.toString());

    final headersWithBearer = {"Content-Type": "application/json", "authorization": "Bearer " + OTPVerification.tokenstr};
    var res = await post(Uri.parse(postsURL), headers: headersWithBearer, body: body);
    return res.statusCode;
  }

  Future<List<TestListDetailItem>> getTestList() async {
    postsURL = "http://drmohansdiabetes.net/dmdscwebapi/api/GetTestList";
    var body = "";
    final postData = {"Channel": "App"};

    body = json.encode(postData);
    print(body.toString());

    final headersWithBearer = {"Content-Type": "application/json", "authorization": "Bearer " + OTPVerification.tokenstr};
    var res = await post(Uri.parse(postsURL), headers: headersWithBearer, body: body);
    if (res.statusCode == 200) {
      final map = jsonDecode(res.body) as Map;
      return (map["testList"] as List).map((e) => TestListDetailItem.fromMap(e)).toList();
    }
    return [];
  }

  Future<List<HealthTrackerItem>> getHealthTrackerList() async {
    postsURL = "http://drmohansdiabetes.net/dmdscwebapi/api/GetHealthTrackerList";
    var body = "";
    final postData = {
      "Channel": "App",
    };
    body = json.encode(postData);
    print(body.toString());

    final headersWithBearer = {"Content-Type": "application/json", "authorization": "Bearer " + OTPVerification.tokenstr};
    var res = await post(Uri.parse(postsURL), headers: headersWithBearer, body: body);
    print(res.body);
    print("getHealthTrackerList");
    if (res.statusCode == 200) {
      final map = jsonDecode(res.body) as Map;

      if (map["Status"] == "Success") {
        List<HealthTrackerItem> healthTrackerListItems = (map["list"] as List).map((e) => HealthTrackerItem.fromMap(e)).toList();
        return healthTrackerListItems;
      }
    }
    return [];
  }

  Future<HealthTrackerRecord> getHealthTrackerRecord(String date, int vitalId) async {
    postsURL = "http://drmohansdiabetes.net/dmdscwebapi/api/GetHTRecordList";
    var body = "";
    final postData = {"Channel": "App", "mrno": ProfileScreen.selectedProfile.MrNo, "date": date, "vitalid": vitalId};

    body = json.encode(postData);
    print(body.toString());

    final headersWithBearer = {"Content-Type": "application/json", "authorization": "Bearer " + OTPVerification.tokenstr};
    var res = await post(Uri.parse(postsURL), headers: headersWithBearer, body: body);
    print(res.body);
    print(" get " + res.body);
    if (res.statusCode == 200) {
      final map = jsonDecode(res.body) as Map<String, dynamic>;
      if (map["Status"] == "Success") {
        return HealthTrackerRecord.fromMap(map);
      }
    }
    return HealthTrackerRecord.fromMap({});
  }

  Future<List<FoodDetailItem>> getFoodDetails(String food) async {
    final postsURL = Uri.parse("http://49.207.187.43/MDRF/mobileAuth/getFoodDetails");
    var body = "";
    final postData = {"foodName": food};

    body = json.encode(postData);
    final headersWithBearer = {"Content-Type": "application/json", "authorization": "Bearer " + "9335c45b-85ea-4669-85f5-68544877eb51"};
    var res = await post(postsURL, headers: headersWithBearer, body: body);
    if (res.statusCode == 200) {
      print(res.body);
      final map = jsonDecode(res.body) as Map;
      return (map["foodDetails"] as List).map((e) => FoodDetailItem.fromMap(e)).toList();
    }
    return [];
  }

  Future<List<FoodPortionDetail>> getPortionDetails(int foodId) async {
    final postsURL = Uri.parse("http://49.207.187.43/MDRF/mobileAuth/getPortionDetails");
    var body = "";
    final postData = {"foodID": foodId};

    body = json.encode(postData);
    final headersWithBearer = {"Content-Type": "application/json", "authorization": "Bearer " + "9335c45b-85ea-4669-85f5-68544877eb51"};
    var res = await post(postsURL, headers: headersWithBearer, body: body);
    if (res.statusCode == 200) {
      print(res.body);
      final map = jsonDecode(res.body) as Map;
      return (map["foodDetails"] as List).map((e) => FoodPortionDetail.fromMap(e)).toList();
    }
    return [];
  }

  Future<int> emailFoodName(String food) async {
    final postsURL = Uri.parse("http://49.207.187.43/MDRF/mobileAuth/emailFoodName");
    var body = "";
    final postData = {"foodName": food};

    body = json.encode(postData);
    final headersWithBearer = {"Content-Type": "application/json", "authorization": "Bearer " + "9335c45b-85ea-4669-85f5-68544877eb51"};
    var res = await post(postsURL, headers: headersWithBearer, body: body);
    return res.statusCode;
  }
}
