import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:spofity/playMusic.dart';
import 'package:random_color/random_color.dart';

void main() {
  runApp(MaterialApp(
    home: MenuScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

TextEditingController searchController;
RandomColor _randomColor = RandomColor();

class _MenuScreenState extends State<MenuScreen> {
  List<String> coverList = [
    'Von.jpg',
    'L.jpg',
    'nc17.jpg',
    'Bergentrucküng.jpg',
    'When I see you.jpg',
    'When you smile.jpg',
  ];
  List<String> trackList = [
    '2021 - Rock - Terror In Resonance - Von.flac',
    '2020 - Rock - Death Note - L.mp3',
    '2019 - Pop - Terror in Resonance - nc17.mp3',
    '2018 - Indie - Undertale - Bergentrucküng.mp3',
    '2017 - Lofi - Kudasai - When I see you.mp3',
    '2016 - Reggae - Neeks - When you smile.mp3',
  ];
  List<String> playList;

  int selectedIndex = 0;
  Color randomBlue1;
  Color randomBlue2;
  Color background;
  bool isPlaylistSelected = false;

  @override
  void initState() {
    searchController = new TextEditingController();
    playList = new List<String>();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var heigth = MediaQuery.of(context).size.height;
    background = _randomColor.randomColor(colorHue: ColorHue.blue);
    var filteredList = List.from(trackList.where((String value) {
      return value
          .split('.')[0]
          .toLowerCase()
          .contains(searchController.text.toLowerCase());
    }));

    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black,
                  Color(0xff1463b2),
                  // background,
                ]),
          ),
          child: Column(
            children: [
              // #region Search Area
              ExpandableNotifier(
                child: Container(
                  padding: EdgeInsets.only(right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ExpandableButton(
                          child: Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 40,
                      )),
                      Expandable(
                        expanded: Container(
                          width: width * 0.6,
                          height: 40,
                          // color: Colors.blue,
                          child: Center(
                            child: TextField(
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                              decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.only(top: 10, left: 20),
                                  hintText: "Filtre suas músicas",
                                  hintStyle: TextStyle(color: Colors.white),
                                  fillColor: Colors.white,
                                  focusColor: Colors.white,
                                  hoverColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white))),
                              onChanged: (value) {
                                setState(() {
                                  searchController.text = value;
                                });
                              },
                            ),
                          ),
                        ),
                        collapsed: Container(
                          width: 0,
                          height: 0,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // #endregion

              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  // margin: EdgeInsets.only(left: 40, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            'My Songs',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            isPlaylistSelected = !isPlaylistSelected;
                          });
                        },
                        child: Container(
                          color:
                              !isPlaylistSelected ? Colors.black : Colors.white,
                          width: width * 0.5,
                          child: Center(
                            child: Text(
                              'Playlist',
                              style: TextStyle(
                                  fontSize: 30,
                                  color: isPlaylistSelected
                                      ? Colors.black
                                      : Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 15),
                  color: Colors.blue,
                  child: GridView.count(
                    shrinkWrap: true,
                    childAspectRatio: 0.8,
                    crossAxisCount: 2,
                    children: isPlaylistSelected 
                        ? List.generate(playList.length > 0 ? playList.length : 0, (index) {
                            return Column(
                              children: [
                                Container(
                                  width: width * 0.35,
                                  height: heigth * 0.2,
                                  margin: EdgeInsets.only(bottom: 5, top: 20),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MusicApp(index)));
                                    },
                                    onLongPress: () {
                                      setState(() {
                                        playList.remove(playList[index]);
                                      });
                                      print(playList);
                                    },
                                    child: Card(
                                      child: Image(
                                        fit: BoxFit.fill,
                                        image: AssetImage(
                                            'assets/${coverList[trackList.indexOf(playList[index])]}'),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: heigth * 0.035,
                                  // color: Colors.red,
                                  child: Text(
                                    playList[index].split('.')[0].split('-')[3],
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                ),
                                Container(
                                  height: heigth * 0.035,
                                  // color: Colors.blue,
                                  child: Text(
                                    playList[index].split('.')[0].split('-')[2],
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white.withOpacity(0.5)),
                                  ),
                                ),
                                Container(
                                  height: heigth * 0.035,
                                  // color: Colors.blue,
                                  child: Text(
                                    '''${playList[index].split('.')[0].split('-')[1]} - ${playList[index].split('.')[0].split('-')[0]}''',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white.withOpacity(0.5)),
                                  ),
                                ),
                              ],
                            );
                          })
                        : searchController.text.isEmpty
                            ? List.generate(trackList.length, (index) {
                                randomBlue1 = _randomColor.randomColor(
                                    colorHue: ColorHue.purple,
                                    colorBrightness: ColorBrightness.dark);
                                return Column(
                                  children: [
                                    Container(
                                      width: width * 0.35,
                                      height: heigth * 0.2,
                                      decoration: BoxDecoration(
                                        border: playList.contains(trackList[index]) ? 
                                        Border.all(
                                          color: Colors.black,
                                          width: 2.0
                                        ) :
                                        Border(
                                          
                                        ),
                                      ),
                                      margin:
                                          EdgeInsets.only(bottom: 5, top: 20),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MusicApp(index)));
                                        },
                                        onLongPress: () {
                                          if (!playList
                                              .contains(trackList[index])) {
                                            setState(() {
                                              playList.add(trackList[index]);
                                            });
                                            print(playList);
                                          }
                                        },
                                        child: Card(
                                          child: Image(
                                            fit: BoxFit.fill,
                                            image: AssetImage(
                                                'assets/${coverList[index]}'),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: heigth * 0.035,
                                      // color: Colors.red,
                                      child: Text(
                                        trackList[index]
                                            .split('.')[0]
                                            .split('-')[3],
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      ),
                                    ),
                                    Container(
                                      height: heigth * 0.035,
                                      // color: Colors.blue,
                                      child: Text(
                                        trackList[index]
                                            .split('.')[0]
                                            .split('-')[2],
                                        style: TextStyle(
                                            fontSize: 15,
                                            color:
                                                Colors.white.withOpacity(0.5)),
                                      ),
                                    ),
                                    Container(
                                      height: heigth * 0.035,
                                      // color: Colors.blue,
                                      child: Text(
                                        '''${trackList[index].split('.')[0].split('-')[1]} - ${trackList[index].split('.')[0].split('-')[0]}''',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color:
                                                Colors.white.withOpacity(0.5)),
                                      ),
                                    ),
                                  ],
                                );
                              })
                            : List.generate(filteredList.length, (index) {
                                int originalIndex =
                                    trackList.indexOf(filteredList[index]);

                                return Column(
                                  children: [
                                    Container(
                                      width: width * 0.35,
                                      height: heigth * 0.2,
                                      margin:
                                          EdgeInsets.only(bottom: 5, top: 20),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MusicApp(originalIndex)));
                                        },
                                        child: Card(
                                          child: Image(
                                            fit: BoxFit.fill,
                                            image: AssetImage(
                                                'assets/${coverList[originalIndex]}'),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: heigth * 0.035,
                                      // color: Colors.red,
                                      child: Text(
                                        trackList[originalIndex]
                                            .split('.')[0]
                                            .split('-')[3],
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      ),
                                    ),
                                    Container(
                                      height: heigth * 0.035,
                                      // color: Colors.blue,
                                      child: Text(
                                        trackList[originalIndex]
                                            .split('.')[0]
                                            .split('-')[2],
                                        style: TextStyle(
                                            fontSize: 15,
                                            color:
                                                Colors.white.withOpacity(0.5)),
                                      ),
                                    ),
                                    Container(
                                      height: heigth * 0.035,
                                      // color: Colors.blue,
                                      child: Text(
                                        '''${trackList[originalIndex].split('.')[0].split('-')[1]} - ${trackList[originalIndex].split('.')[0].split('-')[0]}''',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color:
                                                Colors.white.withOpacity(0.5)),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
