import 'package:adwaitha_sangamam/common/common_functions.dart';
import 'package:adwaitha_sangamam/models/error_response_model.dart';
import 'package:adwaitha_sangamam/models/events_model.dart';
import 'package:adwaitha_sangamam/models/mark_model.dart';
import 'package:adwaitha_sangamam/models/report_detail_model,dart';
import 'package:adwaitha_sangamam/models/report_model.dart';
import 'package:adwaitha_sangamam/models/scan_model.dart';
import 'package:adwaitha_sangamam/services/provider_helper_class.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EventProvider extends ChangeNotifier with ProviderHelperClass {
  @override
  void updateLoadState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }

  List<Event> eventsList = [];
  EventsModel? eventsResponse;

  ReportModel? reportResponse;
  List<Report> reportList = [];

  ReportDetailModel? reportDetailResponse;
  List<ReportList> reportDetailList = [];

  // Separate state for scan/mark so they don't fight the dashboard's
  // shared `loaderState` (which is still driven by getEvents()).
  LoaderState scanState = LoaderState.initial;
  String? scanErrorMessage;
  ScanModel? scanResponse;

  LoaderState markState = LoaderState.initial;
  String? markErrorMessage;
  MarkModel? markResponse;

  Future<void> getEvents() async {
    final network = await CommonFunctions.checkInternetConnection();
    if (network) {
      updateLoadState(LoaderState.loading);
      try {
        var res = await serviceConfig.getEvents();
        if (res.isValue) {
          eventsResponse = res.asValue!.value;
          if (eventsResponse != null) {
            updateEventsList(eventsResponse);
          }
        } else {
          updateLoadState(LoaderState.loaded);
        }
      } catch (e) {
        debugPrint('exception in deities: $e');
        updateLoadState(LoaderState.loaded);
      }
    }
  }

  /// Looks up a devotee by the QR code's unique number.
  /// Returns the ScanModel on success, or null on failure
  /// (check [scanErrorMessage] for details).
  Future<ScanModel?> getScan(String uniqueNumber) async {
    scanErrorMessage = null;
    final network = await CommonFunctions.checkInternetConnection();
    if (!network) {
      scanState = LoaderState.networkErr;
      scanErrorMessage = 'No internet connection. Please check your network.';
      notifyListeners();
      return null;
    }

    scanState = LoaderState.loading;
    notifyListeners();
    try {
      var res = await serviceConfig.getScan(uniqueNumber);
      if (res.isValue) {
        final result = res.asValue!.value as ScanModel;
        scanResponse = result;
        scanState = LoaderState.loaded;
        notifyListeners();
        return result;
      } else {
        scanErrorMessage = _extractError(
          res.asError?.error,
          'Devotee not found for this ticket.',
        );
        scanState = LoaderState.error;
        notifyListeners();
        return null;
      }
    } catch (e) {
      debugPrint('exception in getScan: $e');
      scanErrorMessage = 'Something went wrong while scanning. Please try again.';
      scanState = LoaderState.error;
      notifyListeners();
      return null;
    }
  }

  /// Marks attendance for a devotee. Returns the MarkModel on success,
  /// or null on failure (check [markErrorMessage] for details).
  Future<MarkModel?> markAttendance(String uniqueNumber, String status) async {
    markErrorMessage = null;
    final network = await CommonFunctions.checkInternetConnection();
    if (!network) {
      markState = LoaderState.networkErr;
      markErrorMessage = 'No internet connection. Please check your network.';
      notifyListeners();
      return null;
    }

    markState = LoaderState.loading;
    notifyListeners();
    try {
      var res = await serviceConfig.markAttendance(uniqueNumber, status);
      if (res.isValue) {
        final result = res.asValue!.value as MarkModel;
        markResponse = result;
        markState = LoaderState.loaded;
        notifyListeners();
        return result;
      } else {
        markErrorMessage = _extractError(
          res.asError?.error,
          'Could not mark attendance. Please try again.',
        );
        markState = LoaderState.error;
        notifyListeners();
        return null;
      }
    } catch (e) {
      debugPrint('exception in markAttendance: $e');
      markErrorMessage = 'Something went wrong while marking attendance.';
      markState = LoaderState.error;
      notifyListeners();
      return null;
    }
  }


  Future<void> getReport() async {
    final network = await CommonFunctions.checkInternetConnection();
    if (network) {
      updateLoadState(LoaderState.loading);
      try {
        var res = await serviceConfig.getEventReport();
        if (res.isValue) {
          reportResponse = res.asValue!.value;
          if (reportResponse != null) {
            updateReportList(reportResponse);
          }
        } else {
          updateLoadState(LoaderState.loaded);
        }
      } catch (e) {
        debugPrint('exception in deities: $e');
        updateLoadState(LoaderState.loaded);
      }
    }
  }


    Future<void> getReportDetail(String event) async {
    final network = await CommonFunctions.checkInternetConnection();
    if (network) {
      updateLoadState(LoaderState.loading);
      try {
        var res = await serviceConfig.getReportDetail(event);
        if (res.isValue) {
          reportDetailResponse = res.asValue!.value;
          if (reportDetailResponse != null) {
            updateReportDetailList(reportDetailResponse);
          }
        } else {
          updateLoadState(LoaderState.loaded);
        }
      } catch (e) {
        debugPrint('exception in deities: $e');
        updateLoadState(LoaderState.loaded);
      }
    }
  }

  String _extractError(dynamic error, String fallback) {
    if (error is ErrorResponseModel) {
      return error.errorMessage ?? fallback;
    }
    return fallback;
  }

  /// Call when leaving the scan/details flow so stale state
  /// (previous devotee, previous error) doesn't leak into the next scan.
  void resetScanState() {
    scanResponse = null;
    scanState = LoaderState.initial;
    scanErrorMessage = null;
    markResponse = null;
    markState = LoaderState.initial;
    markErrorMessage = null;
    notifyListeners();
  }

  void updateReportList(ReportModel? reportResponse) {
    reportList = reportResponse?.events ?? [];
    updateLoadState(LoaderState.loaded);
    notifyListeners();
  }

  void updateEventsList(EventsModel? eventsResponse) {
    eventsList = eventsResponse?.events ?? [];
    updateLoadState(LoaderState.loaded);
    notifyListeners();
  }

  void updateReportDetailList(ReportDetailModel? reportDetailResponse){
    reportDetailList = reportDetailResponse?.devotees ?? [];
    updateLoadState(LoaderState.loaded);
    notifyListeners();
  }
}