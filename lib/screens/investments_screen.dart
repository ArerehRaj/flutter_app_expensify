import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/investments.dart';

class InvestmentsScreen extends StatefulWidget {
  @override
  State<InvestmentsScreen> createState() => _InvestmentsScreenState();
}

class _InvestmentsScreenState extends State<InvestmentsScreen> {
  // global form key for search option
  final GlobalKey<FormState> _formKey = GlobalKey();

  // var string text to hold the value of user search
  var text = '';

  // function to submit the form i.e. user search for a stock
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid
      return;
    }
    _formKey.currentState!.save();

    try {
      // making a method call to search stock labels based on user text input in search
      Provider.of<Investments>(context, listen: false).searchLabel(text);
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final investmentsData = Provider.of<Investments>(context);
    return Column(
      children: [
        const SizedBox(
          height: 18,
        ),
        Form(
          key: _formKey,
          // extracted method for displaying the search card widget
          child: searchCard(),
        ),
        const SizedBox(
          height: 18,
        ),
        // if no searches then show user added stocks else show the search results
        investmentsData.getUrlStocks.isEmpty
            ? const Text('No Searches')
            : Expanded(
                child: ListView.builder(
                  itemCount: investmentsData.getUrlStocks.length,
                  itemBuilder: (ctx, index) {
                    return SearchedStockCard(
                      investmentsData: investmentsData,
                      index: index,
                    );
                  },
                ),
              ),
      ],
    );
  }

  // extracted method for displaying the search card widget
  Card searchCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0),
      ),
      child: Container(
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 2),
        child: TextFormField(
          decoration: const InputDecoration(
            suffixIcon: Icon(
              Icons.search_sharp,
            ),
            hintText: 'Search',
            border: InputBorder.none,
          ),
          keyboardType: TextInputType.text,
          onFieldSubmitted: (value) {
            _submitForm();
          },
          validator: (value) {
            // Checking here if the search is valid or not
            if (value!.isEmpty) {
              return 'Please Enter a valid Text';
            }
            return null;
          },
          onSaved: (value) => text = value!,
        ),
      ),
    );
  }
}

// extracted widget to show the stock cards based on user search
class SearchedStockCard extends StatelessWidget {
  const SearchedStockCard({
    Key? key,
    required this.investmentsData,
    required this.index,
  }) : super(key: key);

  final Investments investmentsData;
  final index;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      child:
          // setting a list tile here
          ListTile(
        // showing the tital
        title: Text(investmentsData.getUrlStocks[index]['symbol']),
        // showing the sub title
        subtitle: Text(investmentsData.getUrlStocks[index]['name']),
      ),
    );
  }
}
