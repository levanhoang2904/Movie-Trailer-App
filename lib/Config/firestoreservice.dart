import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:movie/Model/Film/film.dart';
import 'package:movie/Model/Genres.dart';
import 'package:movie/Model/MovieDetail.dart';
import 'package:movie/Model/Person/Person.dart';
import 'package:movie/Service/api_service.dart.dart';
import 'package:rxdart/rxdart.dart';

class FireStoreService {
  BehaviorSubject<QuerySnapshot> _movieStreamController =
      BehaviorSubject<QuerySnapshot>();
  final CollectionReference movies =
      FirebaseFirestore.instance.collection('Movie');
  final CollectionReference genres =
      FirebaseFirestore.instance.collection('Genre');
  final CollectionReference movieGeners =
      FirebaseFirestore.instance.collection("MovieGenre");
  final CollectionReference personList =
      FirebaseFirestore.instance.collection("Person");
  final CollectionReference users =
      FirebaseFirestore.instance.collection("User");
  Future<void> addMovie(Movie movie) {
    return movies.add(movie.toJson());
  }

  Future<void> addMovieGenre(int idMoive, int idGenre) {
    return movieGeners.add({"idMovie": idMoive, "idGenre": idGenre});
  }

  addGenre(Genre genre) {
    return genres.add(genre.toJson());
  }

  Stream<QuerySnapshot> getPerson() {
    return personList.snapshots();
  }

  addPerson(Person person) {
    return personList.add(person.toJson());
  }

  Stream<QuerySnapshot> getCast(List list) {
    if (list.length >= 30) list = list.sublist(0, 15);
    print('Chieu dau list: ${list.length}');
    return personList.where('id', whereIn: list).snapshots();
  }

  Future<void> updateMovie(int idCast, int idMovie) async {
    QuerySnapshot list = await movies.where('id', isEqualTo: 466420).get();
    DocumentSnapshot document = list.docs.first;
    DocumentReference documentReference = movies.doc(document.id);
    await documentReference.update({
      'cast': FieldValue.arrayUnion([idCast])
    });
  }

  Stream<QuerySnapshot> getGenreMovie(List idGenre) {
    return genres.where('idGenre', whereIn: idGenre).snapshots();
  }

  //get data movie
  Stream<QuerySnapshot> getMovieList() {
    final movieStream = movies.snapshots();
    return movieStream;
  }

  Stream<QuerySnapshot> getSimilarMovie(List list) {
    final movieStream = movies.where('genre', whereIn: [28]).snapshots();
    return movieStream;
  }

  Future<void> signUp(
      String name, String email, String password, String address) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      String uid = userCredential.user?.uid ?? "";
      await FirebaseFirestore.instance.collection("User").add({
        'uid': uid,
        'name': name,
        'email': email,
        'password': password,
        'address': address
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> addMovieFavourite(int idMovie, List likes) async {
    final user = FirebaseAuth.instance.currentUser;
    print('id user: ${user!.uid}');

    QuerySnapshot userdata =
        await users.where('uid', isEqualTo: user.uid).get();
    DocumentSnapshot document = userdata.docs.first;
    DocumentReference documentReference = users.doc(document.id);
    if (likes.contains(idMovie)) {
      await documentReference.update({
        'likes': FieldValue.arrayRemove([idMovie])
      });
    } else {
      await documentReference.update({
        'likes': FieldValue.arrayUnion([idMovie])
      });
    }
  }

  Stream<QuerySnapshot> getMovieFavourite(List likes) {
    return movies.where('id', whereIn: likes).snapshots();
  }

  Future<Map<String, dynamic>> getUser() async {
    final user = FirebaseAuth.instance.currentUser;
    print(user!.uid);
    QuerySnapshot userdata =
        await users.where('uid', isEqualTo: user.uid).get();
    DocumentSnapshot document = userdata.docs.first;
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    return data;
  }

  void updatePassword(
      String newPassword, String email, String oldPassword) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      var cre =
          EmailAuthProvider.credential(email: email, password: oldPassword);
      await user!.reauthenticateWithCredential(cre).then((value) {
        user.updatePassword(newPassword);
      });

      updatePassDatabase(newPassword);
      print("Mật khẩu đã được cập nhật thành công");
    } catch (e) {
      print(e);
    }
  }

  void updatePassDatabase(String newPassword) async {
    User? user = FirebaseAuth.instance.currentUser;

    final data = await users.where('uid', isEqualTo: user!.uid).get();
    DocumentSnapshot documentSnapshot = data.docs.first;
    DocumentReference documentReference = users.doc(documentSnapshot.id);
    documentReference.update({'password': newPassword});
  }

  Stream<QuerySnapshot> getIdMovieByGenre(int idGenre) {
    final idMovie =
        movieGeners.where('idGenre', isEqualTo: idGenre).snapshots();
    return idMovie;
  }

  // Future<List> idMovies(int idGenre) async {
  //   List id = [];
  //   await getIdMovieByGenre(idGenre).listen((QuerySnapshot<Object?> snapshot) {
  //     List<DocumentSnapshot> moviesList = snapshot.docs.toList();
  //     print(moviesList.length);
  //     List<Map<String, dynamic>> data = moviesList.map((e) {
  //       return e.data() as Map<String, dynamic>;
  //     }).toList();
  //     for (int i = 0; i < data.length; i++) {
  //       id.add(data[i]['idMovie']);
  //     }
  //   });
  //   return id;
  // }

  Stream<QuerySnapshot> getTopRate() {
    final movieTop =
        movies.where('vote_average', isGreaterThan: 7.0).snapshots();
    return movieTop;
  }

  Stream<QuerySnapshot> getMoviesAfterDate() {
    String? afterDateString = '2023-11-01';
    final movieStream =
        movies.orderBy('release_date').startAt([afterDateString]).snapshots();
    return movieStream;
  }

  Stream<QuerySnapshot> idGenres(int idMovie) {
    final listGenres =
        movieGeners.where('idMovie', isEqualTo: idMovie).snapshots();
    return listGenres;
  }

  Stream<QuerySnapshot> getGenreByMovie(int idMovie) {
    List id = [];
    idGenres(idMovie).listen((QuerySnapshot<Object?> snapshot) {
      List<DocumentSnapshot> moviesList = snapshot.docs.toList();
      List<Map<String, dynamic>> data = moviesList.map((e) {
        return e.data() as Map<String, dynamic>;
      }).toList();
      print(data.length);
      for (int i = 0; i < data.length; i++) {
        id.add(data[i]['idGenre']);
      }
      _movieStreamController
          .addStream(genres.where('idGenre', whereIn: id).snapshots());
    });

    return _movieStreamController.stream;
  }
}
