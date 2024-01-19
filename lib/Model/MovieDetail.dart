class MovieGenre {
  int? idMovie;
  int? idGenre;

  MovieGenre({
    this.idMovie,
    this.idGenre,
  });

  factory MovieGenre.fromJson(Map<String, dynamic> json) => MovieGenre(
        idMovie: json["idMovie"],
        idGenre: json["idGenre"],
      );

  Map<String, dynamic> toJson() => {
        "idMovie": idMovie,
        "idGenre": idGenre,
      };
}
