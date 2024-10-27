import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ten_twenty_app_test/constants.dart';
import 'package:ten_twenty_app_test/model/movie_reponse_model.dart';
import 'package:http/http.dart' as http;
import '../../model/genere_model.dart';
import '../../screens/trailer_player_screen.dart';
import 'endPoints.dart' as end_point;

class APIRepository extends ChangeNotifier {
  List<Movie> _upcomingMovies = [];
  List<Genre> _genres = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Movie> get upcomingMovies => _upcomingMovies;
  List<Genre> get genres => _genres;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;



// Fetch Upcoming Movies
  Future<List<Movie>> fetchUpcomingMovies() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(end_point.baseUrl + 'upcoming?api_key=$apiKey'));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['results'];
        _upcomingMovies = data.map((movie) => Movie.fromJson(movie)).toList();
        print('_upcomingMovies $_upcomingMovies');
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      _errorMessage = e.toString();
      _upcomingMovies = []; // Assign an empty list if an error occurs
      print('Error occurred: $_errorMessage');
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return _upcomingMovies;
  }


  // Fetch Trailer
  Future<void> fetchTrailer(BuildContext context, int movieId) async {
    final url = '${end_point.baseUrl}$movieId/videos?api_key=$apiKey';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final videos = json.decode(response.body)['results'];
        final trailer = videos.firstWhere(
              (video) => video['type'] == 'Trailer' && video['site'] == 'YouTube',
          orElse: () => null,
        );
        if (trailer != null) {
          final trailerId = trailer['key'];
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TrailerPlayerScreen(videoId: trailerId),
            ),
          );
        }
      } else {
        throw Exception('Failed to load trailer');
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Fetch Genres
  // Future<void> fetchGenres() async {
  //   _isLoading = true;
  //   try {
  //     final response = await http.get(Uri.parse('https://api.themoviedb.org/3/genre/movie/list?api_key=$apiKey'));
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       _genres = (data['genres'] as List).map((json) => Genre.fromJson(json)).toList();
  //       print('_genres $_genres');
  //       notifyListeners();
  //     } else {
  //       throw Exception('Failed to load genres');
  //     }
  //   } catch (e) {
  //     _errorMessage = e.toString();
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }

  Future<void> fetchGenres() async {
    _isLoading = true;
    notifyListeners(); // Notify listeners before making the API call

    try {
      final response = await http.get(
        Uri.parse('https://api.themoviedb.org/3/genre/movie/list?api_key=$apiKey'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _genres = (data['genres'] as List).map((json) => Genre.fromJson(json)).toList();
        print('_genres $_genres');
      } else {
        _errorMessage = 'Failed to load genres: ${response.statusCode}';
        print(_errorMessage);
      }
    } catch (e) {
      _errorMessage = 'Error fetching genres: ${e.toString()}';
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify listeners at the end
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}