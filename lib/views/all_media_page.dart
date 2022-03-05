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

class UsableArea extends StatefulWidget {
  const UsableArea({Key? key}) : super(key: key);

  @override
  State<UsableArea> createState() => _UsableAreaState();
}

class _UsableAreaState extends State<UsableArea>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 400),
    vsync: this,
  );


  late final Animation<Offset> _floatingActionButtonOffsetAnimation =
      Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0.0, 2.5),
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.200, curve: Curves.linear),
    ),
  );

  late final Animation<Offset> _bottomAppBarOffsetAnimation = Tween<Offset>(
    begin:const Offset(0.0, 1.5),
    end: Offset.zero ,
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.310, 0.400, curve: Curves.linear),
    ),
  );

  @override
  void dispose() {
    _controller.dispose();
    // _bottomAppBarAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MediaService mediaService = Provider.of<MediaService>(context);
    final Counter counter = Provider.of<Counter>(context);

    if (mediaService.showCheckBoxes) {
      _controller.forward();
    } else {
      _controller.reverse();
    }

    return WillPopScope(
      onWillPop: () async {
        if (mediaService.showCheckBoxes) {
          mediaService.toggleShowCheckBoxes = false;
          counter.setCounter = 0;
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: const MyAppBar(),
        body: const MyBody(),
        floatingActionButton: AnimatedFloatingActionButton(
          offsetAnimation: _floatingActionButtonOffsetAnimation,
        ),
        bottomNavigationBar: AnimatedBottomAppBar(
          offsetAnimation: _bottomAppBarOffsetAnimation,
        ),
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
            bool newValue = value ?? false;
            mediaService.toggleSelections = newValue;
            myCounter.setCounter = newValue ? mediaService.allMedia.length : 0;
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

class AnimatedFloatingActionButton extends StatelessWidget {
  // todo: listen for only showcheckboxes

  final Animation<Offset> offsetAnimation;

  const AnimatedFloatingActionButton({Key? key, required this.offsetAnimation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: offsetAnimation,
      child: FloatingActionButton(
        onPressed: () async {},
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AnimatedBottomAppBar extends StatelessWidget {
  final Animation<Offset> offsetAnimation;

  const AnimatedBottomAppBar({Key? key, required this.offsetAnimation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: offsetAnimation,
      child: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {},
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const <Widget>[
                  Icon(Icons.delete),
                  Text('Delete'),
                ],
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const <Widget>[
                  Icon(Icons.restore),
                  Text('Restore'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
