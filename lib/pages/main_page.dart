import 'package:calendar_appbar/calendar_appbar.dart';
import 'package:expenses_tracker_app/pages/home_page.dart';
import 'package:expenses_tracker_app/pages/category_page.dart';
import 'package:expenses_tracker_app/pages/transaction_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  DateTime selectedDate = DateTime.now();
  final List<Widget> _children = [HomePage(), CategoryPage()];
  int currentIndex = 0;

  void onTapTapped(int index) {
    setState(() {
      currentIndex = index;
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
                      onDateChanged: (value) => (),
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
                .push(
                    MaterialPageRoute(builder: (context) => TransactionPage()))
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
                onTapTapped(0);
              },
              icon: Icon(Icons.home)),
          SizedBox(
            width: 20,
          ),
          IconButton(
              onPressed: () {
                onTapTapped(1);
              },
              icon: Icon(Icons.list))
        ],
      )),
    );
  }
}
