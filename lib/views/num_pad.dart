import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumPad extends StatelessWidget {
  final Function deleteFn;
  final Function setPinFn;

  const NumPad({Key? key, required this.deleteFn, required this.setPinFn})
      : super(key: key);
  final fontSize = 50.0;
  final List<String> _keys = const [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    'back_space',
    '0',
    'OK'
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _buildKeys(context),
    );
  }

  List<Widget> _buildKeys(BuildContext context) {
    List<Widget> _myWidgetList = [];
    for (int i = 0; i < _keys.length; i = i + 3) {
      _myWidgetList.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _keys[i] == 'back_space'
              ? MyIconButton(
                  iconData: Icons.backspace,
                  deleteFn: deleteFn,
                )
              : NumButton(
                  labelText: _keys[i],
                  setPinFn: setPinFn,
                ),
          NumButton(
            setPinFn: setPinFn,
            labelText: _keys[i + 1],
          ),
          _keys[i + 2] == 'OK'
              ? const MyIconButton(
                  iconData: Icons.done,
                )
              : NumButton(
                  setPinFn: setPinFn,
                  labelText: _keys[i + 2],
                ),
        ],
      ));
      _myWidgetList.add(
        const SizedBox(
          height: 10,
        ),
      );
    }

    return _myWidgetList;
  }
}

class MyIconButton extends StatelessWidget {
  final IconData iconData;
  final Function? deleteFn;

  const MyIconButton({Key? key, required this.iconData, this.deleteFn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        HapticFeedback.heavyImpact();
        deleteFn!();
      },
      icon: Icon(iconData),
    );
  }
}

class NumButton extends StatelessWidget {
  final double fontSize;
  final String labelText;
  final Function setPinFn;

  const NumButton(
      {Key? key,
      this.fontSize = 50,
      required this.labelText,
      required this.setPinFn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        HapticFeedback.heavyImpact();
        setPinFn(labelText);
      },
      child: Text(
        labelText,
        style: Theme.of(context).textTheme.headline5!.copyWith(
              fontSize: fontSize,
            ),
      ),
      style: ButtonStyle(
        shape: MaterialStateProperty.all<CircleBorder>(const CircleBorder()),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
      ),
    );
  }
}
