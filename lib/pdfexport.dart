import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' ;
import 'models.dart';
import 'dart:typed_data';

Future<Uint8List> makePdf(Report report) async {
  final pdf = Document();
  pdf.addPage( Page(
    build: (context) {
      return  Column(
        crossAxisAlignment:  CrossAxisAlignment.start,
        children: [
          Text("Student Name: ${report.username}"),
          Text("ID No.: ${report.idno}"),
          for (var i = 0; i < report.semesters.length; i++)
            Column(
              crossAxisAlignment:  CrossAxisAlignment.start,
              children: [
                Text('Semester: ${i + 1}'),
                Table.fromTextArray(
                  context: context,
                  data: <List<String>>[
                    ['Course Code', 'Course Name', 'Credits', 'Grade'],
                    for (var course in report.semesters[i].courses)
                      [
                        course.courseCode,
                        course.courseName,
                        course.credits,
                        course.grade,
                      ],
                  ],
                ),
                SizedBox(height: 10),
              ],
            ),
          Row(
            mainAxisAlignment:  MainAxisAlignment.end,
            children: [
              Text('CGPA: ${report.cumulativeGPA}'),
            ],
          ),
        ],
      );
    },
  ));
  final Uint8List pdfBytes = await pdf.save();

  return pdfBytes;
}
