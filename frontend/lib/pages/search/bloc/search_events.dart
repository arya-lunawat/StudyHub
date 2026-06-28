import '../../../common/entities/course.dart';

abstract class SearchEvents {
  const SearchEvents();
}

class SearchCourseItem extends SearchEvents {
  const SearchCourseItem(this.query);
  final String query; // Changed from List to String for search keyword
}
