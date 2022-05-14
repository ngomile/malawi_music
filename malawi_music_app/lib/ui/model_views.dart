import 'package:flutter/material.dart';
import 'package:malawi_music_app/args.dart';
import 'package:malawi_music_app/models.dart';
import 'package:malawi_music_app/ui/ui.dart';

class SongTile extends StatelessWidget {
  const SongTile(this.song, {Key? key}) : super(key: key);

  final Song song;

  @override
  Widget build(BuildContext context) {
    final _imageSection = GestureDetector(
      onTapUp: (_) => Navigator.pushNamed(
        context,
        '/play',
        arguments: PlayArgs(
          title: song.title,
          uri: song.track,
        ),
      ),
      child: Container(
        height: 52.0,
        width: 72.0,
        margin: const EdgeInsets.only(right: 24.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: CachedImage(song.image),
      ),
    );

    final _titleSection = Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
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
    );

    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 96.0,
        maxHeight: 100.0,
      ),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(2.0), bottomLeft: Radius.circular(2.0)),
          // color: Colors.grey,
        ),
        margin: const EdgeInsets.only(bottom: 24.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            _imageSection,
            _titleSection,
          ],
        ),
      ),
    );
  }
}
