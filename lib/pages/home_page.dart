import 'package:budgetly/pages/transaction_page.dart';
import 'package:flutter/material.dart';
import 'package:budgetly/models/database.dart';

class HomePage extends StatefulWidget {
  final DateTime selectedDate;
  const HomePage({super.key, required this.selectedDate});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AppDatabase database = AppDatabase();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate([
            // Income and Expense
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 20),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                decoration: BoxDecoration(
                    color: Colors.blueGrey[400],
                    borderRadius: BorderRadius.circular(16)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Icon(
                            Icons.download,
                            color: Colors.blueGrey,
                          ),
                        ),
                        SizedBox(width: 15),
                        FutureBuilder<double>(
                            future: database.getTotalTransactionByDateRepo(
                                widget.selectedDate, 1),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else {
                                if (snapshot.hasError) {
                                  return Center(
                                    child: Text("0"),
                                  );
                                }
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Income",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "Rp${snapshot.data!.toStringAsFixed(0)}",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 13),
                                    )
                                  ],
                                );
                              }
                            }),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Icon(
                            Icons.upload,
                            color: Colors.blueGrey,
                          ),
                        ),
                        SizedBox(width: 15),
                        FutureBuilder<double>(
                            future: database.getTotalTransactionByDateRepo(
                                widget.selectedDate, 2),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else {
                                if (snapshot.hasError) {
                                  return Center(
                                    child: Text("0"),
                                  );
                                }
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Expense",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "Rp${snapshot.data!.toStringAsFixed(0)}",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 13),
                                    )
                                  ],
                                );
                              }
                            }),
                      ],
                    )
                  ],
                ),
              ),
            ),
            // Transactions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "Transactions",
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: Colors.blueGrey),
              ),
            ),
            SizedBox(
              height: 10,
            )
          ]),
        ),
        StreamBuilder(
            stream: database.getTransactionByDateRepo(widget.selectedDate),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                if (snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, top: 4, bottom: 0),
                            child: Card(
                              color: Colors.white70,
                              elevation: 1,
                              child: ListTile(
                                leading: Container(
                                  padding: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                      color: Colors.blueGrey[400],
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Icon(
                                    snapshot.data![index].category.type == 2
                                        ? Icons.upload
                                        : Icons.download,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(
                                  "Rp${snapshot.data![index].transaction.amount}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.blueGrey,
                                      fontSize: 16),
                                ),
                                subtitle: Text(
                                  "${snapshot.data![index].category.name} (${snapshot.data![index].transaction.name})",
                                  style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        icon: Icon(Icons.delete),
                                        color: Colors.blueGrey[400],
                                        onPressed: () {
                                          database.deleteTransactionRepo(
                                              snapshot
                                                  .data![index].transaction.id);
                                          setState(() {});
                                        }),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      color: Colors.blueGrey[400],
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TransactionPage(
                                                      transactionWithCategory:
                                                          snapshot.data![index],
                                                    )));
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: snapshot.data!.length,
                      ),
                    );
                  } else {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Text("No data available"),
                      ),
                    );
                  }
                } else {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Text("No data available"),
                    ),
                  );
                }
              }
            }),
      ],
    );
  }
}
