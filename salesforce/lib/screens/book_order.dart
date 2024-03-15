import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class BookNewOrder extends StatefulWidget {
  const BookNewOrder({Key? key}) : super(key: key);

  @override
  State<BookNewOrder> createState() => BookNewOrderState();
}

class BookNewOrderState extends State<BookNewOrder> {
  final formKey = GlobalKey<FormState>();

  String? distributor, quantity, address;
  List<String> listOfProcutNames = [];
  var listOfPrice = [];

  String? selectedProduct;
  double totalAmount = 0.0;

  String? _validateInput(String? v) {
    if (v!.isEmpty) {
      return "Required.";
    }
    return null;
  }

  Future<void> _getProductsFromDatabase() async {
    try {
      listOfPrice = [];
      listOfProcutNames = [];
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('Products').get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
          in querySnapshot.docs) {
        String productName = documentSnapshot.id;
        String price = documentSnapshot.data()['Price'];

        listOfProcutNames.add(productName);
        listOfPrice.add(price);
      }

      print(listOfPrice.toString());
    } catch (error) {
      print('Error retrieving product names: $error');
    }
  }

  Future<bool> _showConfirmationDialog() async {
    int index = listOfProcutNames.indexOf(selectedProduct!);
    totalAmount =
        (double.parse(listOfPrice[index]) * int.parse(quantity!)) as double;

    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.lightBlue.shade100,
          title: const Text('Confirm Order'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Distributor: $distributor'),
                Text('Product: $selectedProduct'),
                Text('Quantity: $quantity'),
                Text("Address : $address"),
                Text('Total Amount: $totalAmount'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<void> orderPlaced() async {
    bool confirmed = await _showConfirmationDialog();
    if (confirmed == false) {
      return;
    }

    var ff = FirebaseFirestore.instance.collection('Orders');
    var fAuth = FirebaseAuth.instance.currentUser!.uid;
    DateTime currentDateTime = DateTime.now();
    String currentDateAndAlsoTime =
        DateFormat('dd/MM/yyy HH:mm').format(currentDateTime);

    await ff.doc('Order Details').set({
      currentDateAndAlsoTime: {
        'Distributor Name': distributor,
        'Product': selectedProduct,
        'quantity': quantity,
        'Address': address,
        'ASO UID': fAuth,
        'Total Amount': totalAmount,
      }
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 700,
      width: 400,
      color: Colors.white,
      child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  '  Distributor Name',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black54),
                ),
                TextFormField(
                  validator: (value) => _validateInput(value),
                  onSaved: (newValue) => distributor = newValue,
                  decoration: InputDecoration(
                    hintText: 'Enter distributor name',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 16.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '  Select Product',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black54),
                ),
                FutureBuilder(
                  future: _getProductsFromDatabase(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(
                        color: Colors.blue,
                      ));
                    } else {
                      return DropdownButtonFormField<String>(
                        value: selectedProduct,
                        items: listOfProcutNames.map(
                          (p) {
                            return DropdownMenuItem<String>(
                              value: p,
                              child: Text(p),
                            );
                          },
                        ).toList(),
                        onChanged: (newValue) =>
                            setState(() => selectedProduct = newValue),
                        isExpanded: false,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 18, horizontal: 16.0),
                          hintText: 'Select',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  '  Quantity',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black54),
                ),
                TextFormField(
                  validator: (value) => _validateInput(value),
                  onSaved: (newValue) => quantity = newValue,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 16.0),
                    hintText: 'Enter Quantity',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '  Address',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black54),
                ),
                TextFormField(
                  validator: (value) => _validateInput(value),
                  onSaved: (newValue) => address = newValue,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 16.0),
                    hintText: 'Enter address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.reset();
                        }
                      },
                      child: const Text(
                        'Clear',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blue.shade900),
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          orderPlaced();
                        }
                      },
                      child: const Text(
                        'Book Order',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
