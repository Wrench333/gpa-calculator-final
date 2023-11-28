import 'package:gpa_calculator/theme/theme_manager.dart';
import 'package:gpa_calculator/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'firestore_service.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';
import 'about.dart';
//import 'settings.dart';
import 'login.dart';
import 'sign_up.dart';
import 'models.dart';
import 'drawer.dart';
import 'semester_widget.dart';

ThemeManager _themeManager = ThemeManager();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    print('its working');
  } catch (e) {
    print('Error during Firebase initialization: $e');
  }

  /*SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Set the status bar color to transparent
    statusBarIconBrightness: Brightness.dark, // Set the status bar icons to dark
  ));*/

  await SharedPreferences.getInstance();

  runApp(ChangeNotifierProvider(
    create: (context) => _themeManager,
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeManager.themeMode,
      home: AuthenticationWrapper(),
      routes: {
        '/login': (context) => LoginPage(),
        '/sign_up': (context) => SignUpPage(),
        '/home': (context) => Home(),
        '/about': (context) => About(),
        //'/settings': (context) => Settings(),
      },
    ),
  ));
}

class AuthenticationWrapper extends StatefulWidget {
  @override
  _AuthenticationWrapperState createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  @override
  Widget build(BuildContext context) {
    // Check the user's login state
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Return a loading indicator if the connection is still waiting
          return CircularProgressIndicator();
        } else if (snapshot.hasData) {
          // If the user is logged in, return the Home widget
          return Home();
        } else {
          // If the user is not logged in, return the LoginPage widget
          return LoginPage();
        }
      },
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int semesterCounter = 1;
  List<String> items = [
    'A',
    'A-',
    'B',
    'B-',
    'C',
    'C-',
    'D',
    'D-',
    'E',
    'E-',
    'NC'
  ];
  List<Semester> semesters = [];
  ScrollController _scrollController = ScrollController();
  double cumulativeGPA = 0.0;
  final FirebaseService firebaseService = FirebaseService();
  String userEmail = '';

  @override
  void dispose() {
    _themeManager.removeListener(themeListener);
    super.dispose();
  }

  @override
  void initState() {
    _themeManager.addListener(themeListener);
    super.initState();
    getUserEmail();
    fetchUserData();
  }

  themeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _calculateCumulativeGPA();
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        elevation: 0.0,
        backgroundColor: _themeManager.themeMode == ThemeMode.light
            ? Colors.cyan[50]
            : Colors.cyan[800],
        foregroundColor: _themeManager.themeMode == ThemeMode.light
            ? Colors.cyan[50]
            : Colors.cyan[800],
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.calculate_outlined),
          color: Colors.black,
        ),
        title: Text(
          "GPA Calculator",
          style: TextStyle(
            color: Colors.black,
            fontSize: 23.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          Switch(
            value: _themeManager.themeMode == ThemeMode.dark,
            onChanged: (newValue) {
              _themeManager.toggleTheme(newValue);
            },
          ),
          Builder(builder: (BuildContext context) {
            return IconButton(
              splashRadius: 25.0,
              icon: Icon(
                Icons.menu_rounded,
                color: Colors.black,
                size: 30.0,
              ),
              onPressed: () {
                //Navigator.pushNamed(context, '/menu');
                Scaffold.of(context).openEndDrawer();
              },
            );
          }),
        ],
      ),
      endDrawer: SafeArea(child: buildDrawer(context)),
      endDrawerEnableOpenDragGesture: true,
      drawerEdgeDragWidth: size.width / 2,
      body: Theme(data: Theme.of(context), child: buildBody()),
    );
  }

  SingleChildScrollView buildBody() {
    return SingleChildScrollView(
      child: Container(
        color: Colors.cyan[50],
        margin: EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 5.0, 0, 0),
          child: Column(
            children: [
              Theme(
                data: Theme.of(context),
                child: SvgPicture.asset(
                  'images/image.svg',
                  semanticsLabel: 'My SVG Image',
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              SizedBox(height: 0.0),
              Theme(
                data: Theme.of(context),
                child: buildSemestersCard(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Card buildSemestersCard() {
    TextTheme _textTheme = Theme.of(context).textTheme;
    Size size = MediaQuery.of(context).size;
    return Card(
      elevation: 5.0,
      margin: EdgeInsets.all(5.0),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildSemestersListView(),
            SizedBox(height: 10.0),
            Row(
              children: [
                Text(
                  'CGPA: ${cumulativeGPA.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.displayLarge,
                  textAlign: TextAlign.left,
                ),
                Expanded(
                  child: Text(
                    'Total Credits: ${_calculateTotalCredits()}',
                    style: _textTheme.displayLarge,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            GestureDetector(
              onTap: () {
                setState(() {
                  semesters.add(Semester(courses: []));
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.cyan[100],
                ),
                padding: EdgeInsets.all(5.0),
                child: Text(
                  'Add Semester',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      saveDataToFirestore();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.cyan[100],
                      ),
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      clearData();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.cyan[100],
                      ),
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        'Clear',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  ListView buildSemestersListView() {
    return ListView.builder(
      controller: _scrollController,
      shrinkWrap: true,
      itemCount: semesters.length,
      itemBuilder: (context, index) {
        return Theme(
          data: Theme.of(context),
          child: SemesterWidget(
            semester: semesters[index],
            items: items,
            onRemove: () {
              _removeSemester(index);
            },
            semesterNumber: semesterCounter + index,
          ),
        );
      },
    );
  }

  void _removeSemester(int index) {
    setState(() {
      semesters.removeAt(index);
    });
  }

  void _calculateCumulativeGPA() {
    double totalSemesterGPA = 0.0;

    for (Semester semester in semesters) {
      double semesterGPA = _calculateSemesterGPA(semester);
      totalSemesterGPA += semesterGPA;
    }

    if (semesters.isNotEmpty) {
      cumulativeGPA = totalSemesterGPA / semesters.length;
    } else {
      cumulativeGPA = 0.0;
    }

    setState(() {
      cumulativeGPA = cumulativeGPA;
    });
  }

  double _calculateTotalCredits() {
    double totalCredits = 0.0;
    for (Semester semester in semesters) {
      for (Course course in semester.courses) {
        double credits = double.tryParse(course.credits) ?? 0.0;
        totalCredits += credits;
      }
    }
    return totalCredits;
  }

  double _calculateSemesterGPA(Semester semester) {
    double semesterWeightedPoints = 0.0;
    double semesterTotalCredits = 0.0;

    for (Course course in semester.courses) {
      double credits = double.tryParse(course.credits) ?? 0.0;
      semesterTotalCredits += credits;


      Map<String, double> gradePoints = {
        'A': 10.0,
        'A-': 9.0,
        'B': 8.0,
        'B-': 7.0,
        'C': 6.0,
        'C-': 5.0,
        'D': 4.0,
        'D-': 3.0,
        'E': 2.0,
        'E-': 1.0,
        'NC': 0.0,
      };

      double gradePoint = gradePoints[course.grade] ?? 0.0;
      semesterWeightedPoints += credits * gradePoint;
    }

    if (semesterTotalCredits > 0) {
      return semesterWeightedPoints / semesterTotalCredits;
    } else {
      return 0.0;
    }
  }

  Future<void> getUserEmail() async {
    String? email = await firebaseService.currentUserEmail();
    if (email != null) {
      setState(() {
        userEmail = email;
      });
    }
  }

  void clearData() {
    setState(() {
      semesters = [];
      semesterCounter = 1;
      cumulativeGPA = 0.0;
    });
  }

  Future<void> fetchUserData() async {
    List<Semester> userSemesters = await firebaseService.getUserData();
    setState(() {
      semesters = userSemesters;
    });
  }

  void saveDataToFirestore() async {
    await firebaseService.saveUserData(userEmail, semesters);
  }
}
