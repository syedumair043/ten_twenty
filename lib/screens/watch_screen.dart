import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ten_twenty_app_test/data/network/api_repository.dart';

import '../model/movie_reponse_model.dart';
import '../widgets/bottom_navigation_bar.dart';

class WatchScreen extends StatefulWidget {
  const WatchScreen({super.key,});

  @override
  _WatchScreenState createState() => _WatchScreenState();
}

class _WatchScreenState extends State<WatchScreen> {
  int _selectedIndex = 1;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  final List<Widget> _screens = [
    const Center(child: Text('Dashboard Screen')),
    WatchContent(),
    const Center(child: Text('Media Library Screen')),
    const Center(child: Text('More Screen')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        // Clear the search text when search is turned off
        _searchController.clear();
        // Notify WatchContent to reset the search
        (_screens[1] as WatchContent).resetSearch();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search movies...',
                  border: InputBorder.none,
                ),
                onChanged: (query) {
                  final content = _screens[1] as WatchContent;
                  content.updateSearchQuery(query);
                },
              )
            : const Text('Watch'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class WatchContent extends StatefulWidget {
  final ValueNotifier<String> searchQuery = ValueNotifier<String>('');

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void resetSearch() {
    searchQuery.value = ''; // Reset the search query
  }

  @override
  State<WatchContent> createState() => _WatchContentState();
}

class _WatchContentState extends State<WatchContent> {
  late Future<List<Movie>> upComingMovies;
  List<Movie> filteredMovies = [];

  @override
  void initState() {
    super.initState();
    // Fetch upcoming movies using Provider
    //upComingMovies = APIRepository().fetchUpcomingMovies();
    _fetchAndPrintUpcomingMovies();

    print('upComingMovies $upComingMovies');
    widget.searchQuery.addListener(_applySearchFilter);
  }

  void _fetchAndPrintUpcomingMovies() async {
    upComingMovies = APIRepository().fetchUpcomingMovies();
    // Await the movies to print them
    List<Movie> movies = await upComingMovies;
    print('Fetched upComingMovies: $movies');

    setState(() {}); // Trigger a rebuild to show movies in FutureBuilder
  }

  void _applySearchFilter() {
    setState(() {
      final query = widget.searchQuery.value.toLowerCase();
      upComingMovies.then((movies) {
        filteredMovies = query.isEmpty
            ? [] // Reset the filtered list if the query is empty
            : movies
                .where((movie) => movie.title.toLowerCase().contains(query))
                .toList();
      });
    });
  }

  @override
  void dispose() {
    widget.searchQuery.removeListener(_applySearchFilter);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movie>>(
      future: upComingMovies,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading movies'));
        } else {
          final movies = filteredMovies.isEmpty &&
                  widget.searchQuery.value.isNotEmpty
              ? [] // If there's a search query but no filtered movies, show an empty list
              : snapshot.data!;

          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.searchQuery.value.isEmpty
                  ? 1
                  : 2, // Switch to single column if no search
              childAspectRatio: 1.5, // Adjust for suitable movie card size
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return GestureDetector(
                onTap: () {
                  GoRouter.of(context).push(
                    '/movieDetailScreen',
                    extra: movie,
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  margin: const EdgeInsets.symmetric(vertical: 10), 
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          fit: BoxFit.cover,
                          height: 200,
                          'https://image.tmdb.org/t/p/original/${movie.backdropPath}',
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        left: 10,
                        child: Text(
                          movie.title,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
