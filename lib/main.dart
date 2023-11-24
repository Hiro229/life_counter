import 'package:flutter/material.dart';
import 'package:life_counter/add_life_event.dart';
import 'package:life_counter/life_event.dart';
import 'package:life_counter/objectbox.g.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LifeCounterPage(),
    );
  }
}

class LifeCounterPage extends StatefulWidget {
  const LifeCounterPage({super.key});

  @override
  State<LifeCounterPage> createState() => _LifeCounterPageState();
}

class _LifeCounterPageState extends State<LifeCounterPage> {
  // ObjectBox から値を取り出すために必要
  Store? store;
  Box<LifeEvent>? lifeEventBox;
  List<LifeEvent> lifeEventList = [];

  Future<void> initialize() async {
    // initState() ではasync/awaitは使用できないためメソッドを作成
    store = await openStore();
    lifeEventBox = store?.box<LifeEvent>();
    fetchLifeEvents();
  }

  void fetchLifeEvents() {
    lifeEventList = lifeEventBox?.getAll() ?? [];
    // 非同期処理が完了した後にUIを更新
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // initStateからasyncキーワードを削除し、initializeメソッドを直接呼び出す
    initialize(); // initializeはasyncだが、ここでは結果を待たない
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('人生カウンター'),
      ),
      body: ListView.builder(
        itemCount: lifeEventList.length,
        itemBuilder: (context, index) {
          final LifeEvent lifeEvent = lifeEventList[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  lifeEvent.title,
                  style: TextStyle(fontSize: 16),
                )),
                Text(
                  '${lifeEvent.count}',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 20),
                IconButton(
                  onPressed: () {
                    lifeEvent.count++;
                    // 変更した値は一度オブジェクトボックスに入れて再度取得する
                    lifeEventBox?.put(lifeEvent);
                    fetchLifeEvents();
                  },
                  icon: const Icon(Icons.plus_one),
                ),
                IconButton(
                  onPressed: () {
                    if (lifeEvent.count > 0) {
                      lifeEvent.count--;
                      lifeEventBox?.put(lifeEvent);
                      fetchLifeEvents();
                    }
                  },
                  icon: const Icon(Icons.exposure_minus_1),
                ),
                IconButton(
                  onPressed: () {
                    lifeEventBox?.remove(lifeEvent.id);
                    fetchLifeEvents();
                  },
                  icon: const Icon(Icons.delete),
                )
              ],
            ),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'add',
            child: const Icon(Icons.add),
            onPressed: () async {
              // Navigator.of(context).push(MaterialPageRoute(
              final LifeEvent newLifeEvent =
                  await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return const AddLifeEventPage();
                },
              ));
              // if (newLifeEvent != null) {
              lifeEventBox?.put(newLifeEvent);
              fetchLifeEvents();
              // }
            },
          ),
          const SizedBox(height: 20),
          FloatingActionButton(
            child: const Icon(Icons.delete),
            onPressed: () {
              lifeEventBox?.removeAll();
              fetchLifeEvents();
            },
          ),
        ],
      ),
    );
  }
}
