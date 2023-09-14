import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tmdb_app/model/videos_model.dart';
import 'package:tmdb_app/shared/api_key.dart';
class VideoService{
  Future<List<MovieResult>> fetchVideoData(int movieId) async {
    final response = await http.get(
      Uri.parse(
          'http://api.themoviedb.org/3/movie/$movieId/videos?api_key=$apiKey'),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final VideosModel videosModel = VideosModel.fromJson(data);
      return videosModel.results;
    } else {
      throw Exception('Failed to load video data');
    }
  }

}