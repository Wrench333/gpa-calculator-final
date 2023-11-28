import 'package:flutter/material.dart';
import 'models.dart';

class CourseWidget extends StatefulWidget {
  final Course course;
  final List<String> items;
  final VoidCallback onRemove;
  final Semester semester;

  CourseWidget({
    required this.semester,
    required this.course,
    required this.items,
    required this.onRemove,
  });

  @override
  _CourseWidgetState createState() => _CourseWidgetState();
}

class _CourseWidgetState extends State<CourseWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[600] ?? Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.circular(11.0)),
                width: size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      flex: 1,
                      child: TextField(
                        onChanged: (value) => setState(() {
                          widget.course.courseName = value;
                        }),
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Course Name',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[600] ?? Colors.grey),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0)),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Flexible(
                          flex: 2,
                          child: TextField(
                            onChanged: (value) => setState(() {
                              widget.course.courseCode = value;
                            }),
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: 'Course Code',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[600] ?? Colors.grey),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration:
                          BoxDecoration(border: Border.all(color: Colors.grey[600] ?? Colors.grey, width: 1.0)),
                          padding: EdgeInsets.fromLTRB(20, 15, 10, 15),
                          child: DropdownButton<String>(
                            isDense: true,
                            value: widget.course.grade,
                            onChanged: (value) {
                              setState(() {
                                widget.course.grade = value!;
                              });
                            },
                            items: widget.items.map((String item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(item),
                              );
                            }).toList(),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: TextField(
                            onChanged: (value) => setState(() {
                              widget.course.credits = value;
                            }),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: 'Credits',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[600] ?? Colors.grey),
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(10.0)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(1.0),
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: widget.onRemove,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
      ],
    );
  }
}
