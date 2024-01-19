import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movie/Config/Colors.dart';
import 'package:movie/Config/firestoreservice.dart';
import 'package:movie/Model/Film/film.dart';

class MovieFavourite extends StatefulWidget {
  const MovieFavourite({super.key});

  @override
  State<MovieFavourite> createState() => _MovieFavouriteState();
}

class _MovieFavouriteState extends State<MovieFavourite> {
  Map<String, dynamic> userData = new Map<String, dynamic>();
  bool press = false;
  List likes = [];
  var user;
  @override
  void initState() {
    super.initState();
    getUserData();
  }

  getUserData() async {
    final data = await new FireStoreService().getUser();

    setState(() {
      userData = data;
      likes = userData['likes'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Config.colorBackground,
        appBar: AppBar(
          backgroundColor: Config.colorBackground,
          title: Text("List Movie Favourite"),
        ),
        body: likes.length > 0
            ? Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Danh sách phim yêu thích",
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    )
                  ],
                ),
                Expanded(
                    child: StreamBuilder(
                  stream: new FireStoreService().getMovieFavourite(
                      userData['likes'] != null ? userData['likes'] : [1]),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List list = snapshot.data!.docs;
                      print(list.length);
                      return ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (_, index) {
                            DocumentSnapshot document = list[index];
                            Map<String, dynamic> data =
                                document.data() as Map<String, dynamic>;
                            Movie movie = Movie.fromJson(data);
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  press = !press;
                                });
                                Navigator.pushNamed(
                                  context,
                                  '/movieDetail',
                                  arguments: movie,
                                );
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 20, top: 20),
                                            height: 220,
                                            width: 160,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        "https://image.tmdb.org/t/p/w500" +
                                                            data[
                                                                'poster_path']),
                                                    fit: BoxFit.cover)),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(left: 20),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                200,
                                            child: Text(
                                              data['title'] != null
                                                  ? data['title']
                                                  : "",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: RatingBarIndicator(
                                              rating:
                                                  data['vote_average'] != null
                                                      ? data['vote_average'] / 2
                                                      : 0,
                                              itemCount: 5,
                                              itemSize: 12.0,
                                              unratedColor: Colors.white,
                                              physics: BouncingScrollPhysics(),
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                onPressed: () async {
                                                  print(data['likes']);
                                                  await new FireStoreService()
                                                      .addMovieFavourite(
                                                          data['id'], likes);
                                                  setState(() {
                                                    likes.remove(data['id']);
                                                  });
                                                },
                                                icon: Icon(
                                                    FontAwesomeIcons.trash),
                                                color: Colors.white,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  )
                                ],
                              ),
                            );
                          });
                    } else
                      return Text(
                        "Bạn chưa có danh sách yêu thích",
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      );
                  },
                ))
              ])
            : Container());
  }
}
