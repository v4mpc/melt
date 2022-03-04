import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MediaContainer extends StatelessWidget {
  final String imagePath;

  const MediaContainer({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.expand,
        // clipBehavior: Clip.antiAlias,
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.withOpacity(0.5),
                ),
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(imagePath),
                )),
          ),
          Positioned(
            child: _buildVideoIndicator(context, '0:16'),
            bottom: 5,
            left: 5,
          )
        ]);
  }

  Widget _buildVideoIndicator(BuildContext context, String time) {
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
              '24:59',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor),
            )
          ],
        ),
      ),
    );
  }
}
