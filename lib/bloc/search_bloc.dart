import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/local/place_data_base.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final PlacesDatabase _placesDatabase = PlacesDatabase.instance;

  SearchBloc() : super(SearchState.initial()) {
    on<SearchInitial>(_onSearchInitial);
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<SearchQueryHistoryChanged>(_onSearchQueryHistoryChanged);
  }

  void _onSearchInitial(SearchInitial event, Emitter<SearchState> emit) async {
    emit(state.copyWith(isLoading: true));

    final regions = await _placesDatabase.getAllRegions();
    final districts = await _placesDatabase.getAllDistricts();
    final quarters = await _placesDatabase.getAllQuarters();

    final allResults = [
      ...regions.map((e) => {'type': 'Region', 'name': e.name}),
      ...districts.map((e) => {'type': 'District', 'name': e.name}),
      ...quarters.map((e) => {'type': 'Quarter', 'name': e.name}),
    ];

    emit(state.copyWith(
      allResults: allResults,
      isLoading: false,
    ));
  }

  void _onSearchQueryChanged(SearchQueryChanged event, Emitter<SearchState> emit) async {
    emit(state.copyWith(query: event.query, isLoading: true));

    if (event.query.isEmpty) {
      emit(state.copyWith(searchResults: [], isLoading: false));
    } else {
      final regions = await _placesDatabase.searchRegionsByName(event.query);
      final districts = await _placesDatabase.searchDistrictsByName(event.query);
      final quarters = await _placesDatabase.searchQuartersByName(event.query);

      final searchResults = [
        ...regions.map((e) => {'type': 'Region', 'name': e.name}),
        ...districts.map((e) => {'type': 'District', 'name': e.name}),
        ...quarters.map((e) => {'type': 'Quarter', 'name': e.name}),
      ];

      emit(state.copyWith(searchResults: searchResults, isLoading: false));
    }
  }

  void _onSearchQueryHistoryChanged(SearchQueryHistoryChanged event, Emitter<SearchState> emit) {
    final updatedHistory = List<String>.from(state.searchHistory);
    if (!updatedHistory.contains(event.query)) {
      updatedHistory.add(event.query);
    }

    emit(state.copyWith(searchHistory: updatedHistory));
  }
}
