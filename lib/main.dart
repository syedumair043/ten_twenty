import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ten_twenty_app_test/model/movie_reponse_model.dart';
import 'package:ten_twenty_app_test/screens/cinema_selection.dart';
import 'package:ten_twenty_app_test/screens/movie_detail_screen.dart';
import 'package:ten_twenty_app_test/screens/select_seat_screen.dart';
import 'package:ten_twenty_app_test/screens/watch_screen.dart';

import 'data/network/api_repository.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => APIRepository()),
      ],
      child: MaterialApp.router(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: router,
      ),
    );
  }
}

final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/watchScreen',
    routes: <RouteBase>[
      GoRoute(
          path: '/watchScreen',
          name: '/watchScreen',
          builder: (context, state) {
            return const WatchScreen();
          }),
      GoRoute(
        path: '/movieDetailScreen',
        name: '/movieDetailScreen',
        builder: (context, state) {
          // Extract the passed movie data from the extra parameter
          final movie =
              state.extra as Movie; // assuming movie is passed as a Map
          return MovieDetailScreen(
              movie: movie); // pass the movie data to the detail screen
        },
      ),
      GoRoute(
          path: '/selectSeatScreen',
          name: '/selectSeatScreen',
          builder: (context, state) {
            final data = state.extra! as Map<String, dynamic>;

            return SeatSelectionScreen(name: data["name"], date: data["date"]);
          }),
      GoRoute(
          path: '/selectCinema',
          name: '/selectCinema',
          builder: (context, state) {
            final data = state.extra! as Map<String, dynamic>;
            return CinemaSelection(name: data["name"], date: data["date"]);
          }),
    ]);
