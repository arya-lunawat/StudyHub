import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../common/routes/names.dart';
import '../../common/values/colors.dart';
import '../../common/entities/course.dart';
import '../../common/apis/course_api.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({Key? key}) : super(key: key);

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  List<CourseItem> allCourses = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    try {
      print('=== Starting to load courses ===');
      final response = await CourseAPI.courseList();

      print('✓ API Response received');
      print('Code: ${response.code}');
      print('Message: ${response.msg}');
      print('Data count: ${response.data?.length ?? 0}');

      if (response.data != null && response.data!.isNotEmpty) {
        for (var i = 0; i < response.data!.length; i++) {
          print('Course $i: ${response.data![i].name} - Type: ${response.data![i].courseType?.title} - Lessons: ${response.data![i].lesson_num}');
        }
      }

      setState(() {
        allCourses = response.data ?? [];
        // Sort by lesson_num in ascending order (0, 1, 2, 3, 4...)
        allCourses.sort((a, b) {
          int lessonA = a.lesson_num ?? 0;
          int lessonB = b.lesson_num ?? 0;
          return lessonA.compareTo(lessonB);
        });
        isLoading = false;

        print('=== Sorted courses ===');
        for (var course in allCourses) {
          print('${course.name} - Lesson: ${course.lesson_num}');
        }
      });
    } catch (e) {
      print('✗ ERROR: $e');
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load courses: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Courses"),
        backgroundColor: AppColors.primaryBackground,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(
        child: Text(
          errorMessage!,
          style: TextStyle(
            color: Colors.red,
            fontSize: 16.sp,
          ),
        ),
      )
          : allCourses.isEmpty
          ? Center(
        child: Text(
          "No courses available",
          style: TextStyle(
            color: AppColors.primaryText,
            fontSize: 16.sp,
          ),
        ),
      )
          : Container(
        padding: EdgeInsets.symmetric(
            horizontal: 20.w, vertical: 20.h),
        child: GroupedListView<CourseItem, String>(
          elements: allCourses,
          groupBy: (course) =>
          course.courseType?.title ?? 'Unknown Type',
          groupSeparatorBuilder: (String typeName) =>
              _buildGroupHeader(typeName),
          itemBuilder: (context, CourseItem course) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.COURSE_DETAIL,
                  arguments: {"id": course.id},
                );
              },
              child: _buildCourseItem(course),
            );
          },
          useStickyGroupSeparators: true,
          floatingHeader: true,
          order: GroupedListOrder.ASC,
        ),
      ),
    );
  }

  Widget _buildGroupHeader(String typeName) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      margin: EdgeInsets.only(top: 15.h, bottom: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFF5B7EFF),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        typeName,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCourseItem(CourseItem course) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: AppColors.primaryBackground,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: const Color(0xFF5B7EFF),
          width: 1.w,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.name ?? 'Unknown Course',
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5.h),
                Text(
                  'Lessons: ${course.lesson_num ?? 0}',
                  style: TextStyle(
                    color: AppColors.primaryText.withOpacity(0.6),
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: const Color(0xFF5B7EFF),
            size: 16.sp,
          ),
        ],
      ),
    );
  }
}
