class Transaction {
  final String transactionType;
  final String date;
  final double amount;
  final String note;

  Transaction({
    required this.transactionType,
    required this.date,
    required this.amount,
    required this.note,
  });

  Transaction copyWith({
    String? transactionType,
    String? date,
    double? amount,
    String? note,
  }) {
    return Transaction(
      transactionType: transactionType ?? this.transactionType,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      note: note ?? this.note,
    );
  }
}
