import 'package:html/parser.dart';
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;

import 'package:malawi_music_app/models.dart';
import './constants.dart';
import './models.dart';

class SongRepository {
  /// Performs a get request to the base url path with
  /// the given [page] argument appended to it, and
  /// returns a promise that is eventually fulfilled
  /// to a list of song models.
  static Stream<Song> getSongs(int page) async* {
    final client = http.Client();

    const kCardSelector = '.col-md-9 > .card-deck > .card';
    const kTitlesSelector = '.card-title';
    const kImageSelector = 'img';

    try {
      final url = Uri.parse('$kBaseURL/page/$page');
      final response = await client.get(url);

      if (response.statusCode != 200) {
        throw Exception(
            'Request failed with status code ${response.statusCode}');
      } else {
        Document $ = parse(response.toString());
        for (final element in $.querySelectorAll(kCardSelector).toList()) {
          final songTitles = element.querySelectorAll(kTitlesSelector).toList();

          final String artist = songTitles.first.text.trim();
          final String title = songTitles.last.text.trim();
          final String image = element
                  .querySelector(kImageSelector)
                  ?.attributes['src']
                  ?.trim() ??
              '';
          final String? trackURL = songTitles.last.attributes['href'];

          yield Song(
            artist: artist,
            title: title,
            image: image,
            track: trackURL ?? '',
          );
        }
      }
    } finally {
      client.close();
    }
  }

  static Future<Song> getSong(String uri) async {
    final client = http.Client();
    const kTrackSelector = '.col-sm-6';

    try {
      Uri url = Uri.parse(uri);
      http.Response response = await client.get(url);
      if (response.statusCode != 200) {
        throw Exception(
          'Request failed with status code ${response.statusCode}',
        );
      }

      Document $ = parse(response.toString());

      final trackElement = $.querySelectorAll(kTrackSelector).last;
      final streamURI = trackElement.querySelector('a')?.attributes['href'];

      if (streamURI == null) {
        return Song.empty();
      }

      url = Uri.parse(streamURI);
      response = await client.get(url);

      if (response.statusCode != 200) {
        throw Exception(
          'Request failed with status code ${response.statusCode}',
        );
      }

      $ = parse(response.toString());
      final artist = $.querySelector('h1 > a')?.text.trim() ?? '';
      final title = $.querySelector('div > h1')?.text.trim() ?? '';
      final image =
          $.querySelector('.songpicture > img')?.attributes['src'] ?? '';
      final stream = $.querySelector('audio > source')?.attributes['src'] ?? '';

      return Song(
        artist: artist,
        title: title,
        image: image,
        track: '',
        stream: stream,
      );
    } finally {
      client.close();
    }
  }
}
