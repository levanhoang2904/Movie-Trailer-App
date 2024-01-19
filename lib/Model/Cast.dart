class Cast {
  int? id;
  int? castId;
  String? name;
  String? profilePath;

  Cast({
    this.id,
    this.castId,
    this.name,
    this.profilePath,
  });

  factory Cast.fromJson(Map<String, dynamic> json) => Cast(
        id: json["id"],
        castId: json["cast_id"],
        name: json["name"],
        profilePath: json["profile_path"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cast_id": castId,
        "name": name,
        "profile_path": profilePath,
      };
}
