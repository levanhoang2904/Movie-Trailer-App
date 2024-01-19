import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movie/Config/Colors.dart';
import 'package:movie/Config/firestoreservice.dart';
import 'package:movie/Model/Film/film.dart';
import 'package:movie/Model/Person/Person.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:movie/Service/api_service.dart.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final controller = PageController();
  int activeIndex = 0;

  List movieCarousel = [];
  List personList = [];
  List genres = [];
  List idGenre = [];
  List actionList = [];
  List comeDyList = [];
  late TabController _tabController = new TabController(length: 2, vsync: this);
  String name = "";
  @override
  void initState() {
    super.initState();
    setName();
  }

  setName() async {
    Map<String, dynamic> data = await new FireStoreService().getUser();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('passInput') != data['password']) {
      print(prefs.getString('passInput'));

      new FireStoreService().updatePassDatabase(prefs.getString("passInput")!);
    }
    setState(() {
      print('Hoj vaf ten: ${data['name']}');
      name = data['name'];
    });
  }

  getIdGenres(int id) {
    FireStoreService fireStoreService = new FireStoreService();
    fireStoreService
        .getIdMovieByGenre(id)
        .listen((QuerySnapshot<Object?> snapshot) {
      List<DocumentSnapshot> moviesList = snapshot.docs.toList();
      print(moviesList.length);
      List<Map<String, dynamic>> data = moviesList.map((e) {
        return e.data() as Map<String, dynamic>;
      }).toList();
      for (int i = 0; i < data.length; i++) {
        idGenre.add(data[i]['idMovie']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Config.colorBackground,
        drawer: Drawer(
          backgroundColor: Config.colorBackground,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      name,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    TextButton(
                        onPressed: () async {
                          FirebaseAuth.instance.signOut().then((value) async {
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.remove('emailInput');
                            prefs.remove('passInput');
                            Navigator.pushNamed(context, '/');
                          });
                        },
                        child: Text(
                          "Log out",
                          style: TextStyle(fontSize: 20),
                        ))
                  ],
                ),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/account');
                  },
                  child: Text(
                    "Tài khoản",
                    style: TextStyle(fontSize: 20),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/moviefavourite');
                  },
                  child: Text(
                    "Danh sách phim đã thích",
                    style: TextStyle(fontSize: 20),
                  ))
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: Config.colorBackground,
          title: Center(
            child: Text(
              "Movie App",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/search',
                );
              },
              icon: Icon(FontAwesomeIcons.magnifyingGlass),
            )
          ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.only(top: 30),
                  height: 220,
                  child: Stack(alignment: Alignment.bottomCenter, children: [
                    StreamBuilder(
                        stream: new FireStoreService().getMoviesAfterDate(),
                        builder: ((context, snapshot) {
                          if (snapshot.hasData) {
                            List list = snapshot.data!.docs;
                            movieCarousel = list;
                            return CarouselSlider(
                                items: movieCarousel.map((e) {
                                  DocumentSnapshot document = e;

                                  Map<String, dynamic> data =
                                      document.data() as Map<String, dynamic>;
                                  Movie movie = Movie.fromJson(data);
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/movieDetail',
                                        arguments: movie,
                                      );
                                    },
                                    child: Stack(
                                      children: [
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 220,
                                          decoration: BoxDecoration(
                                              color: Colors.orange,
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      "https://image.tmdb.org/t/p/w500" +
                                                          data['poster_path']),
                                                  fit: BoxFit.cover)),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                  colors: [
                                                Config.colorBackground
                                                    .withOpacity(0),
                                                Config.colorBackground
                                                    .withOpacity(1),
                                              ],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter)),
                                        )
                                      ],
                                    ),
                                  );
                                }).toList(),
                                options: CarouselOptions(
                                    viewportFraction: 1.0,
                                    height: 220,
                                    onPageChanged: (index, reason) {
                                      setState(() {
                                        activeIndex = index;
                                      });
                                    }));
                          } else
                            return Text("No data");
                        })),
                    AnimatedSmoothIndicator(
                      activeIndex: activeIndex,
                      count: movieCarousel.length,
                      effect: SlideEffect(dotHeight: 10, dotWidth: 10),
                    )
                  ])),
              Container(
                child: TabBar(
                    controller: _tabController,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(
                        child: Text("Action"),
                      ),
                      Tab(
                        child: Text("Comedy"),
                      ),
                    ]),
              ),
              Container(
                height: 300,
                margin: EdgeInsets.only(top: 20),
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    StreamBuilder(
                      stream: new FireStoreService().getMovieList(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List list = snapshot.data!.docs;

                          return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: list.length,
                              itemBuilder: (_, index) {
                                DocumentSnapshot document = list[index];
                                Map<String, dynamic> data =
                                    document.data() as Map<String, dynamic>;

                                Movie movie = Movie.fromJson(data);
                                if (movie.genre!.contains(28)) {
                                  return GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/movieDetail',
                                          arguments: movie,
                                        );
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 220,
                                            width: 160,
                                            margin: EdgeInsets.only(left: 20),
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        "https://image.tmdb.org/t/p/w500" +
                                                            data[
                                                                'poster_path']),
                                                    fit: BoxFit.cover)),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              data['title'].length > 24
                                                  ? data['title']
                                                          .substring(0, 15) +
                                                      "..."
                                                  : data['title'],
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: RatingBarIndicator(
                                              rating: 4.2,
                                              itemCount: 5,
                                              itemSize: 12.0,
                                              physics: BouncingScrollPhysics(),
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                            ),
                                          )
                                        ],
                                      ));
                                } else
                                  return Container();
                              });
                        } else
                          return Text("No data");
                      },
                    ),
                    StreamBuilder(
                      stream: new FireStoreService().getMovieList(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List list = snapshot.data!.docs;

                          return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: list.length,
                              itemBuilder: (_, index) {
                                DocumentSnapshot document = list[index];
                                Map<String, dynamic> data =
                                    document.data() as Map<String, dynamic>;
                                Movie movie = Movie.fromJson(data);
                                if (movie.genre!.contains(35)) {
                                  return GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/movieDetail',
                                          arguments: movie,
                                        );
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 220,
                                            width: 160,
                                            margin: EdgeInsets.only(left: 20),
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        "https://image.tmdb.org/t/p/w500" +
                                                            data[
                                                                'poster_path']),
                                                    fit: BoxFit.cover)),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              data['title'].length > 24
                                                  ? data['title']
                                                          .substring(0, 15) +
                                                      "..."
                                                  : data['title'],
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: RatingBarIndicator(
                                              rating: 4.2,
                                              itemCount: 5,
                                              itemSize: 12.0,
                                              physics: BouncingScrollPhysics(),
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                            ),
                                          )
                                        ],
                                      ));
                                } else
                                  return Container();
                              });
                        } else
                          return Text("No data");
                      },
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(
                      "Trending person".toUpperCase(),
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  ),
                ],
              ),
              StreamBuilder(
                  stream: new FireStoreService().getPerson(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List list = snapshot.data!.docs;
                      return Container(
                        height: 110,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: list.length,
                            itemBuilder: (_, index) {
                              DocumentSnapshot document = list[index];
                              Map<String, dynamic> data =
                                  document.data() as Map<String, dynamic>;
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 20, top: 10),
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                "https://image.tmdb.org/t/p/w500" +
                                                    data['profile_path']),
                                            fit: BoxFit.cover)),
                                  ),
                                ],
                              );
                            }),
                      );
                    } else
                      return Text("No data");
                  }),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 20),
                    child: Text(
                      "Popular Movie".toUpperCase(),
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  )
                ],
              ),
              StreamBuilder<QuerySnapshot>(
                stream: new FireStoreService().getMovieList(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List movieList = snapshot.data!.docs;
                    return Container(
                      margin: EdgeInsets.only(left: 10, top: 20),
                      height: 250,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          itemCount: movieList.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (_, index) {
                            DocumentSnapshot document = movieList[index];
                            Map<String, dynamic> data =
                                document.data() as Map<String, dynamic>;
                            Movie movie = Movie.fromJson(data);
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/movieDetail',
                                      arguments: movie,
                                    );
                                  },
                                  child: Container(
                                    height: 220,
                                    width: 160,
                                    margin: EdgeInsets.only(left: 20),
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                "https://image.tmdb.org/t/p/w500" +
                                                    data['poster_path']),
                                            fit: BoxFit.cover)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    data['title'].length > 15
                                        ? data['title'].substring(0, 15) + "..."
                                        : data['title'],
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ),
                              ],
                            );
                          }),
                    );
                  } else {
                    return Text("No data");
                  }
                },
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 20),
                    child: Text(
                      "Top rate Movie".toUpperCase(),
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  ),
                ],
              ),
              StreamBuilder<QuerySnapshot>(
                stream: new FireStoreService().getTopRate(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List movieList = snapshot.data!.docs;
                    return Container(
                      margin: EdgeInsets.only(left: 10, top: 20),
                      height: 250,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          itemCount: movieList.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (_, index) {
                            DocumentSnapshot document = movieList[index];
                            Map<String, dynamic> data =
                                document.data() as Map<String, dynamic>;
                            Movie movie = Movie.fromJson(data);

                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/movieDetail',
                                      arguments: movie,
                                    );
                                  },
                                  child: Container(
                                    height: 220,
                                    width: 160,
                                    margin: EdgeInsets.only(left: 20),
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                "https://image.tmdb.org/t/p/w500" +
                                                    data['poster_path']),
                                            fit: BoxFit.cover)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    data['title'].length > 15
                                        ? data['title'].substring(0, 15) + "..."
                                        : data['title'],
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ),
                              ],
                            );
                          }),
                    );
                  } else {
                    return Text("No data");
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
