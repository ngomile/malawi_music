import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:malawi_music_app/models.dart';
import 'package:malawi_music_app/args.dart';
import 'package:malawi_music_app/repository.dart';
import 'package:malawi_music_app/ui/pages/pages.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MalawiMusic',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const HomePage(),
      onGenerateRoute: (settings) {
        final pathElements = settings.name?.split('/');

        switch (pathElements?.elementAt(1)) {
          case 'play':
            final args = settings.arguments as PlayArgs;
            return MaterialPageRoute(
              builder: (context) => PlayPage(
                title: args.title,
                uri: args.uri,
              ),
            );
          default:
            return MaterialPageRoute(builder: (context) => const HomePage());
        }
      },
    );
  }
}

class PlayPage extends StatefulWidget {
  const PlayPage({required this.title, required this.uri, Key? key})
      : super(key: key);

  final String title;
  final String uri;

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: DefaultTextStyle(
        style: const TextStyle(
          color: Color(0xFFF8F8F8),
        ),
        child: FutureBuilder<Song>(
          future: fetchSong(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Failed to load song'),
              );
            }

            final song = snapshot.data as Song;

            return Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: AppBar(
                    leading: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.chevron_left,
                        size: 36,
                      ),
                    ),
                    backgroundColor: Colors.black,
                    elevation: 0,
                  ),
                ),
                Positioned(
                  top: screenHeight * .12,
                  left: (screenWidth - 375) / 2,
                  right: (screenWidth - 375) / 2,
                  height: screenHeight * .40,
                  child: CachedNetworkImage(
                    imageUrl: song.image,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: const Color(0xFF333436),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: const Color(0xFF333436),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: const Color(0xFF333436),
                      ),
                      child: const Icon(
                        Icons.error,
                        size: 36.0,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * .56,
                  left: (screenWidth * .10) / 2,
                  right: (screenWidth * .10) / 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        song.title,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          overflow: TextOverflow.visible,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        song.artist,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFA6A6A6),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: screenHeight * .80,
                  left: (screenWidth * .02) / 2,
                  right: (screenWidth * .02) / 2,
                  child: TrackPlayer(uri: song.stream as String),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Future<Song> fetchSong() async {
    final song = await SongRepository.getSong(widget.title, widget.uri);
    return song;
  }
}

class TrackPlayer extends StatefulWidget {
  const TrackPlayer({required this.uri, Key? key}) : super(key: key);

  final String uri;

  @override
  State<TrackPlayer> createState() => _TrackPlayerState();
}

class _TrackPlayerState extends State<TrackPlayer> {
  late final AudioPlayer _player = AudioPlayer();

  Duration _duration = const Duration();
  Duration _position = const Duration();

  bool _isPlaying = false;

  final List<IconData> _icons = [
    Icons.play_circle_filled,
    Icons.pause_circle_filled,
  ];

  @override
  void initState() {
    super.initState();

    _player.onDurationChanged.listen((duration) => setState(() {
          _duration = duration;
        }));

    _player.onAudioPositionChanged.listen((duration) => setState(() {
          _position = duration;
        }));

    _player.setUrl(widget.uri);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(
          activeColor: const Color(0xFFF8F8F8),
          inactiveColor: Colors.grey,
          value: _position.inSeconds.toDouble(),
          min: 0.0,
          max: _duration.inSeconds.toDouble(),
          onChanged: _seekHandler,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _parseDurationTime(_position),
                style: const TextStyle(fontSize: 16.0),
              ),
              Text(
                _parseDurationTime(_duration),
                style: const TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              color: const Color(0xFFF8F8F8),
              onPressed: _playHandler,
              icon: !_isPlaying
                  ? Icon(
                      _icons[0],
                      size: 50.0,
                    )
                  : Icon(
                      _icons[1],
                      size: 50.0,
                    ),
            ),
          ],
        ),
      ],
    );
  }

  void _playHandler() {
    _isPlaying = !_isPlaying;
    _isPlaying ? _player.pause() : _player.play(widget.uri);
    setState(() {});
  }

  void _seekHandler(double val) {
    final duration = Duration(seconds: val.toInt());
    _player.seek(duration);
    setState(() {});
  }

  String _parseDurationTime(Duration d) {
    String parsedTime = d.toString();
    List<String> splitParts = parsedTime.split('.')[0].split(':');
    parsedTime = '${splitParts[1]}:${splitParts[2]}';
    return parsedTime;
  }
}
