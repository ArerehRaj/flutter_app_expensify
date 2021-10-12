import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum TransactionMode { daily, monthly }

class NewTransactionForm extends StatefulWidget {
  const NewTransactionForm({Key? key, required this.mode}) : super(key: key);
  final TransactionMode mode;
  @override
  _NewTransactionFormState createState() => _NewTransactionFormState();
}

class _NewTransactionFormState extends State<NewTransactionForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TransactionMode _transactionMode = TransactionMode.daily;

  Map<String, Object> _transactionData = {
    'title': '',
    'amount': 0.0,
    'date': DateTime.now(),
  };

  var _isLoading = false;
  var _selectedDate = null;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Card(
          elevation: 5,
          child: Container(
            padding: EdgeInsets.only(
              top: 10,
              right: 10,
              left: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 25,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(
                      Icons.title_rounded,
                    ),
                    hintText: 'Title',
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    // Check here for validation
                  },
                  onSaved: (value) =>
                      _transactionData['title'] = value.toString(),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(
                      Icons.money_rounded,
                    ),
                    hintText: 'Amount',
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    // Check here for validation
                  },
                  onSaved: (value) => _transactionData['amount'] =
                      double.parse(value.toString()),
                ),
                Container(
                  height: 70,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedDate == null
                              ? 'No Date Chosen!'
                              : 'Picked Date ${DateFormat.yMd().format(_selectedDate as DateTime)}',
                        ),
                      ),
                      FlatButton(
                        onPressed: () {},
                        child: const Text(
                          'Select A Date',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        textColor: Theme.of(context).primaryColor,
                      )
                    ],
                  ),
                ),
                RaisedButton(
                  onPressed: () {},
                  child: const Text('Add Transaction'),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
