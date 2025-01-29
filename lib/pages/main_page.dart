import 'package:calendar_appbar/calendar_appbar.dart';
import 'package:expenses_tracker_app/pages/home_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
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
      ),
      body: HomePage(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blueGrey,
        shape: CircleBorder(),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(onPressed: () {}, icon: Icon(Icons.home)),
          SizedBox(
            width: 20,
          ),
          IconButton(onPressed: () {}, icon: Icon(Icons.list))
        ],
      )),
    );
  }
}
