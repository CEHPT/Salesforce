import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LeaveDialog extends StatefulWidget {
  const LeaveDialog({required this.employeeRoll, super.key});

  final String employeeRoll;

  @override
  _LeaveDialogState createState() => _LeaveDialogState();
}

class _LeaveDialogState extends State<LeaveDialog> {
  DateTime? _startDate;
  DateTime? _endDate;
  String _reason = "";

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null &&
        pickedDate != (isStartDate ? _startDate : _endDate)) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }

  String _formatDate(DateTime? date) {
    return date != null ? DateFormat('yyyy-MM-dd').format(date) : '';
  }

  Future<void> _storeLeaveRequestionFromFirestore() async {
    final leaveRequests = FirebaseFirestore.instance
        .collection('Leave Request')
        .doc(widget.employeeRoll);
    final employeeUid = FirebaseAuth.instance.currentUser!.uid;
    DateTime currentDateTime = DateTime.now();
    String currentDate = DateFormat('dd/MM/yyy').format(currentDateTime);

    currentDate = currentDate.replaceAll('/', '-');

    await leaveRequests.set(
      {
        currentDate: {
          'Employee UID': employeeUid,
          'StartDate': _formatDate(_startDate),
          'EndDate': _formatDate(_endDate),
          'Reason': _reason,
          'Status': 'Pending',
        }
      },
      SetOptions(merge: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.lightBlue.shade100,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Apply for Leave",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Start Date: ${_formatDate(_startDate)}"),
                ElevatedButton(
                  onPressed: () => _selectDate(context, true),
                  child: const Text(
                    "Select",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("End Date: ${_formatDate(_endDate)}"),
                ElevatedButton(
                  onPressed: () => _selectDate(context, false),
                  child: const Text(
                    "Select",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              decoration: const InputDecoration(labelText: "Reason for Leave"),
              onChanged: (value) {
                setState(() {
                  _reason = value;
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog on cancel
                  },
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Cancle",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    print("Applying for leave...");
                    print("Start Date: $_startDate");
                    print("End Date: $_endDate");
                    print("Reason: $_reason");
                    Navigator.pop(context);
                  },
                  child: TextButton(
                      onPressed: () {
                        _storeLeaveRequestionFromFirestore();
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Apply",
                        style: TextStyle(color: Colors.black),
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
