import 'package:flutter/material.dart';
import 'package:malawi_music_app/ui/ui.dart';

class LatestPage extends StatelessWidget {
  const LatestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainContent(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.chevron_left,
            size: 32.0,
          ),
        ),
        title: const Text(
          'Latest',
          style: TextStyle(
            fontSize: 36.0,
          ),
        ),
      ),
      child: const LatestSongsList(),
    );
  }
}
