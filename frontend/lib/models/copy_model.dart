class CopyModel {
  final String id;
  final String bookId;
  final String barcode;
  final String status;
  final String location;
  final String condition;
  final DateTime addedDate;

  CopyModel({
    required this.id,
    required this.bookId,
    required this.barcode,
    required this.status,
    required this.location,
    required this.condition,
    DateTime? addedDate,
  }) : addedDate = addedDate ?? DateTime.now();
  

}
