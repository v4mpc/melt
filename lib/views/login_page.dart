import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:melt/views/num_pad.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../storage_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

// TODO : disable auto backups => https://pub.dev/packages/flutter_secure_storage
class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  String _pin = '';
  bool hasError = false;
  bool disableInputs = false;

  final StorageService _storage = StorageService();

  late AnimationController _animationController;

  @override
  void initState() {
    print('adding pin');
    _storage.addItem('pin', '1234');
    print('added pin');
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
      _animationController.stop();
    }
  }

  void resetPin() {
    setState(() {
      _pin = '';
    });
    _animationController.reset();
  }

  void setPin(String pin) async {
    setState(() {
      if (_pin.length < 4) {
        _pin += pin;
        hasError = false;
      }
    });

    if (_pin.length == 4) {
      print('authenticating...');
      _animationController.repeat();
      disableInputs = true;
      final bool shouldLogin = await _storage.authenticated(_pin);
      if (shouldLogin) {
        print('Your authenticated');
      } else {
        print('Not authenticated');
        setState(() {
          _pin = '';
          hasError = true;
        });
        disableInputs = false;
        _animationController.stop();
      }
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
                flex: 1,
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
                  hasError: hasError,
                ),
              ),
              if (hasError)
                Expanded(
                  flex: 1,
                  child: Text(
                    'Incorrect PIN entered',
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Theme.of(context).errorColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              Expanded(
                flex: 7,
                child: NumPad(
                  deleteFn: deletePin,
                  setPinFn: setPin,
                  disableInputs: disableInputs,
                ),
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
  final bool hasError;

  const InputDisplay({Key? key, this.pin = '', this.hasError = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildContainer(context, pin.isNotEmpty ? true : false),
        _buildContainer(context, pin.length >= 2 ? true : false),
        _buildContainer(context, pin.length >= 3 ? true : false),
        _buildContainer(context, pin.length >= 4 ? true : false)
      ],
    );
  }

  //TODO : add HapticFeedback.heavyImpact();

  Color _buildBorderColor(BuildContext context, bool displayInput) {
    if (displayInput) {
      return Theme.of(context).primaryColor;
    } else {
      if (hasError) {
        return Theme.of(context).errorColor;
      } else {
        return Colors.grey;
      }
    }
  }

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
        border: Border.all(
          width: 3.0,
          color: _buildBorderColor(context, displayInput),
        ),
      ),
      child: Text(
        displayInput ? '*' : '',
        style: const TextStyle(
            color: Colors.black, fontSize: 60, fontWeight: FontWeight.bold),
      ),
    );
  }
}
