import '../../../../common/entities/course.dart';

class SearchStates {
  const SearchStates({
    this.courseItem = const <CourseItem>[],
    this.index=0
  });

  final int index;
  final List<CourseItem> courseItem;

  SearchStates copyWith({int? index, List<CourseItem>? courseItem}){
    return SearchStates(
        courseItem:courseItem??this.courseItem,
        index:index??this.index
    );
  }
}
