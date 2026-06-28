import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/entities/course.dart';
import '../../../common/apis/course_api.dart';
import 'search_events.dart';
import 'search_states.dart';

class SearchBlocs extends Bloc<SearchEvents, SearchStates> {
  SearchBlocs() : super(const SearchStates()) {
    on<SearchCourseItem>(_searchCourseItem);
  }

  Future<void> _searchCourseItem(SearchCourseItem event, Emitter<SearchStates> emit) async {
    try {
      print('Searching for: ${event.query}');

      if (event.query.isEmpty) {
        emit(state.copyWith(courseItem: []));
        return;
      }

      // Call server-side search API
      final response = await CourseAPI.searchCourses(query: event.query);

      print('Search results: ${response.data?.length ?? 0}');
      emit(state.copyWith(courseItem: response.data ?? []));
    } catch (e) {
      print('Search error: $e');
      emit(state.copyWith(courseItem: []));
    }
  }
}
