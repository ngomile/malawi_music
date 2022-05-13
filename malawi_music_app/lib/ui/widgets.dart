import 'package:flutter/material.dart';

/// [MainContent] is a helper widget that places its children within commonly
/// used widgets like [SafeArea] and provides the default text color to child
/// widgets
class MainContent extends StatelessWidget {
  const MainContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

/// [SectionContainer] is a helper widget that provides its child widget with
/// the preferred background color of the app and also gives padding and border
/// radius to it children and trailing and leading header widgets.
class SectionContainer extends StatelessWidget {
  const SectionContainer({
    Widget? leading,
    Widget? trailing,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

/// [PaginatedBuilder] loads additional content on demand when the user reaches
/// the scroll end of the content box, the loader makes a call to the [onScrollEnd]
/// method if the [paginate] field is set to true and shows a loader until it
/// receives data more data
class PaginatedBuilder<T> extends StatefulWidget {
  const PaginatedBuilder({
    required Widget Function(BuildContext, AsyncSnapshot<T>) builder,
    required void Function() onScrollEnd,
    required Stream<T> stream,
    bool? paginated,
    Key? key,
  }) : super(key: key);

  @override
  State<PaginatedBuilder> createState() => _PaginatedBuilderState();
}

class _PaginatedBuilderState extends State<PaginatedBuilder> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
