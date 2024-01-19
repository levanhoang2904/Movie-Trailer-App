import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movie/Config/Colors.dart';
import 'package:movie/Config/firestoreservice.dart';
import 'package:movie/Model/Film/film.dart';

class SearchMovie extends StatefulWidget {
  const SearchMovie({super.key});

  @override
  State<SearchMovie> createState() => _SearchMovieState();
}

final formKey = GlobalKey<FormState>();

class _SearchMovieState extends State<SearchMovie> {
  TextEditingController _searchController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Config.colorBackground,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            child: Column(children: [
              Row(
                children: [
                  Container(
                    height: 100,
                    child: Center(
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(FontAwesomeIcons.chevronLeft),
                        iconSize: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width - 100,
                    child: Form(
                        key: formKey,
                        child: Center(
                          child: TextFormField(
                            controller: _searchController,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                            onChanged: (value) {
                              setState(() {
                                _searchController.text = value;
                              });
                            },
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Config.colorBorder))),
                          ),
                        )),
                  )
                ],
              ),
              Expanded(
                child: StreamBuilder(
                  stream: new FireStoreService().getMovieList(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List movies = snapshot.data!.docs;

                      return ListView.builder(
                          itemCount: movies.length,
                          itemBuilder: (_, index) {
                            DocumentSnapshot document = movies[index];
                            Map<String, dynamic> data =
                                document.data() as Map<String, dynamic>;
                            if (data['title']
                                    .toLowerCase()
                                    .contains(_searchController.text) &&
                                _searchController.text != "") {
                              Movie movie = Movie.fromJson(data);
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/movieDetail',
                                    arguments: movie,
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 20),
                                  height: 100,
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(66, 66, 66, 1.0)),
                                  child: Row(children: [
                                    Container(
                                      height: 100,
                                      width: 150,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  "https://image.tmdb.org/t/p/w500" +
                                                      data['poster_path']),
                                              fit: BoxFit.cover)),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      data['title'].length > 16
                                          ? data['title'].substring(0, 16) +
                                              " ..."
                                          : data['title'],
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    )
                                  ]),
                                ),
                              );
                            } else
                              return Container();
                          });
                    } else
                      return Text("");
                  },
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
