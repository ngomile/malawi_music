import 'dart:async';

import 'package:flutter/material.dart';
import 'package:malawi_music_app/models.dart';
import 'package:malawi_music_app/repository.dart';
import 'package:malawi_music_app/ui/ui.dart';

class LatestSongs extends StatefulWidget {
  const LatestSongs({
    this.paginate = false,
    Key? key,
  }) : super(key: key);

  final bool paginate;

  @override
  State<LatestSongs> createState() => _LatestSongsState();
}

class _LatestSongsState extends State<LatestSongs> {
  StreamController<List<Song>>? _streamController;
  ScrollController? _scrollController;

  final List<Song> _songs = [];
  int _page = 1;
  bool _loading = false;

  @override
  void initState() {
    super.initState();

    _streamController ??= StreamController.broadcast();
    _streamController?.stream.listen((songs) {
      _songs.addAll(songs);
      setState(() => _loading = false);
    });

    _scrollController = ScrollController()..addListener(onScrollEnd);

    getSongs();
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
        child: StreamBuilder(
          stream: _streamController?.stream,
          builder: builder,
        ));
  }

  Widget builder(BuildContext context, AsyncSnapshot<List<Song>> snapshot) {
    final List<Widget> _widgets = [];

    if (!snapshot.hasData) _widgets.add(const Spinner());

    if (_songs.isNotEmpty) {
      _widgets.addAll(_songs.map<SongTile>((e) => SongTile(e)));
    }

    if (_loading) _widgets.add(const Spinner());

    return Container(
      constraints: const BoxConstraints.expand(),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _widgets.length,
              itemBuilder: (context, index) => _widgets[index],
            ),
          ),
        ],
      ),
    );
  }

  void getSongs() async {
    try {
      final songs = await SongRepository.fetchSongs(_page).toList();
      _streamController?.sink.add(songs);
      await Future.delayed(Duration.zero);
      setState(() {
        _page++;
        _loading = false;
      });
    } catch (e) {
      _streamController?.addError(e);
    }
  }

  void onScrollEnd() {
    final controller = _scrollController!;

    if (controller.offset >= controller.position.maxScrollExtent &&
        widget.paginate &&
        !_loading) {
      getSongs();
      setState(() {
        _loading = true;
      });
    }
  }
}
