import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchBloc()..add(SearchInitial()),
      child: Scaffold(
        body: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  return TextField(
                    decoration: InputDecoration(
                      labelText: 'Search',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: state.query.isNotEmpty
                          ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          context.read<SearchBloc>().add(SearchQueryChanged(''));
                        },
                      )
                          : null,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (query) {
                      context.read<SearchBloc>().add(SearchQueryChanged(query));
                    },
                    onSubmitted: (query) {
                      context.read<SearchBloc>().add(SearchQueryHistoryChanged(query));
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state.searchHistory.isNotEmpty) {
                  return SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.searchHistory.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            final query = state.searchHistory[index];
                            context.read<SearchBloc>().add(SearchQueryChanged(query));
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.black),
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.indigo,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
                              child: Text(
                                state.searchHistory[index],
                                style: const TextStyle(fontSize: 17, color: Colors.white),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
            BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.query.isEmpty) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: state.allResults.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(state.allResults[index]['name']),
                          subtitle: Text('${state.allResults[index]['type']}'),
                        );
                      },
                    ),
                  );
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: state.searchResults.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: HighlightedText(
                            text: state.searchResults[index]['name'],
                            query: state.query,
                          ),
                          subtitle: Text('${state.searchResults[index]['type']}'),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HighlightedText extends StatelessWidget {
  final String text;
  final String query;

  const HighlightedText({
    required this.text,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) {
      return Text(text);
    }

    final queryLower = query.toLowerCase();
    final textLower = text.toLowerCase();
    final startIndex = textLower.indexOf(queryLower);

    if (startIndex == -1) {
      return Text(text);
    }

    final endIndex = startIndex + query.length;

    return RichText(
      text: TextSpan(
        text: text.substring(0, startIndex),
        style: const TextStyle(color: Colors.black),
        children: [
          TextSpan(
            text: text.substring(startIndex, endIndex),
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          TextSpan(
            text: text.substring(endIndex),
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
