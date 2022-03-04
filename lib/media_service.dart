import 'package:flutter/foundation.dart';

class MediaService with ChangeNotifier {
  int selectedCount = 0;
  bool _showCheckBox = true;

  //todo: optimize that changes in single media only rebuilds that media instead of whole list
  List<Media> _media = [
    Media(
        selected: true,
        mediaPath: '',
        mediaRestorePath: '',
        mediaThumbPath: 'assets/vampc.jpeg'),
    Media(
        mediaPath: '', mediaRestorePath: '', mediaThumbPath: 'assets/yona.jpg'),
    Media(
        mediaPath: '',
        mediaRestorePath: '',
        mediaThumbPath: 'assets/v4mpc.jpeg'),
    Media(
        mediaPath: '',
        mediaRestorePath: '',
        mediaThumbPath: 'assets/yona-thumb.jpg'),
    Media(
        mediaPath: '',
        mediaRestorePath: '',
        mediaThumbPath: 'assets/v4mpc1.jpeg'),
  ];

  int get selectCount => _media.where((Media media) => media.selected).length;

  List<Media> get allMedia => _media;

  bool get showCheckBoxes => _showCheckBox;

  set toggleSelections(bool status) {
    for (Media m in _media) {
      m.selected = status;
    }
    notifyListeners();
  }
}

class Media {
  String mediaThumbPath;
  String mediaPath;
  String mediaRestorePath;
  bool selected;
  String mediaDuration;

  Media(
      {required this.mediaThumbPath,
      this.mediaDuration = '',
      this.selected = false,
      required this.mediaPath,
      required this.mediaRestorePath});
}
