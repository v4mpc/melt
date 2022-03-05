import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:melt/media_service.dart';

class MediaContainer extends StatelessWidget {
  final String mediaPath;
  final String mediaDuration;
  final double borderRadius;
  final bool showCheckBoxes;
  final bool selected;

  const MediaContainer({
    Key? key,
    this.selected = false,
    this.showCheckBoxes = false,
    required this.mediaPath,
    this.mediaDuration = '3',
    this.borderRadius = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Media media = Provider.of<Media>(context);
    Counter counter=Provider.of<Counter>(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.withOpacity(0.5),
              ),
              borderRadius: BorderRadius.circular(borderRadius),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(mediaPath),
              )),
        ),
        if (media.duration.isNotEmpty)
          Positioned(
            child: _buildVideoIndicator(context, media),
            bottom: 5,
            left: 5,
          ),
        if (showCheckBoxes) _buildSelectionOverlay(context, media,counter),
      ],
    );
  }

  Widget _buildVideoIndicator(BuildContext context, Media media) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey.withOpacity(0.5),
      ),
      // width: 60,
      child: Padding(
        padding: const EdgeInsets.only(left: 1.6, right: 1.6),
        child: Row(
          children: [
            const Icon(
              Icons.play_circle_filled_outlined,
              color: Colors.black,
              size: 20,
            ),
            Text(
              media.duration,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionOverlay(BuildContext context, Media media,Counter counter) {
    return Stack(
      // fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        Positioned(
          left: -10,
          top: -10,
          child: Checkbox(
            activeColor: Theme.of(context).primaryColor,
            shape: const CircleBorder(),
            value: media.selected,
            onChanged: (bool? value) {
              bool newValue=value ?? false;
              media.toggleSelect = newValue;
              counter.changeCounter=newValue?1:-1;


            },
          ),
        ),
      ],
    );
  }
}
