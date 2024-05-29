import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchEvent {}

class SearchQueryChanged extends SearchEvent {
  final String query;

  const SearchQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}

class SearchQueryHistoryChanged extends SearchEvent {
  final String query;

  const SearchQueryHistoryChanged(this.query);

  @override
  List<Object> get props => [query];
}
