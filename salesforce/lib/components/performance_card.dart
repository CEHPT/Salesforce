import 'package:flutter/material.dart';
import 'package:salesforce/components/performance.dart';

class PerformanceCard extends StatelessWidget {
  const PerformanceCard({required this.performance, super.key});

  final EmployeeMonthlyPerformance performance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ASO Name: ${performance.asoName}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Present Count: ${performance.presentCount}',
              style: TextStyle(fontSize: 14),
            ),
            Text(
              'Order Count: ${performance.orderCount}',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 8),
            Text(
              'Total Amount of Orders: ${performance.totalAmountOfOrders}',
              style: TextStyle(fontSize: 14),
            ),
            Text(
              'Total Feedbacks Collected: ${performance.totalFeedbacksCollected}',
              style: TextStyle(fontSize: 14),
            ),
            Text(
              'Total Number of Products Sell: ${performance.totalNumberOfProductsSell}',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
