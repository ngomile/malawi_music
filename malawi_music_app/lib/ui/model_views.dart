import 'package:flutter/material.dart';
import 'package:malawi_music_app/args.dart';
import 'package:malawi_music_app/models.dart';
import 'package:malawi_music_app/ui/ui.dart';

class SongTile extends StatelessWidget {
  const SongTile(this.song, {Key? key}) : super(key: key);

  final Song song;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final orientation = MediaQuery.of(context).orientation;

    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(2.0), bottomLeft: Radius.circular(2.0)),
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
  }
}
