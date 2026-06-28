import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/routes/names.dart';
import '../../common/values/colors.dart';
import '../../common/values/constant.dart';
import '../../common/entities/course.dart';
import 'bloc/search_blocs.dart';
import 'bloc/search_events.dart';
import 'bloc/search_states.dart';
import 'widgets/search_page_widgets.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchState();
}

class _SearchState extends State<SearchPage> {
  late SearchBlocs _searchBlocs;

  @override
  void initState() {
    super.initState();
    _searchBlocs = SearchBlocs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Courses"),
        backgroundColor: AppColors.primaryBackground,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          children: [
            searchView((query) {
              _searchBlocs.add(SearchCourseItem(query));
            }),
            SizedBox(height: 20.h),
            Expanded(
              child: BlocBuilder<SearchBlocs, SearchStates>(
                bloc: _searchBlocs,
                builder: (context, state) {
                  if (state.courseItem.isEmpty) {
                    return Center(
                      child: Text(
                        "No courses found",
                        style: TextStyle(
                          color: AppColors.primaryText,
                          fontSize: 16.sp,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: state.courseItem.length,
                    itemBuilder: (context, index) {
                      final course = state.courseItem[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            AppRoutes.COURSE_DETAIL,
                            arguments: {
                              "id": course.id
                            },
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 15.h),
                          padding: EdgeInsets.all(15.w),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBackground,
                            borderRadius: BorderRadius.circular(10.w),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                course.name ?? '',
                                style: TextStyle(
                                  color: AppColors.primaryText,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                course.description ?? '',
                                style: TextStyle(
                                  color: AppColors.primarySecondaryElementText,
                                  fontSize: 14.sp,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchBlocs.close();
    super.dispose();
  }
}
