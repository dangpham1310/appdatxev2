import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './driver/inputname.dart';
import './customer/register_customer.dart';



class Driver_Customer extends StatelessWidget {
  const Driver_Customer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          // Background container
          Container(
            color: Colors.white,
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 1,
          ),
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Rectangle 1217.png'),
                fit: BoxFit.fill,
              ),
            ),
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 1.65,
          ),
          // Back button
          Positioned(
            top: 40, // Adjust for safe area
            left: 20, // Add padding from left
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context); // Navigate back
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5), // Semi-transparent black
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
          // Buttons
          Positioned(
            top: MediaQuery.of(context).size.height * 0.70,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => DriverInput()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFF40B59F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      'Người Lái Xe',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomerInput()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFF40B59F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
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
          // Image at the top
          Positioned(
            top: MediaQuery.of(context).size.height * 0.08,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 110,
                  ),
                  Transform.scale(
                    scale: 2.0,
                    child: Image.asset(
                      'assets/images/choose.png',
                      width: 150,
                      height: 150,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
