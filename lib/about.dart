import 'package:flutter/material.dart';
import 'drawer.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        elevation: 0.0,
        backgroundColor: Colors.cyan[50],
        leading: Icon(
          Icons.calculate_outlined,
          color: Colors.black,
        ),
        title: Text(
          'About the App',
          style: TextStyle(
            color: Colors.black,
            fontSize: 23.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            splashRadius: 25.0,
            icon: Icon(
              Icons.menu_rounded,
              color: Colors.black,
              size: 30.0,
            ),
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
          ),
        ],
      ),
      endDrawer: SafeArea(child: buildDrawer(context)),
      endDrawerEnableOpenDragGesture: true,
      drawerEdgeDragWidth: size.width / 2,
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          width: size.width,
          color: Colors.cyan[50],
          margin: EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 5.0, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to GPA Calculator, the go-to platform for students seeking a seamless and efficient way to calculate their Grade Point Average (GPA). Our user-friendly app is designed to simplify the complex task of GPA calculation, helping you stay on top of your academic performance effortlessly. The UI/UX of this app is inspired/cloned from "gpacalculator.io".',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),
                ),
                SizedBox(height: size.height / 12),
                Text(
                  'Why GPA Calculator ?',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                Text(
                  'At GPA Calculator, we believe that understanding and managing your academic performance should be straightforward. Our app empowers students by putting the tools for GPA calculation and analysis directly at their fingertips. Whether you\'re striving for academic excellence or just need a quick GPA check, GPA Calculator is here to support your educational journey.',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),
                ),
                SizedBox(height: size.height / 12),
                Text(
                  'Your academic success starts with GPA Calculator!',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
