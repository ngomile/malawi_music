class PlayArgs {
  const PlayArgs({
    required this.title,
    required this.uri,
  });

  final String title;
  final String uri;

  factory PlayArgs.fromMap(Map<String, String> args) {
    final track = args['track'] as String;
    final uri = args['uri'] as String;

    return PlayArgs(title: track, uri: uri);
  }
}
