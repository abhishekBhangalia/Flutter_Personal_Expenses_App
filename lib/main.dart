import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:personal_expenses/widgets/transaction_list.dart';
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
    final myAppBar = AppBar(
      title: Text('personal exp. app'),
      actions: [
        IconButton(
            onPressed: () => _showAddTransactionPopUp(context),
            icon: Icon(Icons.add)),
      ],
    );

    return Scaffold(
      appBar: myAppBar,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: (MediaQuery.of(context).size.height -
                      myAppBar.preferredSize.height -
                      MediaQuery.of(context).padding.top) *
                  0.4,
              child: Chart(_recentTransactions),
            ),
            Container(
              height: (MediaQuery.of(context).size.height -
                      myAppBar.preferredSize.height -
                      MediaQuery.of(context).padding.top) *
                  0.6,
              child: TransactionList(_transactionList, _deleteTransaction),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          _showAddTransactionPopUp(context),
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
