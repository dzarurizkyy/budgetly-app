import 'package:calendar_appbar/calendar_appbar.dart';
import 'package:budgetly/pages/home_page.dart';
import 'package:budgetly/pages/category_page.dart';
import 'package:budgetly/pages/transaction_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late DateTime selectedDate;
  late int currentIndex;
  late List<Widget> _children;

  @override
  void initState() {
    updateView(0, DateTime.now());
    super.initState();
  }

  void updateView(int index, DateTime? date) {
    setState(() {
      if (date != null) {
        selectedDate = DateTime.parse(DateFormat("yyyy-MM-dd").format(date));
      }

      currentIndex = index;
      _children = [
        HomePage(
          selectedDate: selectedDate,
        ),
        CategoryPage()
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (currentIndex == 0)
          ? PreferredSize(
              preferredSize: Size.fromHeight(220),
              child: Container(
                color: Colors.blueGrey,
                child: Column(
                  children: [
                    CalendarAppBar(
                      accent: Colors.blueGrey,
                      backButton: false,
                      locale: "en",
                      onDateChanged: (value) {
                        setState(() {
                          selectedDate = value;
                          updateView(0, selectedDate);
                        });
                      },
                      firstDate: DateTime.now().subtract(Duration(days: 140)),
                      lastDate: DateTime.now(),
                    ),
                  ],
                ),
              ),
            )
          : PreferredSize(
              preferredSize: Size.fromHeight(120),
              child: Padding(
                  padding:
                      EdgeInsets.only(top: 60, bottom: 20, left: 20, right: 20),
                  child: Text("Categories",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w800))),
            ),
      body: _children[currentIndex],
      floatingActionButton: Visibility(
        visible: (currentIndex == 0) ? true : false,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) => TransactionPage(
                          transactionWithCategory: null,
                        )))
                .then((value) {
              setState(() {});
            });
          },
          backgroundColor: Colors.blueGrey,
          shape: CircleBorder(),
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
              onPressed: () {
                updateView(0, DateTime.now());
              },
              icon: Icon(Icons.home)),
          SizedBox(
            width: 20,
          ),
          IconButton(
              onPressed: () {
                updateView(1, null);
              },
              icon: Icon(Icons.list))
        ],
      )),
    );
  }
}
