import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:study_hub/pages/course/bloc/course_blocs.dart';
import 'package:study_hub/pages/course/bloc/course_states.dart';
import 'package:study_hub/pages/course/course_detail/bloc/course_detail_blocs.dart';
import 'package:study_hub/pages/course/course_detail/bloc/course_detail_states.dart';
import 'package:study_hub/pages/course/course_detail/course_detail_controller.dart';
import 'package:study_hub/pages/course/widgets/course_detail_widgets.dart' hide buildAppBar;
import 'package:study_hub/pages/profile/settings/widgets/settings_widgets.dart';
import 'package:study_hub/pages/global.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/values/colors.dart';
import '../../register/common_widgets.dart';
import 'course_detail_controller.dart';

class CourseDetail extends StatefulWidget {
  const CourseDetail({Key? key}) : super(key: key);

  @override
  State<CourseDetail> createState() => _CourseDetailState();
}

class _CourseDetailState extends State<CourseDetail> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CourseDetailBloc(),
      child: CourseDetailPage(),
    );
  }
}

class CourseDetailPage extends StatefulWidget {
  const CourseDetailPage({Key? key}) : super(key: key);

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  late CourseDetailController _courseDetailController;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _courseDetailController = CourseDetailController(context);
    _courseDetailController.init();
  }

  Future<void> _downloadPDF(String? downResLink) async {
    if (downResLink == null || downResLink.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PDF download link not available'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      setState(() => _isDownloading = true);

      String downloadUrl = downResLink;

      // Handle different Google Drive link formats
      if (downResLink.contains('/view?usp=sharing')) {
        // Format: https://drive.google.com/file/d/FILE_ID/view?usp=sharing
        final fileId = downResLink.split('/d/')[1].split('/')[0];
        downloadUrl = 'https://drive.google.com/uc?export=download&id=$fileId';
      } else if (downResLink.contains('/view?usp=drive_link')) {
        // Format: https://drive.google.com/file/d/FILE_ID/view?usp=drive_link
        final fileId = downResLink.split('/d/')[1].split('/')[0];
        downloadUrl = 'https://drive.google.com/uc?export=download&id=$fileId';
      } else if (downResLink.contains('drive.usercontent.google.com')) {
        // Already a direct download link - use as is
        downloadUrl = downResLink;
      }

      print('Launching download URL: $downloadUrl');

      if (await canLaunchUrl(Uri.parse(downloadUrl))) {
        await launchUrl(
          Uri.parse(downloadUrl),
          mode: LaunchMode.externalApplication,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Download started'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        throw 'Could not launch download URL';
      }
    } catch (e) {
      print('Download error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Download error: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() => _isDownloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseDetailBloc, CourseDetailStates>(
      builder: (context, state) {
        return Container(
          color: Colors.white,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: buildAppBar("Course Detail"),
              body: state.courseItem == null
                  ? Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                  backgroundColor: Colors.blue.withOpacity(0.2),
                ),
              )
                  : SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 15.h,
                        horizontal: 25.w,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          thumbNail(
                              state.courseItem!.thumbnail.toString()),
                          SizedBox(height: 15.h),
                          menuView(),
                          SizedBox(height: 15.h),
                          reusableText("Course Description",
                              color: AppColors.primaryText),
                          SizedBox(height: 15.h),
                          descriptionText(state.courseItem!.description
                              .toString()),
                          SizedBox(height: 20.h),
                          GestureDetector(
                            onTap: () {
                              if (state.courseItem!.video_url != null &&
                                  state.courseItem!.video_url!
                                      .isNotEmpty) {
                                final userToken =
                                Global.storageService.getUserToken();

                                Navigator.of(context).pushNamed(
                                  '/course-video',
                                  arguments: {
                                    'video_url':
                                    state.courseItem!.video_url,
                                    'course_id': state.courseItem!.id,
                                    'user_token': userToken,
                                    'user_name':
                                    'User_${userToken.substring(0, 5)}',
                                  },
                                );
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  const SnackBar(
                                    content:
                                    Text('Video not available'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            child: goBuyButton("Watch Course"),
                          ),
                          SizedBox(height: 20.h),
                          // Download Notes Container
                          if (state.courseItem!.down_res != null &&
                              state.courseItem!.down_res!.isNotEmpty)
                            Container(
                              padding: EdgeInsets.all(16.r),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius:
                                BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: Colors.blue.withOpacity(0.3),
                                  width: 1.5,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  reusableText(
                                    "Download Notes",
                                    color: AppColors.primaryText,
                                    fontSize: 16,
                                  ),
                                  SizedBox(height: 12.h),
                                  GestureDetector(
                                    onTap: _isDownloading
                                        ? null
                                        : () => _downloadPDF(
                                        state.courseItem!
                                            .down_res),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: _isDownloading
                                            ? Colors.grey
                                            : Colors.blue,
                                        borderRadius:
                                        BorderRadius.circular(
                                            12.r),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 14.h,
                                        horizontal: 16.w,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.download,
                                            color: Colors.white,
                                            size: 22.sp,
                                          ),
                                          SizedBox(width: 12.w),
                                          reusableText(
                                            _isDownloading
                                                ? 'Downloading...'
                                                : 'Download Now',
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            Container(
                              padding: EdgeInsets.all(12.r),
                              decoration: BoxDecoration(
                                color: Colors.orange[100],
                                borderRadius:
                                BorderRadius.circular(8.r),
                              ),
                              child: reusableText(
                                'No download link available',
                                color: Colors.orange,
                                fontSize: 12,
                              ),
                            ),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
