class Course {
  String courseName='';
  String courseCode='';
  String grade='A';
  String credits='';

  Course({
    required this.courseName,
    required this.courseCode,
    required this.grade,
    required this.credits,
  });
}

class Semester {
  List<Course> courses = [];

  Semester({required this.courses});
}

class Report {
  String username;
  String idno;
  List<Semester> semesters;
  double cumulativeGPA;

  Report(this.username,this.idno,this.semesters,this.cumulativeGPA);

}