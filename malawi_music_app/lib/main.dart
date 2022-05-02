import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:malawi_music_app/models.dart';
import 'package:malawi_music_app/params.dart';
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
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const HomePage(),
      onGenerateRoute: (settings) {
        final pathElements = settings.name?.split('/');

        if (pathElements != null) {
          if (pathElements[1] == 'play') {
            final params = settings.arguments as PlayParams;

            return MaterialPageRoute(
              builder: (context) =>
                  PlayPage(title: params.title, uri: params.uri),
            );
          }
        }

        return null;
      },
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
        child: DefaultTextStyle(
          style: const TextStyle(
            color: Color(0xFFF8F8F8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: const [
              LatestSongHeader(),
              Expanded(child: LatestSongsList()),
            ],
          ),
        ),
      ),
    );
  }
}

class LatestSongHeader extends StatelessWidget {
  const LatestSongHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: const [
          Text(
            'Latest',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            'Explore the latest music',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ],
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
  final List<Song> _songs = [];
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _streamController ??= StreamController.broadcast();

    _streamController?.stream.listen(
      (song) => setState(() => _songs.add(song)),
    );
    fetchSongs();
  }

  @override
  void dispose() {
    _streamController?.close();
    _streamController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final orientation = MediaQuery.of(context).orientation;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 8.0,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF0F0F0F),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      margin: const EdgeInsets.only(top: 12.0),
      child: StreamBuilder<Song>(
        stream: _streamController?.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: _songs.length,
            itemBuilder: (context, index) {
              final song = _songs.elementAt(index);

              return Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(2.0),
                      bottomLeft: Radius.circular(2.0)),
                  // color: Colors.grey,
                ),
                height: orientation == Orientation.portrait
                    ? screenHeight * .10
                    : screenHeight * .15,
                margin: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    CachedNetworkImage(
                      imageUrl: song.image,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2.0),
                          color: const Color(0xFF333436),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                        width: screenWidth * .15,
                        margin: const EdgeInsets.only(right: 12.0),
                      ),
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            GestureDetector(
                              onTapUp: (_) => Navigator.pushNamed(
                                context,
                                '/play',
                                arguments: PlayParams(
                                  title: song.title,
                                  uri: song.track,
                                ),
                              ),
                              child: Text(
                                song.title,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              song.artist,
                              style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 18,
                                color: Color(0xFFA6A6A6),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  ///[fetchSongs] handles retrieval of songs from the page
  ///and feeds the data back into [_streamController] until
  ///done and increments the page count.
  void fetchSongs() async {
    final songs = await SongRepository.getSongs(_page).toList();

    for (final song in songs) {
      _streamController?.sink.add(song);
      await Future.delayed(Duration.zero);
    }
    _page++;
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

              final song = snapshot.data;

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
                      imageUrl: song?.image ?? '',
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
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
                          song?.title ?? '',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            overflow: TextOverflow.visible,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          song?.artist ?? '',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFA6A6A6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }

  Future<Song> fetchSong() async {
    final song = await SongRepository.getSong(widget.title, widget.uri);
    return song;
  }
}
