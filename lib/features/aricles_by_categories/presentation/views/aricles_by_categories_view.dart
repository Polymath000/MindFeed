import 'package:flutter/material.dart';

class AriclesByCategoriesView extends StatelessWidget {
  const AriclesByCategoriesView({Key? key}) : super(key: key);
  static const String routeName = 'ariclesByCategories';

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Aricles By Categories View')));
  }
}
