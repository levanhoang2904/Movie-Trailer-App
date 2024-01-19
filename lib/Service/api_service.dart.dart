import 'dart:convert';
import 'dart:ffi';

import 'package:http/http.dart' as http;
import 'package:movie/Config/firestoreservice.dart';
import 'package:movie/Model/Cast.dart';
import 'package:movie/Model/Film/film.dart';
import 'package:movie/Model/Genres.dart';
import 'package:movie/Model/MovieDetail.dart';
import 'package:movie/Model/Person/Person.dart';

final String apiKey = 'e9e9d8da18ae29fc430845952232787c';
final String baseUrl = 'https://api.themoviedb.org/3';

Future<List<Movie>> fetchData() async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/discover/movie?api_key=$apiKey&language=en-US'),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      if (data.containsKey('results')) {
        List<Movie> movies =
            (data['results'] as List<dynamic>).map((movieData) {
          return Movie.fromJson(movieData);
        }).toList();

        return movies;
      }
    } else {
      throw Exception(
          'Failed to load data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
  return [];
}

Future<List<Movie>> topRateMovie() async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/top_rated?api_key=$apiKey&language=en-US'),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      if (data.containsKey('results')) {
        List<Movie> movies =
            (data['results'] as List<dynamic>).map((movieData) {
          return Movie.fromJson(movieData);
        }).toList();

        return movies;
      }
    } else {
      throw Exception(
          'Failed to load data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    // Xử lý lỗi ở đây nếu cần
  }
  return [];
}

Future<List<Movie>> popularMovie() async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/popular?api_key=$apiKey&language=en-US'),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      if (data.containsKey('results')) {
        List<Movie> movies =
            (data['results'] as List<dynamic>).map((movieData) {
          List genres = (movieData['genre_ids'].map((genre) {
            new FireStoreService().updateMovie(genre, movieData['id']);
          })).toList();
          return Movie.fromJson(movieData);
        }).toList();

        return movies;
      }
    } else {
      throw Exception(
          'Failed to load data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
  return [];
}

Future<List<Person?>> listPerson() async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/trending/person/day?api_key=$apiKey&language=en-US'),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      if (data.containsKey('results')) {
        List<Person?> persons =
            (data['results'] as List<dynamic>).map((person) {
          if (person['profile_path'] != null) {
            // Nếu có giá trị, tạo đối tượng Person từ dữ liệu

            return Person.fromJson(person);
          }
        }).toList();

        if (persons != null) {
          return persons;
        } else {
          return [];
        }
      }
    } else {
      throw Exception(
          'Failed to load data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
  return [];
}

// Future<MovieDetail> fetchMovieDetail(id) async {
//   try {
//     final response = await http.get(
//       Uri.parse('$baseUrl/movie/${id}?api_key=$apiKey&language=en-US'),
//     );

//     if (response.statusCode == 200) {
//       Map<String, dynamic> data = json.decode(response.body);

//       MovieDetail movieDetail = MovieDetail.fromJson(data);

//       return movieDetail;
//     } else {
//       throw Exception(
//           'Failed to load data. Status code: ${response.statusCode}');
//     }
//   } catch (e) {
//     print('Error: $e');
//   }
//   return MovieDetail(adult: true, id: -1, title: 'Unknown Movie');
// }

Future<List<Genre>> listGenres() async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/genre/movie/list?api_key=$apiKey&language=en-US'),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);

      List<Genre> genres = (data['genres'] as List<dynamic>).map((person) {
        return Genre.fromJson(person);
      }).toList();
      return genres;
    } else {
      throw Exception(
          'Failed to load data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error ${e}');
    return [];
  }
}

Future<List<Cast>> listCast(int id) async {
  try {
    final response = await http.get(Uri.parse(
        '${baseUrl}/movie/${id}/credits?api_key=${apiKey}&language=en-US'));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      print(data['cast']);
      List<Cast> casts = (data['cast'] as List<dynamic>).map((e) {
        if (e['profile_path'] != null) {
          new FireStoreService().addPerson(Person.fromJson(e));
        }
        return Cast.fromJson(e);
      }).toList();

      return casts;
    }
  } catch (e) {
    print('Error: ${e}');
    return [];
  }
  return [];
}

Future<String> getKeyVideo(int id) async {
  try {
    final response = await http.get(Uri.parse(
        '${baseUrl}/movie/${id}/videos?api_key=${apiKey}&language=en-US'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return data['results'][0]['key'];
    } else {
      throw Exception(
          'Failed to load data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: ${e}');
    return "";
  }
}
