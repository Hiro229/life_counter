import 'package:flutter/material.dart';
import 'package:life_counter/life_event.dart';

class AddLifeEventPage extends StatefulWidget {
  const AddLifeEventPage({super.key});

  @override
  State<AddLifeEventPage> createState() => _AddLifeEventPageState();
}

class _AddLifeEventPageState extends State<AddLifeEventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ライフイベント追加'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextFormField(
          onFieldSubmitted: (text) {
            final LifeEvent lifeEvent = LifeEvent(title: text, count: 0);
            Navigator.of(context).pop(lifeEvent);
          },
        ),
      ),
    );
  }
}
