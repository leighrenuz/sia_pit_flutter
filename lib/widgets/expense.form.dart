import 'package:flutter/material.dart';

class ExpenseForm extends StatefulWidget {
  final Function(String, double, String) onSubmit;

  ExpenseForm({required this.onSubmit});

  @override
  _ExpenseFormState createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  double _amount = 0;
  String _category = 'CAR'; // Default category

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Expense'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
              onSaved: (value) {
                _name = value!;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || double.tryParse(value) == null) {
                  return 'Please enter a valid amount';
                }
                return null;
              },
              onSaved: (value) {
                _amount = double.parse(value!);
              },
            ),
            DropdownButtonFormField<String>(
              value: _category,
              items: [
                DropdownMenuItem(
                  child: Text('CAR'),
                  value: 'CAR',
                ),
                DropdownMenuItem(
                  child: Text('UTILITIES'),
                  value: 'UTILITIES',
                ),
                DropdownMenuItem(
                  child: Text('RENT'),
                  value: 'RENT',
                ),
                DropdownMenuItem(
                  child: Text('CLOTHING'),
                  value: 'CLOTHING',
                ),
                DropdownMenuItem(
                  child: Text('TRAVEL'),
                  value: 'TRAVEL',
                ),
                DropdownMenuItem(
                  child: Text('EATING OUT'),
                  value: 'EATING OUT',
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _category = value!;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a category';
                }
                return null;
              },
              onSaved: (value) {
                _category = value!;
              },
              decoration: InputDecoration(labelText: 'Category'),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              widget.onSubmit(_name, _amount, _category);
              Navigator.of(context).pop();
            }
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
