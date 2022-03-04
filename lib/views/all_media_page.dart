import 'package:flutter/material.dart';

class AllMediaPage extends StatelessWidget {
  const AllMediaPage({Key? key}) : super(key: key);


  final List<String> files=const [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('All Media'),
        ),
        body: files.isEmpty?Center(
          child: Container(
            child: Column(
              children: const [
                Icon(Icons.folder),
                Text('No Media')
              ],
            ),
          ),
        ):GridView.count(crossAxisCount: 3,
        children: [

        ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},

          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
