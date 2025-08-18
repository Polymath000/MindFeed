import 'package:flutter/material.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});
  static const String routeName = 'search';

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Search Page')));
  }
}
