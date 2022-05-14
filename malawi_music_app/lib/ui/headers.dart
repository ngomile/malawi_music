import 'package:flutter/material.dart';
import 'package:malawi_music_app/ui/ui.dart';

class LatestSongHeader extends StatelessWidget {
  const LatestSongHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
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
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 16.0,
          ),
          child: IconButton(
            onPressed: () => Navigator.pushNamed(
              context,
              '/latest',
            ),
            icon: const Icon(
              Icons.chevron_right_rounded,
              color: kPrimaryLightColor,
              size: 32.0,
              semanticLabel: 'Browse Latest',
            ),
          ),
        )
      ],
    );
  }
}
