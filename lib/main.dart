import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> expenses = [];




  void addExpense() {
    TextEditingController amountController = TextEditingController();
    TextEditingController categoryController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Expenses"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: categoryController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Amount",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${selectedDate.toLocal()}".split(' ')[0]),
                  TextButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );

                      if (pickedDate != null) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                    child: Text("Select Date"),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () {
                if (amountController.text.isEmpty ||
                    categoryController.text.isEmpty) {
                  return;
                }

                setState(() {
                  expenses.add({
                    "amount": amountController.text,
                    "category": categoryController.text,
                    "date": selectedDate,
                  });
                });

                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  double getTotalExpenses() {
    double getTotal = 0;
    for (var expense in expenses){
      getTotal += double.tryParse(expense['amount'] as String) ?? 0 ;
    }
    return getTotal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Expense Tracker App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.amber,
        actions: [IconButton(icon: Icon(Icons.settings), onPressed: () {})],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: addExpense,
        backgroundColor: Colors.amberAccent,
        child: Icon(Icons.add),
      ),

      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            color: Colors.amber,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Total Expense",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 5),
                Text(
                  "₹${getTotalExpenses()}",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: expenses.isEmpty
                ? Center(child: Text("No expenses added so far"))
                : ListView.builder(
                    itemCount: expenses.length,
                    itemBuilder: (context, index) {
                      final expense = expenses[index];
                      return ListTile(
                        leading: Icon(Icons.control_point_duplicate),
                        hoverColor: Colors.lime,
                        title: Text(expense["category"]),
                        subtitle: Text("₹${expense["amount"]}"),
                        trailing: Text("${expense["date"].toLocal()}".split(' ')[0]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
