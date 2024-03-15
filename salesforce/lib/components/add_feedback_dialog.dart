import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:salesforce/components/order.dart';
import 'package:uuid/uuid.dart';

// ignore: must_be_immutable
class FeedbackDialog extends StatefulWidget {
  FeedbackDialog({required this.orderDetails, Key? key}) : super(key: key);

  MyOrder orderDetails;

  @override
  _FeedbackDialogState createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  TextEditingController _feedbackController = TextEditingController();
  File? _imageFile;
  final ImagePicker _imagePicker = ImagePicker();

  Future<String> storeImageFromFirebaseStorage() async {
    String imageName = Uuid().v4();

    final Reference storageRef =
        FirebaseStorage.instance.ref().child('Images').child('$imageName.jpg');

    await storageRef.putFile(_imageFile!);

    final String downloadUrl = await storageRef.getDownloadURL();

    return downloadUrl;
  }

  Future<void> addFeedback(String feedback) async {
    var ff = FirebaseFirestore.instance.collection('Feedback');

    String downloadUrl = await storeImageFromFirebaseStorage();

    await ff.doc('Feedback Details').set({
      widget.orderDetails.orderDate: {
        'Distributor Name': widget.orderDetails.distributorName,
        'Product': widget.orderDetails.product,
        'Quantity': widget.orderDetails.quantity,
        'Address': widget.orderDetails.address,
        'ASO UID': widget.orderDetails.asoUid,
        'Total Amount': widget.orderDetails.totalAmount,
        'Feedback': feedback,
        'Image': downloadUrl,
      }
    }, SetOptions(merge: true));

    print("Sucessfully added feedback");
  }

  Future<void> _getImage() async {
    var status = await Permission.photos.request();

    if (true) {
      final pickedFile =
          await _imagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _imageFile = File(pickedFile.path);
        }
      });
    } else {
      openAppSettings();
      print('Permission denied');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _feedbackController,
              decoration: InputDecoration(labelText: 'Feedback'),
            ),
            SizedBox(height: 16),
            _imageFile != null
                ? Image.file(
                    _imageFile!,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  )
                : Container(),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: _getImage,
              child: const Text('Upload Image'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                String feedback = _feedbackController.text;
                addFeedback(feedback);

                Navigator.pop(context);
              },
              child: const Text('Submit Feedback'),
            ),
          ],
        ),
      ),
    );
  }
}
