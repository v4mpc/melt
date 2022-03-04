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
      child: ChangeNotifierProvider(
        create: (_) => MediaService(),
        child: UsableArea(),
      ),
    );
  }
}

class UsableArea extends StatelessWidget {
  UsableArea({Key? key}) : super(key: key);

  final List<String> files = const ['sge'];
  final ImagePicker _picker = ImagePicker();


  Widget _buildTitle(BuildContext context,MediaService mediaService){
    if(mediaService.showCheckBoxes){
      if(mediaService.selectCount>0){
        return Text('${mediaService.selectCount} selected');
      }else{
        return const Text('Select items');
      }
    }else{
      return const Text('All Media');
    }
  }

  @override
  Widget build(BuildContext context) {
    final MediaService mediaService = Provider.of<MediaService>(context);
    return Scaffold(
      appBar: AppBar(
        leading: Visibility(
          child: Checkbox(
            activeColor: Colors.black,
            shape: const CircleBorder(),
            value: mediaService.selectCount==mediaService.allMedia.length,
            onChanged: (bool? value) {
              mediaService.toggleSelections=value??false;
            },
          ),
          visible: mediaService.showCheckBoxes,
        ),
        title:_buildTitle(context,mediaService),
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
                children: mediaService.allMedia
                    .map(
                      (Media e) => MediaContainer(
                        mediaPath: e.mediaThumbPath,
                        mediaDuration: e.mediaDuration,
                        showCheckBoxes: mediaService.showCheckBoxes,
                        selected: e.selected,
                      ),
                    )
                    .toList(),
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
    );
  }
}
