class PlayParams {
  const PlayParams({
    required this.track,
    required this.uri,
  });

  final String track;
  final String uri;

  factory PlayParams.fromMap(Map<String, String> args) {
    final track = args['track'] as String;
    final uri = args['uri'] as String;

    return PlayParams(track: track, uri: uri);
  }
}
