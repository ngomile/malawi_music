class Song {
  /// [Song] stores common attributes of songs which can later
  /// be accessed to use the attributes for various actions
  /// such as in a widget.

  const Song({
    required this.artist,
    required this.title,
    required this.image,
    required this.trackURL,
    this.streamURL,
    this.genre,
    this.dateAdded,
    this.size,
  });

  /// [artist] The name of the artist
  final String artist;

  /// [title]  The title of the song
  final String title;

  /// [image]  The url path to the thumbnail for the song
  final String image;

  /// [trackURL] The url to the path to extract the songs url
  final String trackURL;

  /// [streamURL] The url to the file path on the server
  final String? streamURL;

  /// [genre] The genre the song belongs to
  final String? genre;

  /// [size] The size of the song in megabytes
  final String? size;

  /// [dateAdded] The date the song was added to the site
  final String? dateAdded;

  factory Song.empty() {
    return const Song(
      artist: '',
      title: '',
      image: '',
      trackURL: '',
    );
  }
}
