import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movie/Config/Colors.dart';
import 'package:movie/Config/firestoreservice.dart';
import 'package:movie/Model/Cast.dart';
import 'package:movie/Model/Film/film.dart';
import 'package:movie/Service/api_service.dart.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;
  MovieDetailScreen({required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  Color colorHeart = Colors.white;
  bool isLike = false;
  List likes = [];
  @override
  void initState() {
    super.initState();

    editHeart();
  }

  editHeart() async {
    Map<String, dynamic> userdata = await new FireStoreService().getUser();
    setState(() {
      likes = userdata['likes'];
      userdata['likes'].contains(widget.movie.id)
          ? colorHeart = Colors.red
          : colorHeart = Colors.white;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Config.colorBackground,
          body: SingleChildScrollView(
            child: Column(children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 250,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                "https://image.tmdb.org/t/p/w500" +
                                    widget.movie.posterPath!),
                            fit: BoxFit.cover)),
                  ),
                  Positioned(
                    top: 30,
                    left: 20,
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          FontAwesomeIcons.chevronLeft,
                          size: 30,
                          color: Colors.white,
                        )),
                  ),
                  Positioned(
                    bottom: -30,
                    right: 10,
                    child: Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                            color: Colors.orange, shape: BoxShape.circle),
                        child: GestureDetector(
                          onTap: () async {
                            Navigator.pushNamed(context, '/video',
                                arguments: widget.movie.key);
                          },
                          child: Icon(
                            FontAwesomeIcons.caretRight,
                            size: 30,
                            color: Colors.white,
                          ),
                        )),
                  ),
                  Positioned(
                    top: 30,
                    right: 10,
                    child: Container(
                        height: 70,
                        width: 70,
                        child: GestureDetector(
                          onTap: () async {
                            await new FireStoreService()
                                .addMovieFavourite(widget.movie.id!, likes)
                                .then((value) {
                              setState(() {
                                colorHeart == Colors.red
                                    ? colorHeart = Colors.white
                                    : colorHeart = Colors.red;
                              });
                            });
                          },
                          child: SvgPicture.asset(
                            'assets/images/iconhear.svg',
                            color: colorHeart,
                          ),
                        )),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 30, left: 10),
                child: Row(
                  children: [
                    Text(
                      widget.movie.voteAverage.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: RatingBarIndicator(
                        rating: widget.movie.voteAverage! / 2,
                        itemCount: 5,
                        itemSize: 15.0,
                        itemPadding: EdgeInsets.only(left: 5),
                        physics: BouncingScrollPhysics(),
                        unratedColor: Colors.white,
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10, top: 15),
                child: Row(
                  children: [
                    Text(
                      "Over View",
                      style: TextStyle(color: Color(0xFF333333), fontSize: 16),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: Text(
                  widget.movie.overview!,
                  style: TextStyle(color: Colors.white, height: 1.5),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          child: Text(
                            "Budget".toUpperCase(),
                            style: TextStyle(
                                color: Color(0xFF333333), fontSize: 14),
                          ),
                        ),
                        Text(
                          widget.movie.budget.toString() + "\$",
                          style: TextStyle(
                            color: Colors.yellow,
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          child: Text(
                            "duration".toUpperCase(),
                            style: TextStyle(
                                color: Color(0xFF333333), fontSize: 14),
                          ),
                        ),
                        Text(
                          widget.movie.runtime.toString() + "min",
                          style: TextStyle(
                            color: Colors.yellow,
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          child: Text(
                            "release date".toUpperCase(),
                            style: TextStyle(
                                color: Color(0xFF333333), fontSize: 14),
                          ),
                        ),
                        Text(
                          '${widget.movie.releaseDate?.day}/${widget.movie.releaseDate?.month}/${widget.movie.releaseDate?.year}',
                          style: TextStyle(
                            color: Colors.yellow,
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    child: Text(
                      "Genres",
                      style: TextStyle(color: Color(0xFF333333), fontSize: 16),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      child: StreamBuilder(
                        stream: new FireStoreService()
                            .getGenreMovie(widget.movie.genre!),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List list = snapshot.data!.docs;
                            print(list.length);
                            return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: list.length,
                                itemBuilder: (_, index) {
                                  DocumentSnapshot document = list[index];
                                  Map<String, dynamic> data =
                                      document.data() as Map<String, dynamic>;

                                  return Container(
                                    width: 100,
                                    margin: EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                      child: Text(
                                        data['name'] ?? 'Unknown Genre',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  );
                                });
                          } else
                            return Text("No genre");
                        },
                      ))
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 20),
                child: Row(
                  children: [
                    Text(
                      "Cast",
                      style: TextStyle(color: Color(0xFF333333), fontSize: 16),
                    )
                  ],
                ),
              ),
              StreamBuilder(
                  stream: new FireStoreService().getCast(widget.movie.cast!),
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      List list = snapshot.data!.docs;
                      if (list.length >= 30) {
                        list = list.sublist(0, 15);
                      }
                      // listCast(widget.movie.id!);
                      print('Chieu dai của cast Leo: ${list.length}');
                      return Container(
                        height: 100,
                        margin: EdgeInsets.only(top: 20),
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot document = list[index];
                              Map<String, dynamic> data =
                                  document.data() as Map<String, dynamic>;
                              print(document.id);

                              return Container(
                                margin: EdgeInsets.only(left: 10),
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            "https://image.tmdb.org/t/p/w500" +
                                                data['profile_path']),
                                        fit: BoxFit.cover)),
                              );
                            }),
                      );
                    } else
                      return Text("No data");
                  })),
            ]),
          )

          //     Container(
          //       height: 70,
          //       margin: EdgeInsets.only(top: 20),
          //       child: ListView.builder(
          //           scrollDirection: Axis.horizontal,
          //           itemBuilder: (_, index) {
          //             return Container(
          //               height: 70,
          //               width: 70,
          //               margin: EdgeInsets.only(left: 20),
          //               decoration: BoxDecoration(
          //                   shape: BoxShape.circle,
          //                   image: DecorationImage(
          //                       image: NetworkImage(
          //                           +
          //                              ),
          //                       fit: BoxFit.cover)),
          //             );
          //           }),
          //     )
          //   ],
          // ),
          ),
    );
  }
}
