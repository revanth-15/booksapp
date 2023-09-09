import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ExpensesPage extends StatefulWidget {
  @override
  _ExpensesPageState createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State {
  final TextEditingController searchController = TextEditingController();
  List expensesList = [];
  List filteredExpensesList = [];

  @override void initState() { super.initState(); // Retrieve the stored API response
   SharedPreferences.getInstance().then((prefs) { final String? apiResponseString = prefs.getString('apiResponse'); if (apiResponseString != null) { final Map apiResponse = jsonDecode(apiResponseString); // Extract the expenses list
   expensesList = apiResponse['data']['expenseList']; // Initialize the filtered list with the complete list
  filteredExpensesList = expensesList; } else { // Handle the case where the value is null // You can show an error message or navigate back to the login page
      } }); }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Expenses List')),
      body: Column(
        children: [
          TextField(
            controller: searchController,
            onChanged: (query) {
              // Update the filtered list based on the search query
              setState(() {
                filteredExpensesList = expensesList.where((expense) {
                  final companyName = expense['companyName'].toLowerCase();
                  final queryLower = query.toLowerCase();
                  return companyName.contains(queryLower);
                }).toList();
              });
            },
            decoration: InputDecoration(labelText: 'Search by Company Name'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredExpensesList.length,
              itemBuilder: (context, index) {
                final expense = filteredExpensesList[index];
                return ListTile(
                  title: Text(expense['companyName']),
                  subtitle: Text(expense['expenseName']),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
