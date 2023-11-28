import 'package:flutter/material.dart';
import 'models.dart';
import 'course_widget.dart';

class SemesterWidget extends StatefulWidget {
  final Semester semester;
  final List<String> items;
  final VoidCallback onRemove;
  final int semesterNumber;

  SemesterWidget({
    required this.semester,
    required this.items,
    required this.onRemove,
    required this.semesterNumber,
  });

  @override
  _SemesterWidgetState createState() => _SemesterWidgetState();
}

class _SemesterWidgetState extends State<SemesterWidget> {
  ScrollController _scrollController = ScrollController();
  double semesterGPA = 0.0;
  double totalSemesterCredits = 0.0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    int semesterNumber = widget.semesterNumber;
    _calculateSemesterGPA();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Semester $semesterNumber",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.close,
                size: 30,
              ),
              onPressed: widget.onRemove,
            ),
          ],
        ),
        SizedBox(height: 10.0),
        ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          controller: _scrollController,
          itemCount: widget.semester.courses.length,
          itemBuilder: (context, index) {
            return CourseWidget(
              semester: widget.semester,
              course: widget.semester.courses[index],
              items: widget.items,
              onRemove: () {
                setState(() {
                  widget.semester.courses.removeAt(index);
                });
              },
            );
          },
        ),
        SizedBox(height: 5.0),
        Row(
          children: [
            Text(
              'SGPA: ${semesterGPA.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            Expanded(
              child: Text(
                'Credits: $totalSemesterCredits',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        SizedBox(height: 5.0),
        GestureDetector(
          onTap: () {
            setState(() {
              widget.semester.courses.add(Course(
                  courseName: '', courseCode: '', grade: 'A', credits: ''));
            });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.cyan[100],
            ),
            padding: EdgeInsets.all(5.0),
            child: Text(
              'Add Course',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SizedBox(
          height: 15.0,
          width: size.width,
          child: Divider(
            thickness: 2,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  void _calculateSemesterGPA() {
    if (widget.semester.courses.isEmpty) {
      setState(() {
        semesterGPA = 0.0;
        totalSemesterCredits = 0.0;
      });
      return;
    }

    double totalCredits = 0.0;
    double weightedPoints = 0.0;

    for (Course course in widget.semester.courses) {
      double credits = double.tryParse(course.credits) ?? 0.0;
      totalCredits += credits;

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
      weightedPoints += credits * gradePoint;
    }

    if (totalCredits > 0) {
      semesterGPA = weightedPoints / totalCredits;
      totalSemesterCredits = totalCredits;
      ;
    } else if (semesterGPA > 10) {
      semesterGPA = -1.0;
    } else {
      semesterGPA = 0.0;
    }
    setState(() {
      semesterGPA = semesterGPA;
      totalSemesterCredits = totalSemesterCredits;
    });
  }
}