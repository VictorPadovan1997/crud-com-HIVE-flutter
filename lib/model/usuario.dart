import 'package:hive_flutter/hive_flutter.dart';

part 'usuario.g.dart';

@HiveType(typeId: 0)
class Usuario extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  DateTime createdDate;

  @HiveField(2)
  bool isExpense = true;

  @HiveField(3)
  double amount;

  Usuario({
    required this.name,
    required this.createdDate,
    required this.isExpense,
    required this.amount,
  });
}
