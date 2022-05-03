import 'package:flutter_hive_expensetracker/pages/add_transaction.dart';
import 'package:hive/hive.dart';

class HiveHelper
{
  static Box? _box;

  
  static _openBox()
  {
    _box = Hive.box('income_expense');
  }

  static addData(int amount, DateTime date, String note, TransactionType type)
  {
    String transactionType = (type == TransactionType.Income) ? "income" : "expense";

    Map<String, dynamic> map = {
      'amount' : amount,
      'date' : date,
      'note' : note,
      'type' : transactionType,
    };

    _openBox();
    _box!.add(map);
  }

  static Future<Map> getData() async
  {
    _openBox();
    return Future.value(_box!.toMap());
  }

  static TransactionType getTransactionType(String type)
  {
    return (type == "income") ? TransactionType.Income : TransactionType.Expense;
  }
}