class WaterConsumption {
  final int? id;
  final double amount;
  final DateTime date;

  WaterConsumption({
    this.id,
    required this.amount,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'date': date.toIso8601String().split('T')[0],
    };
  }

  factory WaterConsumption.fromMap(Map<String, dynamic> map) {
    return WaterConsumption(
      id: map['id'] as int?,
      amount: map['amount'] as double,
      date: DateTime.parse(map['date'] as String),
    );
  }

  WaterConsumption copyWith({
    int? id,
    double? amount,
    DateTime? date,
  }) {
    return WaterConsumption(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      date: date ?? this.date,
    );
  }
}