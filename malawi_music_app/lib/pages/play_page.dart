import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:malawi_music_app/models.dart';
import 'package:malawi_music_app/repository.dart';
import 'package:malawi_music_app/ui/ui.dart';

class PlayPage extends StatelessWidget {
  const PlayPage({required this.title, required this.uri, Key? key})
      : super(key: key);

  final String title;
  final String uri;

  @override
  Widget build(BuildContext context) {
    return MainContent(
      child: PlaySection(
        title: title,
        uri: uri,
      ),
    );
  }
}

class PlaySection extends StatefulWidget {
  const PlaySection({
    required this.title,
    required this.uri,
    Key? key,
  }) : super(key: key);

  final String title;
  final String uri;

  @override
  State<PlaySection> createState() => _PlaySectionState();
}

class _PlaySectionState extends State<PlaySection> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return FutureBuilder<Song>(
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
    );
  }

  Future<Song> fetchSong() async {
    final song = await SongRepository.getSong(widget.title, widget.uri);
    return song;
  }
}
