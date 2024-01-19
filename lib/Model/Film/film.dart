class Movie {
  int? id;
  String? title;
  String? posterPath;
  String? overview;
  double? voteAverage;
  int? voteCount;
  double? popularity;
  DateTime? releaseDate;
  String? key;
  int? budget;
  int? runtime;
  List? genre;
  List? cast;
  Movie(
      {this.id,
      this.title,
      this.posterPath,
      this.overview,
      this.voteAverage,
      this.voteCount,
      this.popularity,
      this.releaseDate,
      this.key,
      this.budget,
      this.runtime,
      this.genre,
      this.cast});

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        id: json["id"],
        title: json["title"],
        posterPath: json["poster_path"],
        overview: json["overview"],
        voteAverage: json["vote_average"].toDouble(),
        voteCount: json["vote_count"],
        popularity: json["popularity"].toDouble(),
        releaseDate: DateTime.parse(json["release_date"]),
        key: json["key"],
        budget: json["budget"],
        runtime: json["runtime"],
        genre: List<int>.from(json["genre"].map((x) => x)),
        cast: List<int>.from(json["cast"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "poster_path": posterPath,
        "overview": overview,
        "vote_average": voteAverage,
        "vote_count": voteCount,
        "popularity": popularity,
        "release_date":
            "${releaseDate!.year.toString().padLeft(4, '0')}-${releaseDate!.month.toString().padLeft(2, '0')}-${releaseDate?.day.toString().padLeft(2, '0')}",
        "key": overview,
        "budget": voteCount,
        "runtime": voteCount,
        "genre": List<dynamic>.from(genre!.map((x) => x)),
        "cast": List<dynamic>.from(cast!.map((x) => x)),
      };
}
