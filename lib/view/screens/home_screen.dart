// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tmdb_app/controller/services/auth_service.dart';
import 'package:tmdb_app/controller/services/movie_service.dart';
import 'package:tmdb_app/controller/services/search_service.dart';
import 'package:tmdb_app/model/upcoming_movies.dart';
import 'package:tmdb_app/shared/api_key.dart';
import 'package:tmdb_app/view/screens/details.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});
  TextEditingController searchController =
      TextEditingController(); // Text controller for search query

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthService auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              child: const Icon(Icons.logout),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Sign Out??"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("No"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          try {
                            auth.signOut();
                          } catch (e) {
                            if (kDebugMode) {
                              print(e);
                            }
                          }
                          Navigator.of(context).pop();
                        },
                        child: const Text("Yes"),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search Movies...',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (query) {
                  Provider.of<SearchService>(context, listen: false)
                      .changeQuery(query);
                },
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              "Upcoming Movies",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: FutureBuilder<List<Result>>(
                future: MovieService().fetchUpcomingMovies(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return GridView.builder(
                      itemCount: 10,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                      ),
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[850]!,
                          highlightColor: Colors.grey[800]!,
                          child: Container(
                            height: 250,
                            color: Colors.blueAccent,
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No data available"));
                  } else {
                    final upcomingMovies = snapshot.data!;
                    final filteredMovies = upcomingMovies.where((movie) {
                      final title = movie.title?.toLowerCase() ?? '';
                      return title.contains(Provider.of<SearchService>(context)
                          .query
                          .toLowerCase());
                    }).toList();
                    if (filteredMovies.isEmpty) {
                      return const Center(child: Text("No search results"));
                    }
                    return GridView.builder(
                      itemCount: filteredMovies.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                      ),
                      itemBuilder: (context, index) {
                        final movie = filteredMovies[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MovieDetails(result: movie),
                            ));
                          },
                          child: CachedNetworkImage(
                            imageUrl:
                                'http://image.tmdb.org/t/p/w500${movie.posterPath}?api_key=$apiKey',
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Shimmer.fromColors(
                              baseColor: Colors.grey[850]!,
                              highlightColor: Colors.grey[800]!,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                height: 250,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
