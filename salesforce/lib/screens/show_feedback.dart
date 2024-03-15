import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:salesforce/components/feedback.dart';
import 'package:salesforce/components/feedback_card.dart';

// ignore: must_be_immutable
class ShowFeedback extends StatelessWidget {
  ShowFeedback({super.key});

  List<MyFeedback> feedbacks = [];

  Future<void> getFeedbacksFromFirestore() async {
    feedbacks.clear();

    try {
      var feedbackDetails = await FirebaseFirestore.instance
          .collection('Feedback')
          .doc('Feedback Details')
          .get();

      if (feedbackDetails.exists) {
        feedbackDetails.data()!.forEach(
          (key, value) {
            try {
              feedbacks.add(
                MyFeedback(
                  distributorName: value['Distributor Name'] ?? '',
                  product: value['Product'] ?? '',
                  quantity: value['Quantity'] ?? 0,
                  address: value['Address'] ?? '',
                  orderDate: key,
                  imageUrl: value['Image'] ?? '',
                  totalAmount: value['Total Amount'] ?? 0.0,
                  asoUid: value['ASO UID'] ?? '',
                  feedback: value['Feedback'] ?? '',
                ),
              );
            } catch (e) {
              print('Error adding feedback: $e');
            }
          },
        );
      } else {
        print('Feedback Details document does not exist.');
      }
    } catch (e) {
      print('Error fetching feedback details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedbacks'),
      ),
      body: FutureBuilder(
        future: getFeedbacksFromFirestore(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.lightBlue,
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: feedbacks.length,
              itemBuilder: (context, index) {
                return FeedbackCard(feedbackDetails: feedbacks[index]);
              },
            );
          } else {
            return const Center(
              child: Text('An un expected error found!.'),
            );
          }
        },
      ),
    );
  }
}
