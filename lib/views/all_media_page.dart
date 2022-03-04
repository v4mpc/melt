import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'media_container.dart';

class AllMediaPage extends StatelessWidget {
  AllMediaPage({Key? key}) : super(key: key);

  final List<String> files = const ['sge'];
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('All Media'),
        ),
        body: files.isEmpty
            ? Center(
                child: Container(
                  child: Column(
                    children: const [Icon(Icons.folder), Text('No Media')],
                  ),
                ),
              )
            : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: [
                    MediaContainer(
                      imagePath: 'assets/vampc.jpeg',
                    ),
                    MediaContainer(imagePath: 'assets/yona.jpg'),
                    MediaContainer(
                      imagePath: 'assets/v4mpc.jpeg',
                    ),
                    MediaContainer(imagePath: 'assets/yona-thumb.jpg'),
                    MediaContainer(
                      imagePath: 'assets/v4mpc1.jpeg',
                    ),
                  ],
                ),
            ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // Pick an image
            final XFile? image =
                await _picker.pickImage(source: ImageSource.gallery);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
