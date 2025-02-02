import 'package:flutter/material.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool isExpense = true;
  void openDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              content: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Center(
                      child: Column(children: [
                    Text(
                      "Add Category",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.blueGrey),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), hintText: "Name")),
                    SizedBox(height: 15),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey),
                        onPressed: () {},
                        child: Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ))
                  ])),
                ),
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        Theme(
          data: ThemeData(useMaterial3: true).copyWith(
              colorScheme: Theme.of(context)
                  .colorScheme
                  .copyWith(outline: Colors.transparent)),
          child: Padding(
            padding: EdgeInsets.only(top: 0, bottom: 4, left: 14, right: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                IconButton(
                    onPressed: () {
                      openDialog();
                    },
                    icon: Icon(Icons.add))
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
          child: Card(
            elevation: 0.3,
            child: Padding(
              padding: const EdgeInsets.all(1),
              child: ListTile(
                leading: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey[400],
                      borderRadius: BorderRadius.circular(20)),
                  child: (isExpense == true)
                      ? Icon(
                          Icons.upload,
                          color: Colors.white,
                        )
                      : Icon(
                          Icons.download,
                          color: Colors.white,
                        ),
                ),
                title: Text("Food",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.blueGrey,
                        fontSize: 15)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.delete,
                      color: Colors.blueGrey[400],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.edit,
                      color: Colors.blueGrey[400],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
          child: Card(
            elevation: 0.3,
            child: Padding(
              padding: const EdgeInsets.all(1),
              child: ListTile(
                leading: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey[400],
                      borderRadius: BorderRadius.circular(20)),
                  child: (isExpense == true)
                      ? Icon(
                          Icons.upload,
                          color: Colors.white,
                        )
                      : Icon(
                          Icons.download,
                          color: Colors.white,
                        ),
                ),
                title: Text("Salary",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.blueGrey,
                        fontSize: 15)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.delete,
                      color: Colors.blueGrey[400],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.edit,
                      color: Colors.blueGrey[400],
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    ));
  }
}
