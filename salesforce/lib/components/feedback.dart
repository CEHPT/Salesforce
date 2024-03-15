class MyFeedback {
  String distributorName;
  String address;
  String product;
  int quantity;
  String orderDate;
  String imageUrl;
  double totalAmount;
  String asoUid;
  String feedback;

  MyFeedback({
    required this.distributorName,
    required this.product,
    required this.quantity,
    required this.address,
    required this.orderDate,
    required this.imageUrl,
    required this.totalAmount,
    required this.asoUid,
    required this.feedback,
  });

  @override
  String toString() {
    return '''
      Feedback Details:
      Distributor Name: $distributorName
      Address: $address
      Product: $product
      Quantity: $quantity
      Order Date: $orderDate
      Image URL: $imageUrl
      Total Amount: $totalAmount
      ASO UID: $asoUid
      Feedback: $feedback
    ''';
  }
}
