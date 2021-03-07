import 'dart:convert';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

RandomColor _randomColor = RandomColor();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MusicApp(),
    );
  }
}

class MusicApp extends StatefulWidget {
  @override
  _MusicAppState createState() => _MusicAppState();
}

class _MusicAppState extends State<MusicApp> {
  bool playing = false; // at the begining we are not playing any song
  IconData playBtn =
      Icons.play_arrow_outlined; // the main state of the play button icon
  var someImages = [];
  var possibleFormats = ['.flac,.jpg'];
  List<String> coverList = ['Von.jpg',];
  List<String> trackList = ['Von.flac',];
  String currentTrack = "";
  int index = 0;
  // #region Music player setup
  //Now let's start by creating our music player
  //first let's declare some object
  AudioPlayer _player;
  AudioCache cache;
  Duration position = new Duration();
  Duration musicLength = new Duration();

  //we will create a custom slider
  Widget slider() {
    return Container(
      width: 300.0,
      child: Slider.adaptive(
          activeColor: Colors.blue[800],
          inactiveColor: Colors.grey[350],
          value: position.inSeconds.toDouble(),
          max: musicLength.inSeconds.toDouble(),
          onChanged: (value) {
            seekToSec(value.toInt());
          }),
    );
  }

  //let's create the seek function that will allow us to go to a certain position of the music
  void seekToSec(int sec) {
    Duration newPos = Duration(seconds: sec);
    _player.seek(newPos);
  }

  //Now let's initialize our player
  @override
  void initState() {
    _initImages();

    super.initState();
    _player = AudioPlayer();
    cache = AudioCache(fixedPlayer: _player);

    //now let's handle the audioplayer time

    //this function will allow you to get the music duration
    _player.durationHandler = (d) {
      setState(() {
        musicLength = d;
      });
    };

    //this function will allow us to move the cursor of the slider while we are playing the song
    _player.positionHandler = (p) {
      setState(() {
        position = p;
      });
    };
  }

  Color randomBlue;
  @override
  void didChangeDependencies() {
    randomBlue = _randomColor.randomColor(colorHue: ColorHue.blue);
    super.didChangeDependencies();
  }
  // #endregion

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //let's start by creating the main UI of the app
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black,
                randomBlue,
              ]),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: 18.0,
          ),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                //Let's add some text title
                // #region
                Center(
                  child: Text(
                    "Playing Now",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                SizedBox(
                  height: 24.0,
                ),
                // #endregion
                
                //Let's add the music cover
                // #region 
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 30),
                    width: 280.0,
                    height: 280.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        image: DecorationImage(
                          image: AssetImage("assets/${coverList[index]}"),
                        )),
                  ),
                ),
                SizedBox(
                  height: 18.0,
                ),
                Center(
                  child: Text(
                    trackList[index].split('.')[0],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                // #endregion
               
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //Let's start by adding the controller
                        //let's add the time indicator text

                        Container(
                          width: 500.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "${position.inMinutes}:${position.inSeconds.remainder(60)}",
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              slider(),
                              Text(
                                "${musicLength.inMinutes}:${musicLength.inSeconds.remainder(60)}",
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // #region Skip previous
                            IconButton(
                              iconSize: 45.0,
                              color: Colors.white,
                              onPressed: () {
                                print(someImages);
                              },
                              icon: Icon(
                                Icons.skip_previous_outlined,
                              ),
                            ),
                            // #endregion

                            // #region Play
                            IconButton(
                              iconSize: 62.0,
                              color: Colors.white,
                              onPressed: () {
                                //here we will add the functionality of the play button
                                if (!playing) {
                                  //now let's play the song
                                  cache.play("Von.flac");
                                  setState(() {
                                    playBtn = Icons.pause_outlined;
                                    playing = true;
                                  });
                                } else {
                                  _player.pause();
                                  setState(() {
                                    playBtn = Icons.play_arrow_outlined;
                                    playing = false;
                                  });
                                }
                              },
                              icon: Icon(
                                playBtn,
                              ),
                            ),
                            // #endregion

                            // #region Skip next
                            IconButton(
                              iconSize: 45.0,
                              color: Colors.white,
                              onPressed: () {},
                              icon: Icon(Icons.skip_next_outlined),
                            ),

                            // #endregion
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _initImages() async {
    // >> To get paths you need these 2 lines
    final manifestContent = await rootBundle.loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    // >> To get paths you need these 2 lines

    final flacList = manifestMap.keys
        .where((String key) => key.contains((new RegExp(r'.flac'))))
        .toList();
    final jpgList = manifestMap.keys
        .where((String key) => key.contains((new RegExp(r'.jpg'))))
        .toList();
    flacList.forEach((String value) {
      someImages.add(value);
    });
    jpgList.forEach((String value) {
      someImages.add(value);
    });
    print(someImages);
    // setState(() {
    // });
  }
}
