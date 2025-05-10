class Movie {
  final int id;
  final String title;
  final String release_date;
  final String poster_path;
  final String overview;


  Movie({
    required this.id,
    required this.title,
    required this.release_date,
    required this.poster_path,
    required this.overview,

  });

  factory Movie.fromMap(Map<String, dynamic> map) =>
      Movie(
        id: map['id'],
        title: map['title'],
        release_date: map['release_date'],
        poster_path: map['poster_path'],
        overview: map['overview'],

      );
  factory Movie.fromJson(Map<String, dynamic> json) =>
      Movie(
        id: json['id'],
        title: json['title'],
        release_date: json['release_date'],
        poster_path: json['poster_path'],
        overview: json['overview'],

      );
  Map<String, dynamic> toMap() =>
      {
        'id': id,
        'title': title,
        'release_date': release_date,
        'poster_path': poster_path,
        'overview': overview,

      };
  // إضافة التوابع التالية للمقارنة الصحيحة
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Movie && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
