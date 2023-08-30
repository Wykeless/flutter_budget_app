class Budget {
  final String year;
  final String month;
  final String budgetName; //Year + Month txt file

  Budget({
    required this.year,
    required this.month,
    required this.budgetName,
  });

  Budget copyWith({
    String? year,
    String? month,
    String? budgetName,
  }) {
    return Budget(
      year: year ?? this.year,
      month: month ?? this.month,
      budgetName: budgetName ?? this.budgetName,
    );
  }
}
