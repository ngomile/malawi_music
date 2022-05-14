import 'package:flutter/material.dart';
import 'package:malawi_music_app/styles.dart';

class LatestSongHeader extends StatelessWidget {
  const LatestSongHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: const [
          Text(
            'Latest',
            style: kHeaderFontStyle,
          ),
          SizedBox(height: 8.0),
          Text(
            'Explore the latest music',
            style: kHeaderSubFontStyle,
          ),
        ],
      ),
    );
  }
}
