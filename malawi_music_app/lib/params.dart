class PlayParams {
  const PlayParams({
    required this.title,
    required this.uri,
  });

  final String title;
  final String uri;

  factory PlayParams.fromMap(Map<String, String> args) {
    final track = args['track'] as String;
    final uri = args['uri'] as String;

    return PlayParams(title: track, uri: uri);
  }
}
