import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:study_hub/common/entities/entities.dart';
import 'package:study_hub/common/values/colors.dart';
import 'package:study_hub/pages/home/bloc/home_page_blocs.dart';
import 'package:study_hub/pages/home/bloc/home_page_states.dart';
import 'package:study_hub/pages/home/widgets/home_page_widgets.dart';

import '../../common/routes/names.dart';
import 'home_controller.dart';

class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late UserItem userProfile;
  HomeController? _homeController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // initialize only once
    if (_homeController == null) {
      _homeController = HomeController(context: context);
      _homeController!.init();
      userProfile = _homeController!.userProfile!;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Prevent build until controller is ready
    if (_homeController == null || _homeController!.userProfile == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(userProfile.avatar.toString()),
      body: BlocBuilder<HomePageBlocs, HomePageStates>(
        builder: (context, state) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 0, horizontal: 25.w),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: homePageText(
                    "Hello,",
                    color: AppColors.primaryThreeElementText,
                  ),
                ),
                SliverToBoxAdapter(
                  child: homePageText(
                    "${userProfile.name!}!",
                    top: 5,
                  ),
                ),
                SliverPadding(padding: EdgeInsets.only(top: 20.h)),
                SliverToBoxAdapter(child: searchView(context)),
                SliverToBoxAdapter(child: slidersView(context, state)),
                SliverToBoxAdapter(child: menuView()),
                SliverPadding(
                  padding: EdgeInsets.symmetric(vertical: 18.h),
                  sliver: SliverGrid(
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      childAspectRatio: 1.6,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      childCount: state.courseItem.length,
                          (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              AppRoutes.COURSE_DETAIL,
                              arguments: {
                                "id": state.courseItem[index].id
                              },
                            );
                          },
                          child: courseGrid(state.courseItem[index]),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
