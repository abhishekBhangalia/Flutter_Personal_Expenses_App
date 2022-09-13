import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactionList;
  final Function _deleteTransaction;

  TransactionList(this.transactionList, this._deleteTransaction);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Container(
      height: 500,
      child: transactionList.isEmpty
          ? LayoutBuilder(
              builder: (ctx, constraints) {
                return Column(
                  children: [
                    Text(
                      'No transaction is added yet !',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(
                      height: constraints.maxHeight * 0.1,
                    ),
                    Container(
                      height: constraints.maxHeight * 0.6,
                      child: Image.asset(
                        'assets/images/waiting.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                );
              },
            )
          : ListView.builder(
              itemCount: transactionList.length,
              itemBuilder: ((context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  elevation: 5,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: FittedBox(
                          child: Text(
                            transactionList[index].amount.toStringAsFixed(2),
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      transactionList[index].title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      DateFormat.yMMMd()
                          .format(transactionList[index].dateTime),
                    ),
                    trailing: mediaQuery.size.width > 400
                        ? TextButton(
                          
                            onPressed: () =>
                                _deleteTransaction(transactionList[index].id),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('delete',style: TextStyle(color: Theme.of(context).errorColor),),
                                Icon(Icons.delete,color: Theme.of(context).errorColor,),
                              ],
                            ),

                            )
                        : IconButton(
                            icon: Icon(Icons.delete),
                            color: Theme.of(context).errorColor,
                            onPressed: () =>
                                _deleteTransaction(transactionList[index].id),
                          ),
                  ),
                );

                // Card(
                //   child: Row(
                //     children: [
                //       Container(
                //         margin: EdgeInsets.symmetric(
                //           horizontal: 15,
                //           vertical: 10,
                //         ),
                //         decoration: BoxDecoration(
                //           border: Border.all(
                //             color: Theme.of(context).primaryColor,
                //             width: 2,
                //           ),
                //         ),
                //         padding: EdgeInsets.all(10),
                //         child: Text(
                //           transactionList[index].amount.toStringAsFixed(2),
                //           style: TextStyle(
                //             color: Theme.of(context).primaryColor,
                //             fontWeight: FontWeight.bold,
                //             fontSize: 20,
                //           ),
                //         ),
                //       ),
                //       Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Text(
                //             transactionList[index].title,
                //             style: Theme.of(context).textTheme.titleMedium,
                //           ),
                //           Text(
                //             DateFormat.yMMMd()
                //                 .format(transactionList[index].dateTime),
                //             style: TextStyle(
                //               color: Colors.grey,
                //               fontSize: 10,
                //             ),
                //           )
                //         ],
                //       )
                //     ],
                //   ),
                // );
              }),
            ),
    );
  }
}
