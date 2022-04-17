import 'package:malawi_music_app/models.dart';

class SongRepository {
  /// Performs a get request to the base url path with
  /// the given [page] argument appended to it, and
  /// returns a promise that is eventually fulfilled
  /// to a list of song models.
  static Future<List<Song>> getSongs(int page) async {}
}

class TrackRepository {
  static Future<Track> getTrack(String trackURL) async {}
}
