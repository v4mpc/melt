import 'package:flutter/foundation.dart';

class MediaService with ChangeNotifier {
  int selectedCount = 0;
  bool _showCheckBox = false;

  //todo: optimize that changes in single media only rebuilds that media instead of whole list
  List<Media> _media = [
    Media(
        selected: false,
        path: '',
        restorePath: '',
        thumbPath: 'assets/vampc.jpeg'),
    Media(path: '', restorePath: '', thumbPath: 'assets/yona.jpg'),
    Media(path: '', restorePath: '', thumbPath: 'assets/v4mpc.jpeg'),
    Media(path: '', restorePath: '', thumbPath: 'assets/yona-thumb.jpg'),
    Media(path: '', restorePath: '', thumbPath: 'assets/v4mpc1.jpeg'),
  ];

  int get selectCount => _media.where((Media media) => media.selected).length;

  List<Media> get allMedia => _media;

  bool get showCheckBoxes => _showCheckBox;

  set toggleShowCheckBoxes(bool value ){
    _showCheckBox=value;
    if(value==false){
      for (Media m in _media) {
        m.selected = false;
      }
    }
    notifyListeners();
  }

  set toggleSelections(bool status) {
    for (Media m in _media) {
      m.selected = status;
    }
    notifyListeners();
  }

  set updateMedia(Media media){
    int index=_media.indexOf(media);
    _media[index]=media;
  }
}

class Counter with ChangeNotifier{
  int value;
  Counter({this.value=0});

  set changeCounter(int newValue){
    value+=newValue;
    notifyListeners();
  }

  set setCounter(int newValue){
    value=newValue;
    notifyListeners();
  }
}

class Media with ChangeNotifier {
  String thumbPath;
  String path;
  String restorePath;
  bool selected;
  String duration;

  Media({
    required this.thumbPath,
    this.duration = '',
    this.selected = false,
    required this.path,
    required this.restorePath,
  });

  set toggleSelect(bool status) {
    selected = status;
    notifyListeners();
  }
}
