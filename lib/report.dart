import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'drawer.dart';
import 'models.dart';
import 'pdfexport.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:printing/printing.dart';
import 'firestore_service.dart';

class ReportPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Report report = Report(
      "John Doe",
      "123456",
      [
        Semester(courses: [
          Course(courseCode: 'CS101',
              courseName: 'Computer Science',
              credits: '3',
              grade: 'A'),
          Course(courseCode: 'ENG102',
              courseName: 'English',
              credits: '3',
              grade: 'B'),
        ],),
        Semester(courses: [
          Course(courseCode: 'MATH201',
              courseName: 'Mathematics',
              credits: '4',
              grade: 'A'),
          Course(courseCode: 'PHY202',
              courseName: 'Physics',
              credits: '4',
              grade: 'A-'),
        ]),
      ],
      3.75,
    );
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        elevation: 0.0,
        backgroundColor: Colors.cyan[50],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.calculate_outlined),
          color: Colors.black,
        ),
        title: Text(
          'Report Card',
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
      body: Container(
        width: size.width,
        color: Colors.cyan[50],
        margin: EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 5.0, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ReportWidget(report: report,),
              ElevatedButton(
                child: Text("Generate Report", style: Theme
                    .of(context)
                    .textTheme
                    .displayLarge),
                onPressed: () async {
                  Uint8List pdfBytes = await makePdf(report);

                  await Printing.sharePdf(
                      bytes: pdfBytes, filename: 'report.pdf');
                },

              )
            ],
          ),
        ),
      ),
    );
  }
}

class ReportWidget extends StatefulWidget {
  final Report report;

  ReportWidget({required this.report});

  @override
  _ReportWidgetState createState() => _ReportWidgetState();
}

class _ReportWidgetState extends State<ReportWidget> {
  late TextEditingController _nameController;
  late TextEditingController _idNoController;
  final FirebaseService firebaseService = FirebaseService();
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.report.username);
    _idNoController = TextEditingController(text: widget.report.idno);

    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 3 * (size.width / 4),
              child: TextField(
                controller: _nameController,
                onChanged: (value) {
                  setState(() {
                    widget.report.username = value;
                  });
                },
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'Student Name',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.grey[600] ?? Colors.grey),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 3 * (size.width / 4),
              child: TextField(
                controller: _idNoController,
                onChanged: (value) {
                  setState(() {
                    widget.report.idno = value;
                  });
                },
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'ID No.',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.grey[600] ?? Colors.grey),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20.0)
      ],
    );
  }

  Future<void> fetchUserData() async {
    String? email = _auth.currentUser?.email;
    if (email != null) {
      DocumentSnapshot documentSnapshot = await db.collection('users').doc(email).get();

      if (documentSnapshot.exists) {
        List<dynamic> semestersData = documentSnapshot['semesters'];
        List<Semester> semesters = [];

        for (var semesterData in semestersData) {
          List<dynamic> coursesData = semesterData['courses'];
          List<Course> courses = [];

          for (var courseData in coursesData) {
            Course course = Course(
              courseName: courseData['courseName'],
              courseCode: courseData['courseCode'],
              grade: courseData['grade'],
              credits: courseData['credits'],
            );

            courses.add(course);
          }

          Semester semester = Semester(courses: courses);
          semesters.add(semester);
        }
        print(semesters);
        setState(() {
          widget.report.semesters = semesters;
        });
      }
    }
  }

/*Future<void> fetchUserData() async {
    String? email = _auth.currentUser?.email;
    if (email != null) {
      DocumentSnapshot documentSnapshot = await db.collection('users').doc(
          email).get();

      if (documentSnapshot.exists) {
        List<dynamic> semestersData = documentSnapshot['semesters'];
        List<Semester> semesters = [];

        for (var semesterData in semestersData) {
          List<dynamic> coursesData = semesterData['courses'];
          List<Course> courses = [];

          for (var courseData in coursesData) {
            List course = [courseData['courseName'],courseData['courseCode'],courseData['grade'],courseData['credits'],];
          }
          semesters=semesters.add(courses);
        }
      }
    }
  }*/
}