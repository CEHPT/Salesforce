import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:salesforce/components/performance.dart';
import 'package:salesforce/components/performance_card.dart';

// ignore: must_be_immutable
class ASOMonthlyPerformance extends StatelessWidget {
  ASOMonthlyPerformance({super.key});

  List<EmployeeMonthlyPerformance> perfomanceList = [];
  int presentCount = 0;
  int orderCount = 0;
  int feedbackCount = 0;
  String name = '', roll = '';
  double totalAmountOfOrders = 0.0;
  int totalNumberOfProductsSell = 0;

  Future<void> findAttendanceCount(String userUid) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('Attendance')
          .doc(userUid)
          .get();

      presentCount = 0;

      if (querySnapshot.exists) {
        var dateSubcollection = querySnapshot.data()! as Map<String, dynamic>;

        await Future.forEach(dateSubcollection.keys, (date) {
          var isPresent = dateSubcollection[date]['Present'] ?? false;

          if (isPresent) {
            presentCount++;
          }
        });
      }
    } catch (error) {
      print('Error finding attendance count: $error');
    }
  }

  Future<void> findOrderDetails(String asoUid) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('Orders')
          .doc('Order Details')
          .get();

      orderCount = 0;
      totalAmountOfOrders = 0;
      totalNumberOfProductsSell = 0;

      if (querySnapshot.exists) {
        Map<String, dynamic> orderDetails =
            querySnapshot.data() as Map<String, dynamic>;

        orderDetails.forEach(
          (orderDate, orderData) {
            if (orderData != null && orderData['ASO UID'] == asoUid) {
              orderCount++;
              totalAmountOfOrders += orderData['Total Amount'] ?? 0.0;
              totalNumberOfProductsSell += int.parse(orderData['quantity']);
            }
          },
        );
      }
    } catch (error) {
      print('Error finding order details: $error');
    }
  }

  Future<void> getTotalNumberOfFeedbacks(String asoUid) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('Feedback')
          .doc('Feedback Details')
          .get();

      feedbackCount = 0;

      if (querySnapshot.exists) {
        Map<String, dynamic> feedbackDetails =
            querySnapshot.data() as Map<String, dynamic>;

        feedbackDetails.forEach(
          (feedbackDate, feedbackData) {
            if (feedbackData != null && feedbackData['ASO UID'] == asoUid) {
              feedbackCount++;
            }
          },
        );
      }
    } catch (error) {
      print('Error finding order details: $error');
    }
  }

  Future<void> getEmployeesPerformance() async {
    perfomanceList.clear();
    final dbRef = FirebaseDatabase.instance.ref().child("Employees");

    await dbRef.once().then(
      (DatabaseEvent event) async {
        DataSnapshot snapshot = event.snapshot;
        if (snapshot.value != null) {
          Map<dynamic, dynamic> dataMap =
              (snapshot.value as Map<dynamic, dynamic>);

          await Future.forEach(
            dataMap.keys,
            (employeeUid) async {
              name = dataMap[employeeUid]['Name'] ?? '';
              roll = dataMap[employeeUid]['Role'] ?? '';

              if (roll != 'ASO') {
                return;
              }

              await findAttendanceCount(employeeUid);
              await findOrderDetails(employeeUid);
              await getTotalNumberOfFeedbacks(employeeUid);

              perfomanceList.add(
                EmployeeMonthlyPerformance(
                    presentCount,
                    orderCount,
                    totalAmountOfOrders,
                    feedbackCount,
                    totalNumberOfProductsSell,
                    employeeUid,
                    name),
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print(perfomanceList.length);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ASO Performance',
          textAlign: TextAlign.center,
        ),
      ),
      body: FutureBuilder(
        future: getEmployeesPerformance(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.lightBlue,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return ListView.builder(
              itemCount: perfomanceList.length,
              itemBuilder: (context, index) {
                return PerformanceCard(
                  performance: perfomanceList[index],
                );
              },
            );
          }
        },
      ),
    );
  }
}
