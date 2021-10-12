import 'package:expensify_app/providers/transactions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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

  // function to show the date picker to user
  // and once selected show the value of it in selected date
  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
        _transactionData['date'] = pickedDate;
      });
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      // invalid
      return;
    }

    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    // code for saving on the firebase
    try {
      if (_transactionMode == TransactionMode.daily) {
        await Provider.of<Transactions>(context, listen: false).addTransaction(
          double.parse(_transactionData['amount'].toString()),
          _transactionData['date'] as DateTime,
          _transactionData['title'].toString(),
        );
      }
    } catch (error) {
      throw error;
    }

    // after complete response
    setState(() {
      Navigator.of(context).pop();
      _isLoading = false;
    });
  }

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
                    if (value!.isEmpty) {
                      return 'Please enter a Title!';
                    }
                    return null;
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
                    if (double.parse(value.toString()) <= 0.0) {
                      return 'Please enter a valid amount!';
                    }
                    return null;
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
                        onPressed: _presentDatePicker,
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
                _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : RaisedButton(
                        onPressed: _submitForm,
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
