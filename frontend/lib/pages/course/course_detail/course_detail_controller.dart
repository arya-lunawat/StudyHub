import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:study_hub/common/entities/course.dart';
import 'package:study_hub/common/utils/http_util.dart';
import 'package:study_hub/common/apis/course_api.dart';
import 'package:study_hub/pages/course/course_detail/bloc/course_detail_events.dart';

import '../bloc/course_blocs.dart';
import 'bloc/course_detail_blocs.dart';

class CourseDetailController {
  final BuildContext context;

  CourseDetailController(this.context);

  void init() async {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    asyncLoadAllData(args["id"]);
  }

  asyncLoadAllData(int? id) async {
    CourseRequestEntity courseRequestEntity = CourseRequestEntity();
    courseRequestEntity.id = id;
    var result = await CourseAPI.courseDetail(params: courseRequestEntity);

    if (result.code == 200) {
      if(context.mounted){
        context.read<CourseDetailBloc>().add(TriggerCourseDetail(result.data!));
      }else{
        print("context not mounted");
      }
      // handle success
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something went wrong"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      print('---------------Error code ${result.code}---------------');
    }
  }

  // MOVED INSIDE THE CLASS
  Future<void> goBuy(int? id) async {
    if (id == null) {
      EasyLoading.showError('Invalid course ID');
      return;
    }

    EasyLoading.show(
        status: 'Processing payment...',
        indicator: CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap: false
    );

    try {
      CourseRequestEntity courseRequestEntity = CourseRequestEntity();
      courseRequestEntity.id = id;

      var result = await CourseAPI.coursePay(params: courseRequestEntity);

      EasyLoading.dismiss();

      if (result.code == 200) {
        EasyLoading.showSuccess('Payment successful!');
        var url = Uri.decodeFull(result.data!);
        print('----my returned stripe url is $url--------');

        // TODO: Navigate to Stripe payment page
        // You might want to open this URL in a WebView or browser
      } else {
        EasyLoading.showError(result.msg ?? 'Payment failed');
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Something went wrong');
      print('Payment error: $e');
    }
  }
} // <- Class ends here