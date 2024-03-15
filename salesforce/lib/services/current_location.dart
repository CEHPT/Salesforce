import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class CurrentLocation {
  Future<bool> checkLocationPermission() async {
    PermissionStatus status = await Permission.location.status;

    if (status == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> requestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();

    if (status == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> getCurrentLocation() async {
    Position currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    String googleMapLocation =
        "https://maps.google.com/?q=${currentPosition.latitude},${currentPosition.longitude}";

    return googleMapLocation;
  }
}
