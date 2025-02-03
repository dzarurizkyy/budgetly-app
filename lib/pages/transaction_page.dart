import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  bool isExpense = true;
  List<String> list = ["Choose Category", "Food", "Transportation", "Coffee"];
  late String dropDownValue = list.first;
  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AppBar(
            backgroundColor: Colors.blueGrey,
            iconTheme: IconThemeData(color: Colors.white),
            title: Text(
              "Add Transactions",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Theme(
                data: ThemeData(useMaterial3: true).copyWith(
                    colorScheme: Theme.of(context)
                        .colorScheme
                        .copyWith(outline: Colors.transparent)),
                child: Padding(
                  padding:
                      EdgeInsets.only(top: 30, bottom: 0, left: 14, right: 14),
                  child: Row(
                    children: [
                      Transform.scale(
                        scale: 0.8,
                        child: Switch(
                          value: isExpense,
                          onChanged: (bool value) {
                            setState(() {
                              isExpense = value;
                            });
                          },
                          inactiveTrackColor: Colors.green[200],
                          inactiveThumbColor: Colors.green,
                          activeColor: Colors.red,
                        ),
                      ),
                      Text(
                        isExpense ? "Expense" : "Income",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.blueGrey[500]),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: "Amount",
                      labelStyle: TextStyle(color: Colors.grey)),
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                  child: InputDecorator(
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black54))),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      child: DropdownButton<String>(
                        value: dropDownValue,
                        isExpanded: true,
                        underline: Container(),
                        items:
                            list.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: value == "Choose Category"
                                      ? Colors.grey
                                      : Colors.black),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            if (value != "Choose Category") {
                              dropDownValue = value!;
                            }
                          });
                        },
                      ),
                    ),
                  )),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 26),
                child: TextField(
                  readOnly: true,
                  controller: dateController,
                  decoration: InputDecoration(
                      labelText: "Enter Date",
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      )),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2099));

                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      dateController.text = formattedDate;
                    }
                  },
                ),
              ),
              SizedBox(
                height: 26,
              ),
              Center(
                  child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 14),
                        child: Text(
                          "Save",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                      )))
            ],
          )),
        ));
  }
}
