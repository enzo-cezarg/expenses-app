import 'package:expenses_app/components/chart.dart';
import 'package:expenses_app/components/transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'components/transaction_list.dart';
import 'models/transaction.dart';
import 'dart:math';
import 'dart:io';

main() => runApp(ExpensesApp());

class ExpensesApp extends StatefulWidget {
  const ExpensesApp({super.key});

  @override
  State<ExpensesApp> createState() => _ExpensesAppState();
}

class _ExpensesAppState extends State<ExpensesApp> {
  final ThemeData theme = ThemeData();

  bool lightThemeOn = false;

  _toggleTheme() {
    setState(() {
      lightThemeOn = !lightThemeOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(
        toggleTheme: _toggleTheme,
      ),
      theme: ThemeData(
        useMaterial3: false,
        fontFamily: 'OpenSans',
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
        ),
        colorScheme: lightThemeOn
            ? ColorScheme.fromSeed(
                seedColor: Color.fromARGB(255, 111, 255, 233),
                primary: Color.fromARGB(255, 237, 242, 244),
                secondary: Color.fromARGB(255, 28, 37, 65), // Color.fromARGB(255, 111, 255, 233),
                tertiary: Color.fromARGB(255, 215, 226, 230),
                inversePrimary: Color.fromARGB(255, 11, 19, 43),
                error: Color.fromARGB(255, 180, 50, 60),
              )
            : ColorScheme.fromSeed(
                seedColor: Color.fromARGB(255, 111, 255, 233),
                primary: Color.fromARGB(255, 28, 37, 65),
                secondary: Color.fromARGB(255, 111, 255, 233),
                tertiary: Color.fromARGB(255, 11, 19, 43),
                inversePrimary: Color.fromARGB(255, 237, 242, 244),
                error: Color.fromARGB(255, 180, 50, 60),
              ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.toggleTheme, super.key});

  final Function toggleTheme;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [];
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  _removeTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tr) => tr.id == id);
    });
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (_) {
        return Container(margin: EdgeInsets.all(20), child: TransactionForm(_addTransaction));
      },
    );
  }

  Widget _getIconButton(IconData icon, VoidCallback fn) {
    return Platform.isIOS
        ? GestureDetector(
            onTap: fn,
            child: Icon(icon),
          )
        : IconButton(
            onPressed: fn,
            icon: Icon(icon),
          );
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    final actions = [
      _getIconButton(Platform.isIOS ? CupertinoIcons.circle_lefthalf_fill : Icons.brightness_6_sharp, () => widget.toggleTheme()),
      if (isLandscape)
        _getIconButton(
          _showChart ? Icons.list : Icons.bar_chart,
          () {
            setState(() {
              _showChart = !_showChart;
            });
          },
        ),
      _getIconButton(
        Platform.isIOS ? CupertinoIcons.add : Icons.add,
        () => _openTransactionFormModal(context),
      ),
    ];

    final appBar = AppBar(
      title: Text(
        'Personal Expenses',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        textScaler: MediaQuery.textScalerOf(context), // Propriedade Default no Flutter 3.10+
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      actions: actions,
    );

    final availableHeight = MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top;

    final bodyPage = SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (_showChart || !isLandscape)
            SizedBox(
              height: availableHeight * (isLandscape ? 0.7 : 0.3),
              child: Chart(_recentTransactions),
            ),
          if (!_showChart || !isLandscape)
            SizedBox(
              height: availableHeight * (isLandscape ? 1 : 0.7),
              child: TransactionList(_transactions, _removeTransaction),
            ),
        ],
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text('Personal Expenses'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: actions,
              ),
            ),
            child: SafeArea(child: bodyPage),
          )
        : Scaffold(
            backgroundColor: Theme.of(context).colorScheme.tertiary,
            appBar: appBar,
            body: bodyPage,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Theme.of(context).colorScheme.tertiary,
                    shape: CircleBorder(),
                    onPressed: () => _openTransactionFormModal(context),
                    child: Icon(Icons.add),
                  ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          );
  }
}
