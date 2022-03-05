import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'media_container.dart';
import 'package:provider/provider.dart';
import 'package:melt/media_service.dart';

class AllMediaPage extends StatelessWidget {
  AllMediaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => MediaService(),
          ),
          ChangeNotifierProvider(
            create: (_) => Counter(),
          ),
        ],
        child: UsableArea(),
      ),
    );
  }
}

class UsableArea extends StatelessWidget {
  UsableArea({Key? key}) : super(key: key);

  final List<String> files = const ['sge'];
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    print('building entire scaffold');
    return Scaffold(
      appBar: const MyAppBar(),
      body: const MyBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Pick an image
          final XFile? image =
              await _picker.pickImage(source: ImageSource.gallery);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  const MyAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final MediaService mediaService = Provider.of<MediaService>(context);
    final Counter myCounter = Provider.of<Counter>(context);
    return AppBar(
      leading: Visibility(
        child: Checkbox(
          fillColor: MaterialStateProperty.resolveWith(getColor),
          shape: const CircleBorder(),
          value: myCounter.value == mediaService.allMedia.length,
          onChanged: (bool? value) {
            bool newValue=value ?? false;
            mediaService.toggleSelections = newValue;
            myCounter.setCounter=newValue?mediaService.allMedia.length:0;
          },
        ),
        visible: mediaService.showCheckBoxes,
      ),
      title: _buildTitle(context, mediaService, myCounter),
    );
  }

  Widget _buildTitle(
      BuildContext context, MediaService mediaService, Counter counter) {
    if (mediaService.showCheckBoxes) {
      if (counter.value > 0) {
        return Text('${mediaService.selectCount} selected');
      } else {
        return const Text('Select items');
      }
    } else {
      return const Text('All Media');
    }
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.black;
  }
}

class MyBody extends StatelessWidget {
  const MyBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaService mediaService = Provider.of<MediaService>(context);
    return mediaService.allMedia.isEmpty
        ? Center(
            child: Container(
              child: Column(
                children: const [Icon(Icons.folder), Text('No Media')],
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                // childAspectRatio: 3 / 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                Media e = mediaService.allMedia[index];
                return ChangeNotifierProvider.value(
                  value: e,
                  child: MediaContainer(
                    mediaPath: e.thumbPath,
                    mediaDuration: e.duration,
                    showCheckBoxes: mediaService.showCheckBoxes,
                    selected: e.selected,
                  ),
                );
              },
              itemCount: mediaService.allMedia.length,
            ),
          );
  }
}
