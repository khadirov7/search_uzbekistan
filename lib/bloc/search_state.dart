import 'package:equatable/equatable.dart';

class SearchState extends Equatable {
  final String query;
  final List<Map<String, dynamic>> searchResults;
  final List<Map<String, dynamic>> allResults;
  final List<String> searchHistory;
  final bool isLoading;

  const SearchState({
    required this.query,
    required this.searchResults,
    required this.allResults,
    required this.searchHistory,
    required this.isLoading,
  });

  factory SearchState.initial() {
    return SearchState(
      query: '',
      searchResults: [],
      allResults: [],
      searchHistory: [],
      isLoading: false,
    );
  }

  SearchState copyWith({
    String? query,
    List<Map<String, dynamic>>? searchResults,
    List<Map<String, dynamic>>? allResults,
    List<String>? searchHistory,
    bool? isLoading,
  }) {
    return SearchState(
      query: query ?? this.query,
      searchResults: searchResults ?? this.searchResults,
      allResults: allResults ?? this.allResults,
      searchHistory: searchHistory ?? this.searchHistory,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [query, searchResults, allResults, searchHistory, isLoading];
}
