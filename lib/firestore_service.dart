import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'models.dart';

class FirebaseService {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveUserData(String email, List<Semester> semesters) async {
    try {
      await db.collection('users').doc(email).set({
        'semesters': semesters
            .map((semester) => {
                  'courses': semester.courses
                      .map((course) => {
                            'courseName': course.courseName,
                            'courseCode': course.courseCode,
                            'grade': course.grade,
                            'credits': course.credits,
                          })
                      .toList(),
                })
            .toList(),
      });
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  Future<List<Semester>> getUserData() async {
    try {
      String? email = _auth.currentUser?.email;
      if (email != null) {
        DocumentSnapshot documentSnapshot = await db.collection('users').doc(email).get();

        if (documentSnapshot.exists) {
          List<dynamic> semestersData = documentSnapshot['semesters'];
          List<Semester> semesters = semestersData.map((semesterData) {
            List<dynamic> coursesData = semesterData['courses'];
            List<Course> courses = coursesData.map((courseData) {
              return Course(
                courseName: courseData['courseName'],
                courseCode: courseData['courseCode'],
                grade: courseData['grade'],
                credits: courseData['credits'],
              );
            }).toList();

            return Semester(courses: courses);
          }).toList();

          return semesters;
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }

    return [];
  }

  Future<String?> currentUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.email;
  }
}
