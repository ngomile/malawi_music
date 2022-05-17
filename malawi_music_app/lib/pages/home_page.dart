import 'package:flutter/material.dart';
import 'package:malawi_music_app/ui/ui.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const MainContent(
      child: LatestSection(),
    );
  }
}

class LatestSection extends StatelessWidget {
  const LatestSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SectionContainer(
      heading: LatestSongHeader(),
      child: LatestSongs(),
    );
  }
}
