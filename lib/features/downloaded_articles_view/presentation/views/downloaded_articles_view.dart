import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:mind_feed/features/home/presentation/views/home_view.dart';
import 'package:mind_feed/features/home/presentation/widgets/custom_drawer.dart';
import 'package:mind_feed/features/home/presentation/widgets/custombackground_for_the_drawer_in_home_page.dart';

class DownloadedArticlesView extends StatelessWidget {
  const DownloadedArticlesView({super.key});
  static const routeName = 'downloadedArticlesView';
  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdrop: CustombackgroundForTheDrawerInHomePage(),
      controller: advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      drawer: CustomDrawer(routeName: routeName),
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: IconButton(
                onPressed: _handleMenuButtonPressed,
                icon: ValueListenableBuilder<AdvancedDrawerValue>(
                  valueListenable: advancedDrawerController,
                  builder: (_, value, __) {
                    return AnimatedSwitcher(
                      duration: Duration(milliseconds: 250),
                      child: Semantics(
                        label: 'Menu',
                        onTapHint: 'expand drawer',
                        child: Icon(
                          value.visible ? Icons.clear : Icons.menu,
                          key: ValueKey<bool>(value.visible),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(child: Text('Just test')),
          ],
        ),
      ),
    );
  }

  void _handleMenuButtonPressed() {
    advancedDrawerController.showDrawer();
  }
}
