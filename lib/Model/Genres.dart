class Genre {
  int? idGenre;
  String? name;

  Genre({
    this.idGenre,
    this.name,
  });

  factory Genre.fromJson(Map<String, dynamic> json) => Genre(
        idGenre: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "idGenre": idGenre,
        "name": name,
      };
}
