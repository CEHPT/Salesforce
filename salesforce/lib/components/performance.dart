class EmployeeMonthlyPerformance {
  EmployeeMonthlyPerformance(
    this.presentCount,
    this.orderCount,
    this.totalAmountOfOrders,
    this.totalFeedbacksCollected,
    this.totalNumberOfProductsSell,
    this.asoUid,
    this.asoName,
  );

  final int presentCount;
  final int orderCount;
  final double totalAmountOfOrders;
  final int totalFeedbacksCollected;
  final int totalNumberOfProductsSell;
  final String asoUid;
  final String asoName;

  @override
  String toString() {
    return 'EmployeeMonthlyPerformance{'
        'persentCount: $presentCount, '
        'orderCount: $orderCount, '
        'totalAmountOfOrder: $totalAmountOfOrders, '
        'totalFeedbacksCollected: $totalFeedbacksCollected, '
        'totalNumberOfProductsSell: $totalNumberOfProductsSell, '
        'asoUid: $asoUid, '
        'asoName: $asoName}';
  }
}
