class Person {
  int? id;
  String? name;
  double? popularity;
  int? gender;
  String? profilePath;

  Person({
    this.id,
    this.name,
    this.popularity,
    this.gender,
    this.profilePath,
  });

  factory Person.fromJson(Map<String, dynamic> json) => Person(
      id: json["id"],
      name: json["name"],
      popularity: json["popularity"].toDouble(),
      gender: json["gender"],
      profilePath: json["profile_path"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "popularity": popularity,
        "gender": gender,
        "profile_path": profilePath,
      };
}
