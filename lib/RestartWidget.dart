import 'package:flutter/material.dart';

class RestartWidget extends StatefulWidget {
  final Widget child;

  RestartWidget({required this.child});

  static restartApp(BuildContext context) {
    final _RestartWidgetState? state =
    context.findAncestorStateOfType<_RestartWidgetState>();
    state?.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key =  UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
      key: key,
      child: widget.child,
    );
  }
}