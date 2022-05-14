import 'dart:async';

import 'package:flutter/material.dart';
import 'package:malawi_music_app/args.dart';
import 'package:malawi_music_app/models.dart';
import 'package:malawi_music_app/repository.dart';
import 'package:malawi_music_app/ui/ui.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MainContent(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: const [
          LatestSongHeader(),
          Expanded(child: LatestSongsList()),
        ],
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
                margin: const EdgeInsets.only(bottom: 24.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: 96.0,
                      margin: const EdgeInsets.only(right: 16.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: CachedImage(song.image),
                      ),
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
                                arguments: PlayArgs(
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
