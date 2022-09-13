import 'dart:io'; //for detecting platforms

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';

import './widgets/transaction_list.dart';
import './widgets/new_transaction.dart';
import './models/transaction.dart';
import './widgets/chart.dart';

void main() {
  //to enable landscape only
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  const MyApp();
  final myAppBar = null;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses App',
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.amber,
        errorColor: Colors.red,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              titleMedium: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              // button: TextStyle(color: Colors.white)
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                titleMedium: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String titleInput = '';

  String amountInput = '';
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _transactionList.where((tx) {
      return tx.dateTime.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  // var titleController = TextEditingController();

  // var amountController = TextEditingController();

  final List<Transaction> _transactionList = [
    // Transaction(
    //     id: "1", title: "item 1", amount: 27.4, dateTime: DateTime.now()),
    // Transaction(
    //     id: "1", title: "item 1", amount: 27.4, dateTime: DateTime.now()),
  ];

  void _addNewTransaction(String title, double amount, DateTime date) {
    final newtx = Transaction(
      amount: amount,
      title: title,
      dateTime: date,
      id: date.toString(),
    );

    setState(() {
      _transactionList.add(newtx);
    });
  }

  void _showAddTransactionPopUp(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_bCtx) {
        return NewTransaction(_addNewTransaction);
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactionList.removeWhere((element) => element.id == id);
    });
  }

  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isPortrait = mediaQuery.orientation == Orientation.portrait;

    final ObstructingPreferredSizeWidget myAppBar = (Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Personal Expenses'),
            trailing: GestureDetector(
              onTap: () => _showAddTransactionPopUp(context),
              child: Icon(Icons.add),
            ),
          )
        : AppBar(
            title: Text('personal exp. app'),
            actions: [
              IconButton(
                  onPressed: () => _showAddTransactionPopUp(context),
                  icon: Icon(Icons.add)),
            ],
          )) as ObstructingPreferredSizeWidget;

    final transList = Container(
      height: (mediaQuery.size.height -
              myAppBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(_transactionList, _deleteTransaction),
    );

    final pageBody = SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isPortrait)
            Container(
              height: (mediaQuery.size.height -
                      myAppBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.3,
              child: Chart(_recentTransactions),
            ),
          if (isPortrait) transList,
          if (!isPortrait)
            Container(
              height: (mediaQuery.size.height -
                      myAppBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                      child: Text(
                    'Show Chart',
                    style: Theme.of(context).textTheme.titleMedium,
                  )),
                  Switch.adaptive(
                      activeColor: Theme.of(context).accentColor,
                      value: _showChart,
                      onChanged: (newValue) {
                        setState(() {
                          _showChart = newValue;
                        });
                      })
                ],
              ),
            ),
          if (!isPortrait)
            _showChart
                ? Container(
                    height: (mediaQuery.size.height -
                            myAppBar.preferredSize.height -
                            mediaQuery.padding.top) *
                        0.8,
                    child: Chart(_recentTransactions),
                  )
                : transList
        ],
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: myAppBar,
          )
        : Scaffold(
            appBar: myAppBar,
            body: pageBody,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () => {
                      _showAddTransactionPopUp(context),
                    },
                    child: Icon(Icons.add),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
