class LeaveRequest {
  final String startDate;
  final String endDate;
  final String reason;
  final String status;
  final String applyDate;

  LeaveRequest({
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.status,
    required this.applyDate,
  });

  String toString() {
    return "$startDate $endDate $reason $status";
  }
}
