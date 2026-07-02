class RemainingDistanceModel {
  double? distance;
  String? distanceText;
  String? duration;
  int? durationSec;
  String? status;
  String? driveMode;
  String? encodedPolyline;
  bool? isPicked;
  bool? isDrop;
  String? durationInTraffic;
  int? durationInTrafficSec;

  RemainingDistanceModel(
      {this.distance,
        this.distanceText,
        this.duration,
        this.durationSec,
        this.status,
        this.driveMode,
        this.encodedPolyline,
        this.isPicked,
        this.isDrop,
        this.durationInTrafficSec,
        this.durationInTraffic
      });

  RemainingDistanceModel.fromJson(Map<String, dynamic> json) {
    distance = double.tryParse(json['distance'].toString());
    distanceText = json['distance_text'];
    duration = json['duration'];
    durationSec = json['duration_sec'] != null ? int.tryParse(json['duration_sec'].toString()) : null;
    status = json['status'];
    driveMode = json['drive_mode'];
    encodedPolyline = json['encoded_polyline'];
    isPicked = json['is_picked'] != null ? (json['is_picked'].toString() == '1' || json['is_picked'].toString() == 'true') : null;
    isDrop = json['is_dropped'] != null ? (json['is_dropped'].toString() == '1' || json['is_dropped'].toString() == 'true') : null;
    durationInTraffic = json['duration_in_traffic'];
    durationInTrafficSec = json['duration_in_traffic_sec'] != null ? int.tryParse(json['duration_in_traffic_sec'].toString()) : null;
  }

}
