import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ten_twenty_app_test/data/network/api_repository.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../model/genere_model.dart';
import '../model/movie_reponse_model.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  List<Genre> genres = [];
  final List<Color> genreColors = [
    Colors.redAccent,
    Colors.blueAccent,
    Colors.greenAccent,
    Colors.orangeAccent,
    Colors.purpleAccent,
    Colors.tealAccent,
    Colors.pinkAccent,
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<APIRepository>(context, listen: false).fetchGenres()
    );
  }

  List<String> getGenreNames(List<Genre> genres) {
    return genres
        .where((genre) => widget.movie.genreIds.contains(genre.id))
        .map((genre) => genre.name)
        .toList();
  }

  String formatReleaseDate(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    final formatter = DateFormat('MMMM dd, yyyy');
    return formatter.format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    final apiRepository = Provider.of<APIRepository>(context);

    final movie = widget.movie;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 2,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Image.network(
                      'https://image.tmdb.org/t/p/original/${movie.posterPath}',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 10,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            context.pop();
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          'Watch',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                      bottom: 220,
                      child: Text(
                        'In Theaters ${formatReleaseDate(movie.releaseDate)}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      )),
                  Positioned(
                    bottom: 70,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 200, // Set a fixed width for both buttons
                          child: ElevatedButton(
                            onPressed: () {
                              // Action for Get Tickets
                              GoRouter.of(context).push('/selectSeatScreen');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: const Text(
                              'Get Tickets',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 200, // Use the same fixed width here
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // Action for Watch Trailer
                              APIRepository().fetchTrailer(context, movie.id);
                            },
                            icon: const Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Watch Trailer',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              side: const BorderSide(
                                color: Colors.lightBlueAccent,
                                width: 2.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
          Expanded(
              child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Genres:', style: TextStyle(fontSize: 24)),
                  const SizedBox(height: 10),
                 /* Wrap(
                    spacing: 8.0, // Horizontal space between chips
                    runSpacing: 8.0, // Vertical space between rows of chips
                    children: getGenreNames().asMap().entries.map((entry) {
                      int index = entry.key;
                      String name = entry.value;

                      // Cycle through the list of colors based on the index
                      Color backgroundColor = genreColors[index % genreColors.length];

                      return Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Chip(
                          label: Text(name),
                          backgroundColor: backgroundColor,
                          labelStyle: const TextStyle(color: Colors.white),
                          side: BorderSide.none, // Ensure border is removed

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            side: BorderSide.none, // Remove border line

                          ),
                        ),
                      );
                    }).toList(),
                  ),*/
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: getGenreNames(apiRepository.genres).asMap().entries.map((entry) {
                      int index = entry.key;
                      String name = entry.value;

                      Color backgroundColor = genreColors[index % genreColors.length];

                      return Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Chip(
                          label: Text(name),
                          backgroundColor: backgroundColor,
                          labelStyle: const TextStyle(color: Colors.white),
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            side: BorderSide.none,
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  // Additional movie details can go here

                  const SizedBox(height: 20),
                  const Text(
                    'Overview',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    movie.overview ?? 'No description available',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}

