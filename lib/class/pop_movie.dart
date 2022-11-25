import 'dart:ffi';

class PopMovie {
  int id;
  String title;
  String overview;
  // final String vote_average;
  String homepage;
  String release_date;
  int? runtime;
  List? cast;
  List? genres;

  PopMovie(
      {required this.id,
      required this.title,
      required this.overview,
      required this.homepage,
      required this.release_date,
      required this.runtime,
      // required this.vote_average
      this.cast,
      this.genres});
  factory PopMovie.fromJson(Map<String, dynamic> json) {
    return PopMovie(
        id: json['movie_id'],
        title: json['title'],
        overview: json['overview'],
        homepage: json['homepage'],
        release_date: json['release_date'],
        runtime: json['runtime'],
        // vote_average: json['vote_average']
        cast: json['casts'],
        genres: json['genres']);
  }
  @override
  String toString() {
    return title;
  }
}
