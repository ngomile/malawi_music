class Song {
  const Song({
    required this.artist,
    required this.title,
    required this.image,
    required this.trackURL,
  });

  final String artist;
  final String title;
  final String image;
  final String trackURL;
}

class Track {
  const Track({
    required this.url,
  });

  final String url;
}
