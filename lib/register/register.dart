import 'welcome.dart';
import 'package:flutter/cupertino.dart';
import "./phone_screen.dart";

class StartAppWidget extends StatefulWidget {
  @override
  _StartAppWidgetState createState() => _StartAppWidgetState();
}

class _StartAppWidgetState extends State<StartAppWidget> {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      
      home: CupertinoPageScaffold(
        child: Stack(
          children: [
            Welcome(), // Add your Welcome widget as the first item in the stack
          ],
        ),
      ),
    );
  }
}
