import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:salesforce/components/add_feedback_dialog.dart';
import 'package:salesforce/components/order.dart';

// ignore: must_be_immutable
class OrderCard extends StatelessWidget {
  OrderCard({
    Key? key,
    required this.orderData,
    required this.userRoll,
  }) : super(key: key);

  MyOrder orderData;
  String userRoll;
  String ASOName = '';

  Future<void> getASOName() async {
    final dbRef = FirebaseDatabase.instance.ref().child("Employees");

    await dbRef.child(orderData.asoUid).once().then(
      (event) {
        DataSnapshot snapshot = event.snapshot;

        Map<Object?, Object?> dataMap = snapshot.value as Map<Object?, Object?>;
        ASOName = dataMap['Name'] as String;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getASOName(),
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: SizedBox(
            height: 290,
            width: 290,
            child: GestureDetector(
              onTap: () {
                if (userRoll == 'ASO' &&
                    orderData.asoUid ==
                        FirebaseAuth.instance.currentUser!.uid) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return FeedbackDialog(
                        orderDetails: orderData,
                      );
                    },
                  );
                }
              },
              child: Card(
                elevation: 8,
                shadowColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Colors.blue.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(),
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                orderData.distributorName,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            'ASO : $ASOName',
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Image.network(
                            orderData.imageUrl,
                            width: 100,
                            height: 100,
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          Flexible(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.blue.shade100,
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                orderData.address,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            orderData.product,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "Quantity :" + orderData.quantity.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                "RS." + orderData.totalAmount.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            orderData.orderDate,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
