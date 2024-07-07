import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "./phone_screen.dart";

class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Stack(
          children: [
            Container(
              color: Colors.white, // Set background color to white
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 1,
            ),
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/Rectangle 1217.png'), // Path to the background image
                  fit: BoxFit.fill, // Adjust the fit as needed
                ),
              ),
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 1.65,
            ),
            Positioned(
              top: MediaQuery.of(context).size.height *
                  0.17, // Move the text 17% from the top of the screen
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  "Welcome to",
                  style: TextStyle(
                    fontSize: 35.0, // Increased font size
                    fontWeight: FontWeight.bold,
                    fontFamily: "Quicksand",
                    color: Colors.black38, // Set text color to white
                    shadows: [
                      Shadow(
                        blurRadius: 1.0,
                        color: Colors.black.withOpacity(
                            0.5), // Add shadow for better visibility
                        offset: Offset(0, 2), // Adjust shadow offset
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height *
                  0.15, // 15% from the top of the screen
              left: 0,
              right: 0,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 110,
                    ), // Adjusted the height to accommodate for the moved text
                    Transform.scale(
                      scale: 2.0, // Adjust the scale factor as needed
                      child: Image.asset(
                        'assets/images/ava.png', // Provide the path to your image asset
                        width: 150, // Adjust the width of the image as needed
                        height: 150, // Adjust the height of the image as needed
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height *
                  0.65, // 15% from the top of the screen
              left: 0,
              right: 0,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 110,
                    ), // Adjusted the height to accommodate for the moved text
                    Transform.scale(
                      scale: 1.0, // Adjust the scale factor as needed
                      child: Image.asset(
                        'assets/images/Group 301.png', // Provide the path to your image asset
                        width: 150, // Adjust the width of the image as needed
                        height: 150, // Adjust the height of the image as needed
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.55,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          NextScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        var begin = Offset(0.5, 0.0);
                        var end = Offset.zero;
                        var curve = Curves.easeInOut;
                        var tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));
                        var offsetAnimation = animation.drive(tween);
                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 110,
                    ),
                    Transform.scale(
                      scale: 2.0,
                      child: Image.asset(
                        'assets/images/Group 298.png',
                        width: 150,
                        height: 150,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        onWillPop: () async {
          return false;
        });
  }
}
