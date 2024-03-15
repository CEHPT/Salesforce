class MyOrder {
  String distributorName;
  String address;
  String product;
  int quantity;
  String orderDate;
  String imageUrl;
  double totalAmount;
  String asoUid;

  MyOrder({
    required this.distributorName,
    required this.product,
    required this.quantity,
    required this.address,
    required this.orderDate,
    required this.imageUrl,
    required this.totalAmount,
    required this.asoUid,
  });

  @override
  String toString() {
    return 'Order: Distributor Name - $distributorName, Address - $address, Product - $product, Quantity - $quantity, Order Date - $orderDate, Image URL - $imageUrl, Total Amount - $totalAmount, ASO UID - $asoUid';
  }
}
