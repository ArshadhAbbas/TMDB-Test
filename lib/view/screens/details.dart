// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tmdb_app/controller/services/video_service.dart';
import 'package:tmdb_app/model/upcoming_movies.dart';
import 'package:tmdb_app/shared/api_key.dart';
import 'package:tmdb_app/view/screens/video_player.dart';

class MovieDetails extends StatelessWidget {
  MovieDetails({super.key, required this.result});
  Result result;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.white,
              ))),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              width: double.infinity,
              child: Image.network(
                'http://image.tmdb.org/t/p/w500${result.posterPath}?api_key=$apiKey',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              result.title!,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Language: ${result.originalLanguage}",
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Release Date: ${result.releaseDate}",
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Popularity: ${result.popularity}",
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              result.overview,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              // height: 20,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    final videoData = await VideoService().fetchVideoData(result.id);
                    if (videoData.isNotEmpty) {
                      final videoKey = videoData[1].key;
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              VideoPlayerScreen(videoId: videoKey),
                        ),
                      );
                    }
                  } catch (error) {
                    if (kDebugMode) {
                      print('Error fetching video data: $error');
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text("Watch Trailer"),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
