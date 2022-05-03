import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hive_expensetracker/controllers/hiveHelper.dart';
import 'package:flutter_hive_expensetracker/pages/home_page.dart';
import 'package:flutter_hive_expensetracker/static.dart' as Static;

enum TransactionType
{
  Income,
  Expense
}

class AddTransaction extends StatefulWidget {
  const AddTransaction({Key? key}) : super(key: key);

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {

  List<String> monthsList = [
    'Jan',
    'Feb',
    'Mar',
    'April',
    'May',
    'June',
    'July',
    'Aug',
    'Sep',
    'Oct',
    'Dec',
  ];

  int? amount;
  String? note = 'Transaction Details';
  TransactionType type = TransactionType.Income;
  DateTime selectedDate = DateTime.now();

  Future<void> selectDate(BuildContext context) async
  {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2022, 01),
        lastDate: DateTime(2022, 12));

    if(pickedDate != null && pickedDate != selectedDate)
    {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
      body: ListView(
        padding: EdgeInsets.all(12.0),
        children: [
          Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300],
                ),
                child: IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back,),
                  color: Colors.grey[800],
                  alignment: Alignment.center,
                ),
              ),

              Expanded(child: Container()),
            ],
          ),

          Text(
            'Add Transaction',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
              color: Static.PrimaryColor,
            ),
          ),

          SizedBox(height: 30.0,),

          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Static.PrimaryColor,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Icon(
                  Icons.attach_money,
                  color: Colors.white,
                  size: 24.0,
                )
              ),

              SizedBox(width: 12.0,),

              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '0',
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    fontSize: 24.0,
                  ),

                  onChanged: (value) {
                    amount = int.parse(value);
                  },

                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 20.0,),

          Row(
            children: [
              Container(
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Static.PrimaryColor,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Icon(
                    Icons.description,
                    color: Colors.white,
                    size: 24.0,
                  )
              ),

              SizedBox(width: 12.0,),

              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Note on Transaction',
                    border: InputBorder.none,
                  ),

                  onChanged: (value) {
                    note = value;
                  },

                  style: TextStyle(
                    fontSize: 24.0,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 20,),

          Row(
            children: [
              Container(
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Static.PrimaryColor,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Icon(
                    Icons.moving_sharp,
                    color: Colors.white,
                    size: 24.0,
                  )
              ),

              SizedBox(width: 12.0,),

              ChoiceChip(
                label: Text(
                  'Income',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: (type == TransactionType.Income) ? Colors.white : Colors.grey[700],
                  ),
                ),
                selectedColor: Static.PrimaryColor,
                selected: type == TransactionType.Income,
                onSelected: (value) {
                  type = TransactionType.Income;

                  setState(() {

                  });
                },
              ),

              SizedBox(width: 12.0,),

              ChoiceChip(
                label: Text(
                  'Expense',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: (type == TransactionType.Expense) ? Colors.white : Colors.grey[700],
                  ),
                ),
                selectedColor: Static.PrimaryColor,
                selected: type == TransactionType.Expense,
                onSelected: (value) {
                  type = TransactionType.Expense;

                  setState(() {

                  });
                },
              ),
            ],
          ),

          SizedBox(height: 20.0,),

          SizedBox(
            height: 50.0,
            child: TextButton(
              onPressed: () {
                selectDate(context);
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero),
              ),
              child: Row(
                children: [
                  Container(
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Static.PrimaryColor,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Icon(
                        Icons.date_range,
                        color: Colors.white,
                        size: 24.0,
                      )
                  ),

                  SizedBox(width: 12.0,),

                  Text(
                    '${monthsList[selectedDate.month - 1]} ${selectedDate.day}, ${selectedDate.year}',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20.0,),

          SizedBox(
            height: 50.0,
            child: ElevatedButton(
              onPressed: (){
                if(amount != null && note!.isNotEmpty)
                {
                  HiveHelper.addData(amount!, selectedDate, note!, type);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(),));
                }
              },
              child: Text(
                'Add',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),

    );
  }
}
