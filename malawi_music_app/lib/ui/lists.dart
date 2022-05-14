import 'dart:async';

import 'package:flutter/material.dart';
import 'package:malawi_music_app/models.dart';
import 'package:malawi_music_app/repository.dart';
import 'package:malawi_music_app/ui/ui.dart';

class LatestSongsList extends StatefulWidget {
  const LatestSongsList({this.paginate = false, Key? key}) : super(key: key);

  final bool paginate;

  @override
  State<LatestSongsList> createState() => _LatestSongsListState();
}

class _LatestSongsListState extends State<LatestSongsList> {
  StreamController<Song>? _streamController;
  ScrollController? _scrollController;

  final List<Song> _songs = [];
  int _page = 1;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _streamController ??= StreamController.broadcast();

    _streamController?.stream
        .listen((data) => setState(() => _songs.add(data)));

    _scrollController = ScrollController()..addListener(onScrollEnd);

    fetchSongs();
  }

  @override
  void dispose() {
    _streamController?.close();
    _scrollController?.removeListener(onScrollEnd);
    _scrollController?.dispose();

    _streamController = null;
    _scrollController = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      child: Column(
        children: [
          Expanded(
            child: PaginatedBuilder<Song>(
              builder,
              stream: _streamController?.stream,
            ),
          ),
          if (loading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  ///[builder] gets called after a successful stream operation, returning the
  ///widget that displays the result from the stream
  Widget builder(BuildContext context, AsyncSnapshot<Song?> snapshot) {
    if (!snapshot.hasData) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: _songs.length,
      itemBuilder: (context, index) {
        final song = _songs.elementAt(index);

        return SongTile(song);
      },
    );
  }

  ///[fetchSongs] handles retrieval of songs from the page
  ///and feeds the data back into [_streamController] until
  ///done and increments the page count.
  void fetchSongs() async {
    final songs = await SongRepository.fetchSongs(_page).toList();

    for (final song in songs) {
      _streamController?.sink.add(song);
      await Future.delayed(Duration.zero);
    }
    _page++;
    loading = false;
    setState(() {});
  }

  void onScrollEnd() {
    final controller = _scrollController!;

    if (controller.offset >= controller.position.maxScrollExtent &&
        widget.paginate &&
        !loading) {
      loading = true;
      fetchSongs();
      setState(() {});
    }
  }
}
