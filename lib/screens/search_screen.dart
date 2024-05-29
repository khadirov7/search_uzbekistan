import 'package:flutter/material.dart';

import '../data/local/place_data_base.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  List<String> searchHistory = [];

  void _search(String query) async {
    if (query.isNotEmpty) {
      final regions = await PlacesDatabase.instance.searchRegionsByName(query);
      final districts = await PlacesDatabase.instance.searchDistrictsByName(query);
      final quarters = await PlacesDatabase.instance.searchQuartersByName(query);

      setState(() {
        _searchResults = [
          ...regions.map((e) => {'type': 'Region', 'name': e.name}),
          ...districts.map((e) => {'type': 'District', 'name': e.name}),
          ...quarters.map((e) => {'type': 'Quarter', 'name': e.name}),
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       title: Padding(
         padding: const EdgeInsets.all(8.0),
         child: TextField(
           controller: _searchController,
           decoration: const InputDecoration(
             labelText: 'Search',
             prefixIcon: Icon(Icons.search),
           ),
           onSubmitted: (query) {
             if (!searchHistory.contains(query)) {
               searchHistory.add(query);
             }
             setState(() {
             });
           },
           onChanged: (query) {
             _search(query);
           },
         ),
       ),

      ),
      body: Column(
        children: [
          Wrap(
            children: [
              if (searchHistory.isNotEmpty) ...[
                ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: searchHistory.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: (){
                        _searchController.text = searchHistory[index];
                        _search(searchHistory[index]);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.black),
                          color: Colors.indigo,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 13, vertical: 12),
                          child:
                          Text(searchHistory[index], style: const TextStyle(fontSize: 17, color: Colors.white)),
                        ),
                      ),
                    );
                  },
                ),
              ],

            ],
          ),
          ListView.builder(
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_searchResults[index]['name']),
                subtitle: Text('Type: ${_searchResults[index]['type']}'),
              );
            },
          ),
        ],
      ),
    );
  }
}
