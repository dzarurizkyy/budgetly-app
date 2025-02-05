import 'package:flutter/material.dart';
import 'package:expenses_tracker_app/models/database.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool isExpense = true;
  int type = 2;
  final AppDatabase database = AppDatabase();
  TextEditingController categoryNameController = TextEditingController();

  Future insert(String name, int type) async {
    DateTime now = DateTime.now();
    await database.into(database.categories).insertReturning(
        CategoriesCompanion.insert(
            name: name, type: type, createdAt: now, updatedAt: now));
  }

  Future update(int categoryId, String newName) async {
    return await database.updateCategoryRepo(categoryId, newName);
  }

  Future<List<Category>> getAllCategory(int type) async {
    return await database.getAllCategoryRepo(type);
  }

  void openDialog(Category? category) {
    if (category != null) {
      categoryNameController.text = category.name;
    }

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
                      "${category == null ? "Add" : "Edit"} ${isExpense == true ? "Expense" : "Income"}",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.blueGrey),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                        controller: categoryNameController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), hintText: "Name")),
                    SizedBox(height: 15),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey),
                        onPressed: () {
                          if (category == null) {
                            insert(
                                categoryNameController.text, isExpense ? 2 : 1);
                          } else {
                            update(category.id, categoryNameController.text);
                          }
                          Navigator.of(context, rootNavigator: true)
                              .pop("dialog");
                          setState(() {});
                          categoryNameController.clear();
                        },
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
                        type = value ? 2 : 1;
                      });
                    },
                    inactiveTrackColor: Colors.green[200],
                    inactiveThumbColor: Colors.green,
                    activeColor: Colors.red,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      openDialog(null);
                    },
                    icon: Icon(Icons.add))
              ],
            ),
          ),
        ),
        FutureBuilder<List<Category>>(
          future: getAllCategory(type),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.hasData) {
                if (snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child: Card(
                            elevation: 0.3,
                            child: Padding(
                              padding: const EdgeInsets.all(0),
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
                                title: Text(snapshot.data![index].name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.blueGrey,
                                        fontSize: 15)),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.blueGrey,
                                      ),
                                      onPressed: () {
                                        database.deleteCategoryRepo(
                                            snapshot.data![index].id);
                                        setState(() {});
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.blueGrey,
                                      ),
                                      onPressed: () {
                                        openDialog(snapshot.data![index]);
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                } else {
                  return Center(child: Text("No has data"));
                }
              } else {
                return Center(child: Text("No has data"));
              }
            }
          },
        ),
      ],
    ));
  }
}
