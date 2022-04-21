import 'dart:async';

import 'package:flutter/material.dart';
import 'package:malawi_music_app/models.dart';
import 'package:malawi_music_app/repository.dart';

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
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: Text(
                'Latest',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            // ignore: avoid_unnecessary_containers
            LatestSongsList(),
          ],
        ),
      ),
    );
  }
}

class LatestSongsList extends StatefulWidget {
  const LatestSongsList({Key? key}) : super(key: key);

  @override
  State<LatestSongsList> createState() => _LatestSongsListState();
}

class _LatestSongsListState extends State<LatestSongsList> {
  StreamController<Song>? _streamController;
  final List<Song> songs = [];
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _streamController ??= StreamController.broadcast();

    _streamController?.stream.listen((song) => setState(() => songs.add(song)));
    fetchPhotos();
  }

  @override
  void dispose() {
    _streamController?.close();
    _streamController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 2,
        ),
      ),
      child: StreamBuilder<Song>(
        builder: (BuildContext context, AsyncSnapshot<Song> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: songs.length,
            itemBuilder: (BuildContext context, int item) {
              final song = songs.elementAt(item);
              return ListTile();
            },
          );
        },
      ),
    );
  }

  void fetchPhotos() async {
    final songs = await SongRepository.getSongs(_page).toList();
    for (final song in songs) {
      _streamController?.sink.add(song);
    }
    _page++;
  }
}
