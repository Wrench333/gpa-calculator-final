import 'package:flutter/material.dart';
import 'shared.dart';

Drawer buildDrawer(BuildContext context) {
  Size size = MediaQuery.of(context).size;
  return Drawer(
    width: 3 * (size.width / 4),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(0.0)),
    ),
    elevation: 55.0,
    shadowColor: Colors.cyan[50],
    backgroundColor: Colors.cyan[50],
    surfaceTintColor: Colors.cyan[50],
    child: Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /*SizedBox(
            child: Divider(color: Colors.cyan[50]),
          ),*/
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Account Details',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 30.0,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            child: Divider(color: Colors.cyan[50]),
          ),
          drawerItem(context, 'GPA Calculator',
                  () => Navigator.pushNamed(context, '/home')),
          SizedBox(
            child: Divider(color: Colors.cyan[100]),
          ),
          drawerItem(
              context,
              'How is your GPA calculated ?',
                  () => {
                Navigator.pop(context),
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Feature coming soon"),
                  ),
                ),
              }),
          SizedBox(
            child: Divider(color: Colors.cyan[100]),
          ),
          drawerItem(
              context,
              'Study Tips to Boost your GPA !',
                  () => {
                Navigator.pop(context),
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Feature coming soon"),
                  ),
                ),
              }),
          SizedBox(
            child: Divider(color: Colors.cyan[100]),
          ),
          drawerItem(context, 'About the App',
                  () => Navigator.pushNamed(context, '/about')),
          SizedBox(
            child: Divider(color: Colors.cyan[100]),
          ),
          SizedBox(height: size.width / 2),
          SizedBox(
            child: Divider(color: Colors.cyan[100]),
          ),
          drawerItem(context, 'Settings',
                  () => Navigator.pushNamed(context, '/settings')),
          SizedBox(
            child: Divider(color: Colors.cyan[100]),
          ),
          drawerItem(context, 'Logout', () {
            Shared.saveLoginSharedPreference(false);
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/login',
                  (Route<dynamic> route) => false,
            );
          }),
          SizedBox(
            child: Divider(color: Colors.cyan[100]),
          ),
        ],
      ),
    ),
  );
}

GestureDetector drawerItem(
    BuildContext context, String title, VoidCallback onTap) {
  Size size = MediaQuery.of(context).size;
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.only(left: 20.0),
      width: size.width,
      child: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: 23.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}
