import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:salesforce/services/current_location.dart';

class AttendanceMarking {
  Future<void> markingAttendance(String userUid, bool present) async {
    try {
      DateTime currentDateTime = DateTime.now();
      String currentDate = DateFormat('dd/MM/yyy').format(currentDateTime);
      String currentTiming = DateFormat('HH:mm').format(currentDateTime);
      String googleMapLocation;

      if (await CurrentLocation().checkLocationPermission() == true) {
        googleMapLocation = await CurrentLocation().getCurrentLocation();
      } else if (await CurrentLocation().requestLocationPermission() == true) {
        googleMapLocation = await CurrentLocation().getCurrentLocation();
      } else {
        return;
      }

      await FirebaseFirestore.instance
          .collection('Attendance')
          .doc(userUid)
          .set(
        {
          currentDate: {
            'Present': present,
            'Location': googleMapLocation,
            'Timing': currentTiming,
          }
        },
        SetOptions(merge: true),
      );
    } catch (error) {
      print(error.toString());
    }
  }
}
