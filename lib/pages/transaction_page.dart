import 'package:budgetly/models/transaction_with_category.dart';
import 'package:budgetly/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:budgetly/models/database.dart';

class TransactionPage extends StatefulWidget {
  final TransactionWithCategory? transactionWithCategory;
  const TransactionPage({super.key, required this.transactionWithCategory});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final AppDatabase database = AppDatabase();
  bool isExpense = true;
  late int type;

  TextEditingController dateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  String? selectedCategory;
  String defaultCategory = "";

  Future insert(
      int amount, DateTime date, String nameDetail, int categoryId) async {
    DateTime now = DateTime.now();
    await database.into(database.transactions).insertReturning(
        TransactionsCompanion.insert(
            name: nameDetail,
            categoryId: categoryId,
            amount: amount,
            transactionDate: now,
            createdAt: now,
            updatedAt: now));
  }

  Future<List<Category>> getAllCategory(int type) async {
    return await database.getAllCategoryRepo(type);
  }

  @override
  void initState() {
    if (widget.transactionWithCategory != null) {
      updateTransactionView(widget.transactionWithCategory);
    } else {
      type = 2;
    }
    super.initState();
  }

  void updateTransactionView(TransactionWithCategory? transactionWithCategory) {
    if (transactionWithCategory == null) return;
    amountController.text =
        transactionWithCategory.transaction.amount.toString();
    dateController.text = DateFormat("yyyy-MM-dd")
        .format(transactionWithCategory.transaction.transactionDate);
    detailController.text = transactionWithCategory.transaction.name.toString();
    type = transactionWithCategory.category.type;
    (type == 2) ? isExpense = true : isExpense = false;
    selectedCategory =
        transactionWithCategory.transaction.categoryId.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AppBar(
            backgroundColor: Colors.blueGrey,
            iconTheme: IconThemeData(color: Colors.white),
            title: Text(
              "${widget.transactionWithCategory == null ? 'Add' : 'Edit'} Transactions",
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
                              type = (isExpense) ? 2 : 1;
                              selectedCategory = null;
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
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: "Amount",
                      labelStyle: TextStyle(color: Colors.grey)),
                ),
              ),
              FutureBuilder<List<Category>>(
                  future: getAllCategory((type)),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      if (snapshot.hasData) {
                        if (snapshot.data!.isNotEmpty) {
                          defaultCategory = snapshot.data!.first.id.toString();
                          return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 0),
                              child: InputDecorator(
                                decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black54))),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 0),
                                  child: DropdownButton<String>(
                                    value: selectedCategory ??
                                        snapshot.data!.first.id.toString(),
                                    isExpanded: true,
                                    underline: Container(),
                                    items: snapshot.data!
                                        .map<DropdownMenuItem<String>>(
                                            (Category item) {
                                      return DropdownMenuItem<String>(
                                        value: item.id.toString(),
                                        child: Text(
                                          item.name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      setState(() {
                                        selectedCategory = value;
                                      });
                                    },
                                  ),
                                ),
                              ));
                        } else {
                          return Center(child: Text("No has data"));
                        }
                      }
                      return Center(child: Text("No has data"));
                    }
                  }),
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                child: TextFormField(
                    controller: detailController,
                    decoration: InputDecoration(
                        labelText: "Enter Detail",
                        labelStyle: TextStyle(color: Colors.grey)),
                    onTap: () {}),
              ),
              SizedBox(
                height: 26,
              ),
              Center(
                  child: ElevatedButton(
                      onPressed: () {
                        widget.transactionWithCategory == null
                            ? insert(
                                int.parse(amountController.text),
                                DateTime.parse(dateController.text),
                                detailController.text,
                                int.parse(selectedCategory ?? defaultCategory))
                            : database.updateTransaction(
                                widget.transactionWithCategory!.transaction.id,
                                int.parse(amountController.text),
                                int.parse(selectedCategory ?? defaultCategory),
                                DateTime.parse(dateController.text),
                                detailController.text);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MainPage()));
                      },
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
