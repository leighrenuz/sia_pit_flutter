import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../widgets/expense.form.dart'; 
import '../models/expense.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Expense> _expenses;
  late List<Expense> _expenseList;

  // Icons for each category
  Map<String, IconData> categoryIcons = {
    'CAR': Icons.directions_car,
    'UTILITIES': Icons.local_gas_station,
    'RENT': Icons.home,
    'CLOTHING': Icons.shopping_bag,
    'TRAVEL': Icons.flight,
    'EATING OUT': Icons.restaurant,
  };

  @override
  void initState() {
    super.initState();
    _expenses = [
      Expense(category: 'CAR', name: '', amount: 0),
      Expense(category: 'UTILITIES', name: '', amount: 0),
      Expense(category: 'RENT', name: '', amount: 0),
      Expense(category: 'CLOTHING', name: '', amount: 0),
      Expense(category: 'TRAVEL', name: '', amount: 0),
      Expense(category: 'EATING OUT', name: '', amount: 0),
    ];
    _expenseList = [];
  }

  void _addExpense(String name, double amount, String category) {
    setState(() {
      int categoryIndex =
          _expenses.indexWhere((expense) => expense.category == category);
      if (categoryIndex != -1) {
        _expenses[categoryIndex] = Expense(
          category: category,
          name: _expenses[categoryIndex].name,
          amount: _expenses[categoryIndex].amount + amount,
        );
        _expenseList
            .add(Expense(category: category, name: name, amount: amount));
        print('Expense Added: $name, $amount, $category'); // Debugging
      }
    });
  }

  void _editExpense(int index, String name, double amount) {
    setState(() {
      String category = _expenseList[index].category;
      double oldAmount = _expenseList[index].amount;
      _expenseList[index] =
          Expense(category: category, name: name, amount: amount);

      // Update the corresponding expense in _expenses to reflect the new total
      int categoryIndex =
          _expenses.indexWhere((expense) => expense.category == category);
      if (categoryIndex != -1) {
        _expenses[categoryIndex] = Expense(
          category: category,
          name: _expenses[categoryIndex].name,
          amount: _expenses[categoryIndex].amount - oldAmount + amount,
        );
        print('Expense Edited: $name, $amount, $category'); // Debugging
      }
    });
  }

  void _deleteExpense(int index) {
    setState(() {
      String category = _expenseList[index].category;
      double amount = _expenseList[index].amount;
      _expenseList.removeAt(index);
      int categoryIndex =
          _expenses.indexWhere((expense) => expense.category == category);
      if (categoryIndex != -1) {
        _expenses[categoryIndex] = Expense(
          category: category,
          name: _expenses[categoryIndex].name,
          amount: _expenses[categoryIndex].amount - amount,
        );
        print('Expense Deleted: $index'); // Debugging
      }
    });
  }

  double _calculateTotal() {
    return _expenseList.fold(0, (sum, expense) => sum + expense.amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green, // Change to green
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.green[200], // Sage green background
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Your Expenses',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Container(
              height: 300,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: _buildChart(),
            ),
            SizedBox(height: 10),
            Text(
              'Total: ₱${_calculateTotal().toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _expenseList.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading:
                          Icon(categoryIcons[_expenseList[index].category]),
                      title: Text(_expenseList[index].name),
                      subtitle: Text(
                          '${_expenseList[index].category} - ₱${_expenseList[index].amount.toStringAsFixed(2)}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => ExpenseForm(
                                  onSubmit: (name, amount, category) {
                                    _editExpense(index, name, amount);
                                  },
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteExpense(index),
                          ),
                        ],
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => ExpenseForm(
                            onSubmit: (name, amount, category) {
                              _editExpense(index, name, amount);
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              _showCategoryDialog();
            },
            tooltip: 'Add Expense',
            child: Icon(Icons.add),
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () {
              _showExpenseHistory();
            },
            tooltip: 'History',
            child: Icon(Icons.history),
            backgroundColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    List<charts.Series<Expense, String>> series = [
      charts.Series(
        id: 'Expenses',
        data: _expenses,
        domainFn: (Expense expense, _) => expense.category,
        measureFn: (Expense expense, _) => expense.amount,
        colorFn: (Expense expense, _) {
          switch (expense.category) {
            case 'CAR':
              return charts.ColorUtil.fromDartColor(Colors.green.shade400);
            case 'UTILITIES':
              return charts.ColorUtil.fromDartColor(Colors.green.shade600);
            case 'RENT':
              return charts.ColorUtil.fromDartColor(Colors.green.shade800);
            case 'CLOTHING':
              return charts.ColorUtil.fromDartColor(Colors.green.shade900);
            case 'TRAVEL':
              return charts.ColorUtil.fromDartColor(Colors.green.shade200);
            case 'EATING OUT':
              return charts.ColorUtil.fromDartColor(Colors.green.shade300);
            default:
              return charts.ColorUtil.fromDartColor(Colors.green);
          }
        },
      ),
    ];

    return charts.BarChart(
      series,
      animate: true,
      animationDuration: Duration(seconds: 1),
    );
  }

  void _showCategoryDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Category'),
          content: SingleChildScrollView(
            child: ListBody(
              children: categoryIcons.keys.map((category) {
                return GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(categoryIcons[category]),
                        SizedBox(width: 10),
                        Text(category),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    showDialog(
                      context: context,
                      builder: (context) => ExpenseForm(
                        onSubmit: (name, amount, _) {
                          _addExpense(name, amount, category);
                        },
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void _showExpenseHistory() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Expense History'),
          content: SingleChildScrollView(
            child: ListBody(
              children: _expenseList.map((expense) {
                return ListTile(
                  leading: Icon(categoryIcons[expense.category]),
                  title: Text(expense.name),
                  subtitle: Text(
                      '${expense.category} - ₱${expense.amount.toStringAsFixed(2)}'),
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
