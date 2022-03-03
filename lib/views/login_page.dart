import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:melt/views/num_pad.dart';
import 'package:flutter/services.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  String _pin = '';

  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 5000),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void deletePin() {
    setState(() {
      if (_pin.isNotEmpty) {
        _pin = _pin.substring(0, _pin.length - 1);
      }
    });

    if (_pin.length < 4) {
      print('pin less than 4');
      _animationController.stop();
    }
  }

  void resetPin(){
    setState(() {
      _pin='';
    });
    _animationController.reset();
  }
  void setPin(String pin) {

    setState(() {
      if (_pin.length < 4) {
        _pin += pin;
      }
    });

    if (_pin.length == 4) {
      print('pin is 4');
      _animationController.repeat();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              Expanded(
                flex: 4,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset('assets/melt_background_logo.png'),
                    RotationTransition(
                      turns: Tween(begin: 0.0, end: 1.0)
                          .animate(_animationController),
                      child: Image.asset('assets/melt_foreground_logo.png'),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Enter PIN',
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Expanded(
                flex: 2,
                child: InputDisplay(
                  pin: _pin,
                ),
              ),
              Expanded(
                flex: 7,
                child: NumPad(deleteFn: deletePin, setPinFn: setPin),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InputDisplay extends StatelessWidget {
  final String pin;

  const InputDisplay({Key? key, this.pin = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildContainer(context, pin.isNotEmpty ? true : false),
          _buildContainer(context, pin.length >= 2 ? true : false),
          _buildContainer(context, pin.length >= 3 ? true : false),
          _buildContainer(context, pin.length >= 4 ? true : false)
        ],
      ),
    );
  }

  //TODO : add HapticFeedback.heavyImpact();

  Widget _buildContainer(BuildContext context, bool displayInput) {
    return Container(
      height: 60,
      width: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
        color: Colors.grey,
        border: Border.all(width: 3.0, color: Theme.of(context).primaryColor),
      ),
      child: Text(
        displayInput ? '*' : '',
        style: const TextStyle(
            color: Colors.black, fontSize: 60, fontWeight: FontWeight.bold),
      ),
    );
  }
}
