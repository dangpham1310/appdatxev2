import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './driver/inputname.dart';
import './customer/register_customer.dart';

class Driver_Customer extends StatelessWidget {
  const Driver_Customer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      // Wrap your Stack with Material widget
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
                0.70, // 15% from the top of the screen
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      // Handle logic for Người Lái Xe button
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => DriverInput()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Color(0xFF40B59F), // Text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Round border
                      ),
                      elevation: 5, // Add shadow
                    ),
                    child: Text(
                      'Người Lái Xe',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 25), // Add spacing between buttons
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomerInput()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Color(0xFF40B59F), // Text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Round border
                      ),
                      elevation: 5, // Add shadow
                    ),
                    child: Text(
                      'Hành Khách',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height *
                0.08, // 15% from the top of the screen
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
                      'assets/images/choose.png', // Provide the path to your image asset
                      width: 150, // Adjust the width of the image as needed
                      height: 150, // Adjust the height of the image as needed
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.67,
            left: 0,
            right: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 55, vertical: 5.0),
            ),
          ),
        ],
      ),
    );
  }
}
