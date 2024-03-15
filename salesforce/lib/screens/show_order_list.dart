import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:salesforce/components/order.dart';
import 'package:salesforce/components/order_card.dart';

// ignore: must_be_immutable
class ShowOrderList extends StatelessWidget {
  ShowOrderList({required this.currentUserRoll, super.key});

  List<MyOrder> listOfOrders = [];
  String currentUserRoll;
  Map<String, String> productNamesAndImages = {};

  Future<void> _getProductNamesAndImages() async {
    try {
      productNamesAndImages.clear();
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('Products').get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
          in querySnapshot.docs) {
        String productName = documentSnapshot.id;
        String image = documentSnapshot.data()['Image'];

        productNamesAndImages[productName] = image;
      }
    } catch (error) {
      print('Error retrieving product names: $error');
    }
  }

  Future<void> getOrdersList() async {
    await _getProductNamesAndImages();

    listOfOrders.clear();

    var orderDetails = await FirebaseFirestore.instance
        .collection('Orders')
        .doc('Order Details')
        .get();

    orderDetails.data()!.forEach(
      (key, value) {
        listOfOrders.add(
          MyOrder(
            distributorName: value['Distributor Name'],
            product: value['Product'],
            quantity: int.parse(value['quantity']),
            address: value['Address'],
            orderDate: key,
            imageUrl: productNamesAndImages[value['Product']]!,
            totalAmount: value['Total Amount'],
            asoUid: value['ASO UID'],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders List'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder(
          future: getOrdersList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.lightBlue,
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                itemCount: listOfOrders.length,
                itemBuilder: (context, index) {
                  return OrderCard(
                      orderData: listOfOrders[index],
                      userRoll: currentUserRoll);
                },
              );
            } else {
              return const Center(
                child: Text('An un expected error found!.'),
              );
            }
          },
        ),
      ),
    );
  }
}
