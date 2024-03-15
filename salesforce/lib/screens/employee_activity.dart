import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:salesforce/components/leave_card.dart';
import 'package:salesforce/components/leave_request.dart';

// ignore: must_be_immutable
class EmployeeActivity extends StatelessWidget {
  EmployeeActivity({required this.employeeRoll, super.key});

  String employeeRoll;
  List<LeaveRequest> listOfLeaveRequests = [];

  Future<void> getLeaveRequests() async {
    try {
      listOfLeaveRequests.clear();

      var orderDetails = await FirebaseFirestore.instance
          .collection('Leave Request')
          .doc(employeeRoll)
          .get();

      if (orderDetails.exists) {
        orderDetails.data()!.forEach(
          (key, value) {
            listOfLeaveRequests.add(
              LeaveRequest(
                startDate: value['StartDate'].toString(),
                endDate: value['EndDate'].toString(),
                reason: value['Reason'],
                status: value['Status'],
                applyDate: key,
              ),
            );
          },
        );
      } else {
        print("Leave Request document does not exist.");
      }
    } catch (error) {
      print("Error retrieving leave requests: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$employeeRoll Leave Status'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder(
            future: getLeaveRequests(),
            builder: (context, snapshot) {
              return ListView.builder(
                itemCount: listOfLeaveRequests.length,
                itemBuilder: (context, index) {
                  return LeaveCard(
                    details: listOfLeaveRequests[index],
                    employeeRoll: employeeRoll,
                  );
                },
              );
            }),
      ),
    );
  }
}
