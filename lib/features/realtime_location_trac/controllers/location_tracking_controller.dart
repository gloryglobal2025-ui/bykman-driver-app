import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_sharing_user_app/features/map/controllers/map_controller.dart';
import 'package:ride_sharing_user_app/features/realtime_location_trac/domain/model/track_details_model.dart';
import 'package:ride_sharing_user_app/features/realtime_location_trac/domain/service/location_tracking_service_interface.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/helper/login_helper.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;


class LocationTrackingController extends GetxController implements GetxService{
  final LocationTrackingServiceInterface locationTrackingServiceInterface;
  LocationTrackingController({required this.locationTrackingServiceInterface});

  bool isLoading = false;
  RideTrackDetailsModel? rideTrackDetailsModel;
  late LatLng currentPosition;
  Set<Marker> markers = {};
  List<LatLng> _polylineCoordinateList = [];
  late Uint8List car;
  late Uint8List bike;
  late Uint8List destination;

  Set<Polyline> polylines = {};

  @override
  void onInit() async{
    car = await Get.find<RiderMapController>().convertAssetToUnit8List(Images.carIconTop, width: 30);
    bike = await Get.find<RiderMapController>().convertAssetToUnit8List(Images.bike, width: 30);
    destination = await Get.find<RiderMapController>().convertAssetToUnit8List(Images.targetLocationIcon, width: 30);
    super.onInit();
  }


  void getTrackingDetails(String trackingId) async{

    Response? response = await locationTrackingServiceInterface.getRideTrackingDetails(trackingId);
    if(response!.statusCode == 200){
      rideTrackDetailsModel = RideTrackDetailsModel.fromJson(response.body);
      _polylineCoordinateList = Get.find<RiderMapController>().decodeEncodedPolyline(rideTrackDetailsModel?.data?.encodedPolyline ?? '');
      updateDriverMarker(_polylineCoordinateList, rideTrackDetailsModel?.data?.vehicleType);
      _addPolyLine(_polylineCoordinateList);
      currentPosition = _polylineCoordinateList.first;
    }else{
      showCustomSnackBar('invalid_tracking_link'.tr, subMessage: 'the_tracking_link_is_invalid_expired'.tr);
      LoginHelper().checkLoginRoutes(null);
    }

    update();
  }

  void updateDriverMarker(List<LatLng> latLngList, String? vehicleCategoryType) async{
    markers = {};

    if(latLngList.isNotEmpty) {
      markers.add(Marker(
        markerId: const MarkerId('driverPosition'),
        position: latLngList.first,
        rotation: _calculateBearing(
          latLngList.first,
          latLngList.length > 1 ?  latLngList[1] : latLngList.last,
        ),
        draggable: false,
        zIndexInt: 2,
        flat: true,
        anchor: const Offset(0.5, 0.5),
        icon: BitmapDescriptor.bytes(vehicleCategoryType == 'car' ? car : bike),
      ));

      markers.add(Marker(
        markerId: const MarkerId('destination'),
        position: latLngList.last,
        draggable: false,
        zIndexInt: 2,
        flat: true,
        anchor: const Offset(0.5, 0.5),
        icon: BitmapDescriptor.bytes(destination),
      ));

      update();
    }
  }

  double _calculateBearing(LatLng startPoint, LatLng endPoint) {
    final double startLat = _toRadians(startPoint.latitude);
    final double startLng = _toRadians(startPoint.longitude);
    final double endLat = _toRadians(endPoint.latitude);
    final double endLng = _toRadians(endPoint.longitude);

    final double deltaLng = endLng - startLng;

    final double y = math.sin(deltaLng) * math.cos(endLat);
    final double x = math.cos(startLat) * math.sin(endLat) -
        math.sin(startLat) * math.cos(endLat) * math.cos(deltaLng);

    final double bearing = math.atan2(y, x);

    return (_toDegrees(bearing) + 360) % 360;
  }

  double _toRadians(double degrees) => degrees * (math.pi / 180.0);

  double _toDegrees(double radians) => radians * (180.0 / math.pi);

  void _addPolyLine(List<LatLng> polylineCoordinates) {
    polylines = {};

    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      points: polylineCoordinates,
      width: 5,
      color: Theme.of(Get.context!).primaryColor,
    );

    polylines.add(polyline);

    update();
  }

}

