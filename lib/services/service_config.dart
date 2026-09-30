import 'package:adwaitha_sangamam/models/error_response_model.dart';
import 'package:adwaitha_sangamam/models/events_model.dart';
import 'package:adwaitha_sangamam/models/login_response_model.dart';
import 'package:adwaitha_sangamam/models/mark_model.dart';
import 'package:adwaitha_sangamam/models/report_detail_model,dart';
import 'package:adwaitha_sangamam/models/report_model.dart';
import 'package:adwaitha_sangamam/models/scan_model.dart';
import 'package:adwaitha_sangamam/services/base_client.dart';
import 'package:flutter/foundation.dart';
import 'package:async/async.dart';

class ServiceConfig {
  Future<Result> login({String? name, String? password}) async {
    Map<String, dynamic> body = {
      'name': name ?? '',
      'password': password ?? ''
    };

    Result res = await BaseClient.post('login', body: body);
    if (res.isError) {
      ErrorResponseModel errorResponseModel =
          ErrorResponseModel(errorMessage: 'OOps...!, login failed');
      return Result.error(errorResponseModel);
    } else {
      var response = res.asValue!.value;
      debugPrint('login response $response');
      LoginResponseModel loginResponseModel =
          LoginResponseModel.fromJson(response);
      return (loginResponseModel.status)
          ? Result.value(loginResponseModel)
          : Result.error(loginResponseModel);
    }
  }



  Future<Result> getEvents() async {
    Result res = await BaseClient.get('attendance/events');
    if (res.isError) {
      ErrorResponseModel errorResponseModel =
          ErrorResponseModel(errorMessage: 'OOps...!, Something went wrong');
      return Result.error(errorResponseModel);
    } else {
      var response = res.asValue!.value;
      debugPrint('deities response $response');
      EventsModel eventsResponse = EventsModel.fromJson(response);
      return (eventsResponse.status)
          ? Result.value(eventsResponse)
          : Result.error(eventsResponse);
    }
  }



  // Future<Result> getScan(String uniqueNumber) async {
  //   Result res = await BaseClient.post('attendance/scan', body: {'unique_number': uniqueNumber});
  //   if (res.isError) {
  //     ErrorResponseModel errorResponseModel =
  //         ErrorResponseModel(errorMessage: 'OOps...!, Something went wrong');
  //     return Result.error(errorResponseModel);
  //   } else {
  //     var response = res.asValue!.value;
  //     debugPrint('scan response $response');
  //     ScanModel scanResponse = ScanModel.fromJson(response);
  //     return (scanResponse.status ?? false)
  //         ? Result.value(scanResponse)
  //         : Result.error(scanResponse);
  //   }
  // }


  Future<Result> getScan(String uniqueNumber) async {
  Result res = await BaseClient.post('attendance/scan', body: {'unique_number': uniqueNumber});
  if (res.isError) {
    ErrorResponseModel errorResponseModel =
        ErrorResponseModel(errorMessage: 'OOps...!, Something went wrong');
    return Result.error(errorResponseModel);
  } else {
    var response = res.asValue!.value;
    debugPrint('scan response $response');

    // Check status BEFORE parsing devotee/attendance — those keys
    // won't exist when the backend returns a "not found" response.
    if (response['status'] != true) {
      ErrorResponseModel errorResponseModel = ErrorResponseModel(
        errorMessage: response['message'] ?? 'No devotee found for this QR code',
      );
      return Result.error(errorResponseModel);
    }

    ScanModel scanResponse = ScanModel.fromJson(response);
    return Result.value(scanResponse);
  }
}

  Future<Result> markAttendance(String uniqueNumber, String status) async {
    Result res = await BaseClient.post('attendance/mark', body: {'unique_number': uniqueNumber, 'status': status});
    if (res.isError) {
      ErrorResponseModel errorResponseModel =
          ErrorResponseModel(errorMessage: 'OOps...!, Something went wrong');
      return Result.error(errorResponseModel);
    } else {
      var response = res.asValue!.value;
      debugPrint('mark response $response');
      MarkModel markResponse = MarkModel.fromJson(response);
      return (markResponse.status)
          ? Result.value(markResponse)
          : Result.error(markResponse);
    }
  }


  Future<Result> getEventReport() async {
    Result res = await BaseClient.get('attendance/report');
    if (res.isError) {
      ErrorResponseModel errorResponseModel =
          ErrorResponseModel(errorMessage: 'OOps...!, Something went wrong');
      return Result.error(errorResponseModel);
    } else {
      var response = res.asValue!.value;
      debugPrint('report response $response');
      ReportModel reportResponse = ReportModel.fromJson(response);
      return (reportResponse.status)
          ? Result.value(reportResponse)
          : Result.error(reportResponse);
    }
  }


  Future<Result> getReportDetail(String event ) async {
    Result res = await BaseClient.get('attendance/report/$event');
    if(res.isError){
      ErrorResponseModel errorResponseModel =
        ErrorResponseModel(errorMessage: 'OOps...!, Something went wrong');
      return Result.error(errorResponseModel);
    }else{
      var response = res.asValue!.value;
      debugPrint('report detail response $response');
      ReportDetailModel reportDetailModel = ReportDetailModel.fromJson(response);
      return (reportDetailModel.status)
      ? Result.value(reportDetailModel)
      : Result.error(reportDetailModel);
    }
  }
  

  
}
