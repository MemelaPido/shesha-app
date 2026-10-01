import 'package:flutter/foundation.dart';

import '../models/assistance_request.dart';
import '../models/vehicle.dart';

class AssistanceProvider extends ChangeNotifier {
  AssistanceRequest? _activeRequest;
  final List<AssistanceRequest> _history = [];
  bool _isSubmitting = false;

  AssistanceRequest? get activeRequest => _activeRequest;
  List<AssistanceRequest> get history => List.unmodifiable(_history);
  bool get isSubmitting => _isSubmitting;

  Future<void> requestHelp({
    required String issueType,
    required Vehicle vehicle,
    required String locationName,
    required double latitude,
    required double longitude,
    required String note,
  }) async {
    _isSubmitting = true;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 700));

    _activeRequest = AssistanceRequest(
      id: DateTime.now().millisecondsSinceEpoch,
      issueType: issueType,
      vehicleId: vehicle.id,
      vehicleName: vehicle.displayName,
      locationName: locationName,
      latitude: latitude,
      longitude: longitude,
      note: note,
      status: AssistanceStatus.dispatched,
      requestedAt: DateTime.now(),
      partnerName: 'Sipho M.',
      partnerVehicle: 'White Ford Ranger',
      partnerRating: 4.9,
      etaMinutes: 12,
      distanceKm: 4.2,
    );

    _isSubmitting = false;
    notifyListeners();
  }

  void completeRequest() {
    final request = _activeRequest;
    if (request == null) return;

    _history.insert(
      0,
      AssistanceRequest(
        id: request.id,
        issueType: request.issueType,
        vehicleId: request.vehicleId,
        vehicleName: request.vehicleName,
        locationName: request.locationName,
        latitude: request.latitude,
        longitude: request.longitude,
        note: request.note,
        status: AssistanceStatus.completed,
        requestedAt: request.requestedAt,
        partnerName: request.partnerName,
        partnerVehicle: request.partnerVehicle,
        partnerRating: request.partnerRating,
        etaMinutes: request.etaMinutes,
        distanceKm: request.distanceKm,
      ),
    );
    print("History Count: ${_history.length}");
    _activeRequest = null;
    notifyListeners();

  }

  void clearRequest() {
    _activeRequest = null;
    notifyListeners();
  }
}
