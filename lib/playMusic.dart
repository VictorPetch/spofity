import 'dart:convert';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';
import 'package:flutter/services.dart';

RandomColor _randomColor = RandomColor();

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: MusicApp(),
//     );
//   }
// }

// ignore: must_be_immutable
class MusicApp extends StatefulWidget {
  int selectedIndex;
  MusicApp(this.selectedIndex);

  @override
  _MusicAppState createState() => _MusicAppState();
}

class _MusicAppState extends State<MusicApp> {
  bool playing = false; // at the begining we are not playing any song
  IconData playBtn =
      Icons.play_arrow_outlined; // the main state of the play button icon
  var someImages = [];
  List<String> coverList = [
    'Von.jpg',
    'L.jpg',
    'nc17.jpg',
    'Bergentrucküng.jpg',
    'When I see you.jpg',
    'When you smile.jpg',
  ];
  List<String> trackList = [
    'Terror In Resonance - Von.flac',
    'Death Note - L.mp3',
    'Terror in Resonance - nc17.mp3',
    'Undertale - Bergentrucküng.mp3',
    'Kudasai - When I see you.mp3',
    'Neeks - When you smile.mp3',
  ];
  String currentTrack = "";
  int index = 0;

  @override
  void initState() {
    _initImages();
    index = widget.selectedIndex;
    super.initState();
    _player = AudioPlayer();
    cache = AudioCache(fixedPlayer: _player);

    //now let's handle the audioplayer time

    //this function will allow you to get the music duration
    _player.onDurationChanged;
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 85),
                        child: Text(
                          "Playing Now",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 23.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ],
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
                          fit: BoxFit.fill,
                          image: AssetImage("assets/${coverList[index]}"),
                        )),
                  ),
                ),
                SizedBox(
                  height: 18.0,
                ),
                Center(
                  child: Text(
                    trackList[index].split('.')[0].split('-')[1],
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
                                    fontSize: 18.0, color: Colors.white),
                              ),
                              slider(),
                              Text(
                                "${musicLength.inMinutes}:${musicLength.inSeconds.remainder(60)}",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
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
                                _player.stop();
                                setState(() {
                                  playBtn = Icons.play_arrow_outlined;
                                  playing = false;
                                });
                                if (position.inMilliseconds == 0) {
                                  setState(() {
                                    index != 0 ? index-- : index = trackList.length-1;
                                  });
                                } else {
                                  setState(() {
                                    position = Duration(minutes: 0, seconds: 0);
                                  });
                                }
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
                                  cache.play(trackList[index]);
                                  setState(() {
                                    playBtn = Icons.pause_outlined;
                                    playing = true;
                                  });
                                } else {
                                  setState(() {
                                    _player.pause();
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
                              onPressed: () {
                                _player.stop();

                                setState(() {
                                  position = Duration(minutes: 0, seconds: 0);
                                  // if (playing) playing = false;
                                  playBtn = Icons.pause_outlined;
                                  index < trackList.length-1 ? index++ : index = 0;
                                });
                                cache.play(trackList[index]);
                              },
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

    final jpgList = manifestMap.keys
        .where((String key) => key.contains((new RegExp(r'.jpg'))))
        .toList();
    jpgList.forEach((String value) {
      someImages.add(value);
    });
    print(someImages);
    // setState(() {
    // });
  }

  @override
  void dispose() {
    _player.stop();
    super.dispose();
  }
}
