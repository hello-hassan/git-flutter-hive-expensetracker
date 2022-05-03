import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hive_expensetracker/controllers/hiveHelper.dart';
import 'package:flutter_hive_expensetracker/pages/add_transaction.dart';
import 'package:flutter_hive_expensetracker/static.dart' as Static;
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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

  int _totalBalance = 0;
  int _totalIncome = 0;
  int _totalExpense = 0;

  getTotalBalance(Map dataMap)
  {
    _totalExpense = 0;
    _totalIncome = 0;
    _totalBalance = 0;

    dataMap.forEach((key, value) {
      if(HiveHelper.getTransactionType(value['type']) == TransactionType.Income)
      {
        _totalIncome += value['amount'] as int;
      }
      else
      {
        _totalExpense += value['amount'] as int;
      }
      _totalBalance = _totalIncome - _totalExpense;
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
      body: FutureBuilder(
        future: HiveHelper.getData(),
        builder: (context, snapshot) {
          if(snapshot.hasError)
          {
            return Center(
              child: Text('Unexpected Error !'),
            );
          }
          if(snapshot.hasData)
          {
            getTotalBalance(snapshot.data as Map);
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: Colors.grey[200],
                          ),
                          child: Icon(
                            Icons.settings,
                            size: 32.0,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),

                      SizedBox(height: 20,),

                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Expense Tracker',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Static.PrimaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20,),

                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: EdgeInsets.all(12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Static.PrimaryColor,
                          Colors.purpleAccent
                        ]
                      ),

                      borderRadius: BorderRadius.all(Radius.circular(24)),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0,),
                    child: Column(
                      children: [
                        Text(
                          'Total Balance',
                          style: TextStyle(
                            fontSize: 22.0,

                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '\$${_totalBalance}',
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IncomeCardWidget('\$${_totalIncome}'),
                            ExpenseCardWidget('\$${_totalExpense}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20,),

                Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    'Recent Expenses',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Static.PrimaryColor,
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(bottom: 70),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: (snapshot.data! as Map).length,
                    itemBuilder: (context, index) {
                      Map data = (snapshot.data! as Map)[index];

                      DateTime date = data['date'] as DateTime;
                      String dateString = '${monthsList[date.month - 1]} ${date.day}, ${date.year}';

                      if(HiveHelper.getTransactionType(data['type']) == TransactionType.Income)
                      {
                        return IncomeTileWidget(data['amount'], data['note'], dateString);
                      }
                      else
                      {
                        return ExpenseTileWidget(data['amount'], data['note'], dateString);
                      }
                    },
                  ),
                ),

              ],
            );
          }
          else
          {
          return Center(
          child: Text('No Data Found !'),
          );
          }
        },
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddTransaction(),));
        },
        child: Icon(
          Icons.add,
          size: 32,
        ),
        backgroundColor: Static.PrimaryColor,
      ),
    );
  }

  Widget IncomeCardWidget(String value) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white60,
            borderRadius: BorderRadius.circular(
              20.0,
            ),
          ),
          padding: EdgeInsets.all(
            6.0,
          ),
          child: Icon(
            Icons.arrow_downward,
            size: 28.0,
            color: Colors.green[700],
          ),
          margin: EdgeInsets.only(
            right: 8.0,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Income",
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.white70,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget ExpenseCardWidget(String value) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white60,
            borderRadius: BorderRadius.circular(
              20.0,
            ),
          ),
          padding: EdgeInsets.all(
            6.0,
          ),
          child: Icon(
            Icons.arrow_upward,
            size: 28.0,
            color: Colors.red[700],
          ),
          margin: EdgeInsets.only(
            right: 8.0,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Expense",
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.white70,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget ExpenseTileWidget(int amount, String note, String date)
  {
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.arrow_circle_up_outlined,
                color: Colors.red[700],
                size: 35.0,
              ),

              SizedBox(width: 8.0,),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Expense',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),

                  Container(
                    width: 220,
                    child: Text(
                      '${date}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[800],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  Container(
                    width: 220,
                    child: Text(
                      '${note}',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[800],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            '-\$${amount}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget IncomeTileWidget(int amount, String note, String date)
  {
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.arrow_circle_down_outlined,
                color: Colors.green[700],
                size: 35.0,
              ),

              SizedBox(width: 8.0,),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    'Income',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),

                  Container(
                    width: 220,
                    child: Text(
                      '${date}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[800],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  Container(
                    width: 220,
                    child: Text(
                      '${note}',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[800],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            '+\$${amount}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green[700],
            ),
          ),
        ],
      ),
    );
  }
}
