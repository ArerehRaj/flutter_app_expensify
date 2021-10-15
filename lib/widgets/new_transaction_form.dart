import 'package:expensify_app/providers/transactions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// setting a enum for daily or monthly transactions
enum TransactionMode { daily, monthly }

class NewTransactionForm extends StatefulWidget {
  const NewTransactionForm({Key? key, required this.mode}) : super(key: key);
  final TransactionMode mode;

  // accepting the transaction mode from constructor
  @override
  _NewTransactionFormState createState() => _NewTransactionFormState();
}

class _NewTransactionFormState extends State<NewTransactionForm> {
  // creating a global key for the form
  final GlobalKey<FormState> _formKey = GlobalKey();

  // Seeting the default mode to daily transactions
  // final TransactionMode _transactionMode =  ; // TransactionMode.daily;

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

  // async function to submit the form to firebase
  // with all the valid input data
  Future<void> _submitForm() async {
    // if form validation fails then return
    if (!_formKey.currentState!.validate()) {
      // invalid
      return;
    }

    // saving the state of the form and
    // showing the loading screen
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    // code for saving on the firebase
    try {
      // checking if the transaction mode is daily
      if (widget.mode == TransactionMode.daily) {
        // provider method to add the transaction of the user in UI and firebase
        await Provider.of<Transactions>(context, listen: false).addTransaction(
          double.parse(_transactionData['amount'].toString()),
          _transactionData['date'] as DateTime,
          _transactionData['title'].toString(),
          'daily_transactions',
        );
      } else if (widget.mode == TransactionMode.monthly) {
        await Provider.of<Transactions>(context, listen: false).addTransaction(
          double.parse(_transactionData['amount'].toString()),
          _transactionData['date'] as DateTime,
          _transactionData['title'].toString(),
          'monthly_transactions',
        );
      }
    } catch (error) {
      // if error occurs then show the error message box
      final deviceSize = MediaQuery.of(context).size;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text('An error occured'),
            ],
          ),
          content: Text(
            error.toString(),
            textAlign: TextAlign.center,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          actions: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: deviceSize.width * 0.2),
              child: RaisedButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Okay',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                color: Theme.of(context).errorColor,
                textColor: Theme.of(context).primaryTextTheme.button!.color,
              ),
            ),
          ],
        ),
      );
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
