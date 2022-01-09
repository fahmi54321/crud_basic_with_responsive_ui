import 'package:flutter/material.dart';
import './widget/new_transaction.dart';
import './widget/chart.dart';
import './models/transaction.dart';
import './widget/transaction_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        errorColor: Colors.red,
        fontFamily: 'OpenSans',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline1: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              button: TextStyle(
                color: Colors.white,
              ),
            ),
        appBarTheme: AppBarTheme(
          toolbarTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
          ),
        ),
      ),
      home: MyHomePage(),
    );
  } //
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactionList = [
    Transaction(
      id: 't1',
      title: 'New shoes',
      amount: 69.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: 'New shoes 2',
      amount: 16.53,
      date: DateTime.now(),
    ),
  ];

  List<Transaction> get _recentTransactions {
    return _transactionList.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(
      String txtTitle, double txtAmount, DateTime chooseDate) {
    final newTrans = Transaction(
      id: DateTime.now().toString(),
      title: txtTitle,
      amount: txtAmount,
      date: chooseDate,
    );

    setState(() {
      _transactionList.add(newTrans);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactionList.removeWhere((element) {
        return element.id == id;
      });
    });
  }

  bool _showChart = false;

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final appBar = AppBar(
      title: Text(
        'Crup Basic App',
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.add,
          ),
          onPressed: () => _startAddNewTransaction(context),
        )
      ],
    );

    final txListWidget = Container(
        height: (MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top /* status bar */) *
            0.7,
        child: TransactionList(_transactionList, _deleteTransaction));

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Show Chart'),
                  Switch(
                      value: _showChart,
                      onChanged: (value) {
                        setState(() {
                          _showChart = value;
                        });
                      }),
                ],
              ),


            if (!isLandscape)
              Container(
                  height: (MediaQuery.of(context).size.height -
                          appBar.preferredSize.height - // appbar
                          MediaQuery.of(context).padding.top /* status bar */) *
                      0.3,
                  child: Chart(_recentTransactions)),
            if (!isLandscape) txListWidget,


            if (isLandscape)
              _showChart
                  ? Container(
                      height: (MediaQuery.of(context).size.height -
                              appBar.preferredSize.height - // appbar
                              MediaQuery.of(context)
                                  .padding
                                  .top /* status bar */) *
                          0.7,
                      child: Chart(_recentTransactions))
                  : txListWidget

          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}
