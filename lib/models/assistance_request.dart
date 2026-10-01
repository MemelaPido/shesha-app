enum AssistanceStatus { requested, dispatched, arriving, completed }

class AssistanceRequest {
  final int id;
  final String issueType;
  final int vehicleId;
  final String vehicleName;
  final String locationName;
  final double latitude;
  final double longitude;
  final String note;
  final AssistanceStatus status;
  final DateTime requestedAt;
  final String? partnerName;
  final String? partnerVehicle;
  final double? partnerRating;
  final int? etaMinutes;
  final double? distanceKm;

  const AssistanceRequest({
    required this.id,
    required this.issueType,
    required this.vehicleId,
    required this.vehicleName,
    required this.locationName,
    required this.latitude,
    required this.longitude,
    required this.note,
    required this.status,
    required this.requestedAt,
    this.partnerName,
    this.partnerVehicle,
    this.partnerRating,
    this.etaMinutes,
    this.distanceKm,
  });

  AssistanceRequest copyWith({
    AssistanceStatus? status,
    String? partnerName,
    String? partnerVehicle,
    double? partnerRating,
    int? etaMinutes,
    double? distanceKm,
  }) {
    return AssistanceRequest(
      id: id,
      issueType: issueType,
      vehicleId: vehicleId,
      vehicleName: vehicleName,
      locationName: locationName,
      latitude: latitude,
      longitude: longitude,
      note: note,
      status: status ?? this.status,
      requestedAt: requestedAt,
      partnerName: partnerName ?? this.partnerName,
      partnerVehicle: partnerVehicle ?? this.partnerVehicle,
      partnerRating: partnerRating ?? this.partnerRating,
      etaMinutes: etaMinutes ?? this.etaMinutes,
      distanceKm: distanceKm ?? this.distanceKm,
    );
  }
}
