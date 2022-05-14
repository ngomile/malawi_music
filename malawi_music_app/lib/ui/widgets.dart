import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:malawi_music_app/ui/colors.dart';

/// [MainContent] is a helper widget that places its children within commonly
/// used widgets like [SafeArea] and provides the default text color to child
/// widgets
class MainContent extends StatelessWidget {
  const MainContent({
    required this.child,
    this.appBar,
    Key? key,
  }) : super(key: key);

  final PreferredSizeWidget? appBar;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: DefaultTextStyle(
          style: const TextStyle(
            color: kLightFontColor,
          ),
          child: Container(
            constraints: const BoxConstraints.expand(),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// [SectionContainer] is a helper widget that provides its child widget with
/// the preferred background color of the app and also gives padding and border
/// radius to it children and trailing and leading header widgets.
class SectionContainer extends StatelessWidget {
  const SectionContainer({
    this.heading,
    required this.child,
    Key? key,
  }) : super(key: key);

  final Widget? heading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final _heading = heading ?? Container();

    return Container(
      constraints: const BoxConstraints.expand(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          _heading,
          Expanded(child: child),
        ],
      ),
    );
  }
}

/// [PaginatedBuilder] loads additional content on demand when the user reaches
/// the scroll end of the content box, the loader makes a call to the [onScrollEnd]
/// method if the [paginate] field is set to true and shows a loader until it
/// receives data more data
class PaginatedBuilder<T> extends StatefulWidget {
  const PaginatedBuilder({
    required Widget Function(BuildContext, AsyncSnapshot<T>) builder,
    required void Function() onScrollEnd,
    required Stream<T> stream,
    bool? paginated,
    Key? key,
  }) : super(key: key);

  @override
  State<PaginatedBuilder> createState() => _PaginatedBuilderState();
}

class _PaginatedBuilderState extends State<PaginatedBuilder> {
  @override
  Widget build(BuildContext context) {
    return Container();
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

/// [CachedImage] wraps [CachedNetworkImage] avoiding further calls to it once
/// the imageProvider has been retrieved.
class CachedImage extends StatefulWidget {
  const CachedImage(
    this.url, {
    Key? key,
  }) : super(key: key);

  final String url;

  @override
  State<CachedImage> createState() => _CachedImageState();
}

class _CachedImageState extends State<CachedImage> {
  Widget? image;

  @override
  Widget build(BuildContext context) {
    if (image != null) return image!;

    return CachedNetworkImage(
      imageUrl: widget.url,
      imageBuilder: (context, imageProvider) {
        image = Container(
          constraints: const BoxConstraints.expand(),
          decoration: BoxDecoration(
            color: kImageBGColor,
            image: DecorationImage(
              image: imageProvider,
            ),
          ),
        );
        return image!;
      },
      placeholder: (context, url) => Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          color: kImageBGColor,
        ),
      ),
      errorWidget: (context, url, error) => Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          color: kImageBGColor,
        ),
        child: const Center(
          child: Icon(
            Icons.error,
            size: 32,
          ),
        ),
      ),
    );
  }
}
