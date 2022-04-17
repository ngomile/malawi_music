class Song {
  /// [Song] stores common attributes of songs which can later
  /// be accessed to use the attributes for various actions
  /// such as in a widget.
  /// [artist] The name of the artist
  /// [title]  The title of the song
  /// [image]  The url path to the thumbnail for the song
  /// [trackURL] The url to the path to extract the songs url
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
  /// [Track] stores attributes of the songs url to the file
  /// [url] the file url for the song.
  const Track({
    required this.url,
  });

  final String url;
}
