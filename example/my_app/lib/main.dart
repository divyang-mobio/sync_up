import 'package:flutter/material.dart';
import 'package:my_app/data_model.dart';
import 'package:provider/provider.dart';
import 'package:sync_up/sync_up.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<DatabaseHelper>(
      create: (context) => DatabaseHelper(
          dataBaseName: "shift.db", version: 1, createDataBase: '''
        CREATE TABLE SHIFT(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          data TEXT
        )
          '''),
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: const MyHomePage(title: 'Flutter Package Demo')),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<DataModel> _counter = [];

  Future<void> _incrementCounter() async {
    var data = await Provider.of<DatabaseHelper>(context, listen: false)
        .getData(tableName: "SHIFT");
    _counter = data.map((c) => DataModel.fromJson(c)).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), actions: [
        IconButton(
            onPressed: () {
              Provider.of<DatabaseHelper>(context, listen: false)
                  .deleteAllData(tableName: "SHIFT");
              _incrementCounter();
            },
            icon: const Icon(Icons.delete))
      ]),
      body: ListView.builder(
          itemCount: _counter.length,
          itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  Provider.of<DatabaseHelper>(context, listen: false)
                      .deleteData(
                          tableName: "SHIFT", id: _counter[index].id as int);
                  _incrementCounter();
                },
                onDoubleTap: () {
                  Provider.of<DatabaseHelper>(context, listen: false)
                      .updateData(
                          tableName: "SHIFT",
                          values:
                              DataModel(data: "Parmar", id: _counter[index].id)
                                  .toJson(),
                          id: _counter[index].id as int);
                  _incrementCounter();
                },
                child: ListTile(
                  leading: Text((_counter[index].id).toString()),
                  title: Text(_counter[index].data),
                ),
              )),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Provider.of<DatabaseHelper>(context, listen: false).addData(
                tableName: "SHIFT",
                values: DataModel(data: "Divyang").toJson());
            _incrementCounter();
          },
          child: const Icon(Icons.add)),
    );
  }
}
