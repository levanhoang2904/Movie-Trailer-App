import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Video extends StatefulWidget {
  final String url;
  const Video({Key? key, required this.url}) : super(key: key);

  @override
  State<Video> createState() => _VideoState();
}

class _VideoState extends State<Video> {
  String key = "";
  late YoutubePlayerController _videoController;
  @override
  void initState() {
    super.initState();
    setState(() {
      key = widget.url;
      _videoController = YoutubePlayerController(
        initialVideoId: key,
        flags: YoutubePlayerFlags(
          autoPlay: true,
          mute: true,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
              decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.8)),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        FontAwesomeIcons.chevronLeft,
                        size: 30,
                        color: Colors.white,
                      )),
                  Center(
                      child: YoutubePlayerBuilder(
                    player: YoutubePlayer(
                      controller: _videoController,
                    ),
                    builder: (context, player) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [player],
                      );
                    },
                  ))
                ],
              )),
        ),
      ),
    );
  }
}
