import 'package:cached_network_image/cached_network_image.dart';

const kPlaceHolder =
    'https://www.malawi-music.com/timthumb.php?src=http://www.malawi-music.com/images/albums/1650914592_NYimbo.jpg&w=650&q=90';

CachedNetworkImageProvider getCachedImage(String url) {
  try {
    return CachedNetworkImageProvider(url);
  } catch (_) {
    return const CachedNetworkImageProvider(kPlaceHolder);
  }
}
