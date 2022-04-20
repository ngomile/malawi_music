import 'package:html/parser.dart';
import 'package:html/dom.dart';
import 'package:dio/dio.dart';

import 'package:malawi_music_app/models.dart';
import './constants.dart';
import './models.dart';

///[SongRepository] handles extraction of data from
///documents to product [Song] models
class SongRepository {
  /// Performs a get request to the base url path with
  /// the given [page] argument appended to it, and
  /// returns a promise that is eventually fulfilled
  /// to a list of song models.
  static Stream<Song> getSongs(int page) async* {
    final options = BaseOptions(
      sendTimeout: 60000,
      receiveTimeout: 60000,
      connectTimeout: 60000,
    );
    final dio = Dio(options);

    const kCardSelector = '.col-md-9 > .card-deck > .card';
    const kTitlesSelector = '.card-title';
    const kImageSelector = 'img';

    try {
      final url = '$kBaseURL/page/$page';
      final response = await dio.get<String>(
        url,
        options: Options(
          responseType: ResponseType.plain,
        ),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Request failed with status code ${response.statusCode}',
        );
      }

      Document $ = parse(response.data);
      for (final element in $.querySelectorAll(kCardSelector).toList()) {
        final songTitles = element.querySelectorAll(kTitlesSelector).toList();

        final String artist = songTitles.first.text.trim();
        final String title = songTitles.last.text.trim();
        final String image =
            element.querySelector(kImageSelector)?.attributes['src']?.trim() ??
                '';
        final String? trackURL = songTitles.last.attributes['href'];

        yield Song(
          artist: artist,
          title: title,
          image: image,
          track: trackURL ?? '',
        );
      }
    } finally {
      dio.close();
    }
  }

  static Future<Song> getSong(String uri) async {
    final dio = Dio();
    const kTrackSelector = '.col-sm-6';

    try {
      String url = uri;
      Response response = await dio.get<String>(
        url,
        options: Options(responseType: ResponseType.plain),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Request failed with status code ${response.statusCode}',
        );
      }

      Document $ = parse(response.data);

      final trackElement = $.querySelectorAll(kTrackSelector).last;
      final streamURI = trackElement.querySelector('a')?.attributes['href'];

      if (streamURI == null) {
        return Song.empty();
      }

      response = await dio.get(
        streamURI,
        options: Options(
          responseType: ResponseType.plain,
        ),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Request failed with status code ${response.statusCode}',
        );
      }

      $ = parse(response.data);
      final artist = $.querySelector('h1 > a')?.text.trim() ?? '';
      final title =
          $.querySelector('div > h1')?.text.trim().split('-').last.trim() ?? '';
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
      dio.close();
    }
  }
}
