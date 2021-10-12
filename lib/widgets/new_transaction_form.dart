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

  // Seeting the default mode to daily transactions
  TransactionMode _transactionMode = TransactionMode.daily;

  // A map of String Objects to store the
  //transaction Data while filling the form
  Map<String, Object> _transactionData = {
    'title': '',
    'amount': 0.0,
    'date': DateTime.now(),
  };

  // Vars for showing loading and
  //checking if the user has selected a date or not
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
                // Text Input for Title
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
                  // Saving the title value in the transactionData map
                ),
                // Text Input for Amount
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
                  // Saving the amount value in the transactionData map
                ),
                // Container to show the selected Date if selected and
                //the option to select the date
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
                // Button to submit the form for adding the transaction
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
