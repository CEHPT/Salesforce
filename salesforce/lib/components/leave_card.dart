import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:salesforce/components/leave_request.dart';

// ignore: must_be_immutable
class LeaveCard extends StatefulWidget {
  LeaveCard({required this.employeeRoll, required this.details, super.key});

  LeaveRequest details;
  String employeeRoll;

  @override
  State<LeaveCard> createState() => _LeaveCardState();
}

class _LeaveCardState extends State<LeaveCard> {
  Future<String> getCurrentUserRole() async {
    try {
      var userUid = FirebaseAuth.instance.currentUser!.uid;
      final dbRef = FirebaseDatabase.instance.ref().child("Employees");

      var event = await dbRef.child(userUid).once();
      var snapshot = event.snapshot;
      Map<Object?, Object?> dataMap = snapshot.value as Map<Object?, Object?>;
      String userRole = dataMap['Role'] as String;

      return userRole;
    } catch (error) {
      print('Error getting user role: $error');
      return '';
    }
  }

  Future<String> _showDialogWindow() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Change Status',
        ),
        backgroundColor: Colors.lightBlue.shade100,
        content: const Text(
          'Please selected status for leave ',
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'Rejected'),
            child: const Text('Reject'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'Accepted'),
            child: const Text('Accept'),
          ),
        ],
      ),
    );
  }

  Future<void> updateLeaveStatus() async {
    try {
      String currentUserRole = await getCurrentUserRole();
      if (currentUserRole != widget.employeeRoll) {
        String newStatus = await _showDialogWindow();

        await FirebaseFirestore.instance
            .collection('Leave Request')
            .doc(widget.employeeRoll)
            .update(
          {
            '${widget.details.applyDate}.Status': newStatus,
          },
        );

        print('Leave status updated by ASM');
      } else {
        print('User does not have permission to update leave status ');
      }
    } catch (error) {
      print('Error updating leave status: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => updateLeaveStatus(),
      child: Card(
        color: Colors.lightBlue.shade100,
        elevation: 5,
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Start Date: ${widget.details.startDate}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'End Date: ${widget.details.endDate}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Reason: ${widget.details.reason}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Status: ${widget.details.status}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
