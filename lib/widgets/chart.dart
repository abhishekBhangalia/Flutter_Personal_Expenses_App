import 'package:flutter/material.dart';
import 'package:personal_expenses/widgets/chart_bar.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> weeklyTransaction;

  Chart(this.weeklyTransaction);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      double amount = 0.0;

      for (int i = 0; i < weeklyTransaction.length; i++) {
        if (weeklyTransaction[i].dateTime.day == weekDay.day &&
            weeklyTransaction[i].dateTime.month == weekDay.month &&
            weeklyTransaction[i].dateTime.year == weekDay.year) {
          amount += weeklyTransaction[i].amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': amount,
      };
    }).reversed.toList();
  }

  double get totalWeekSpending {
    return groupedTransactionValues.fold(
        0.0, (sum, element) => sum = sum + (element['amount'] as double));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map((e) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                  e['day'] as String,
                  e['amount'] as double,
                  totalWeekSpending == 0.0
                      ? 0.0
                      : (e['amount'] as double) / totalWeekSpending),
            );
          }).toList(),
        ),
      ),
    );
  }
}
