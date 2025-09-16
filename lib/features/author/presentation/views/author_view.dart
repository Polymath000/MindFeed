import 'package:flutter/material.dart';
import 'package:mind_feed/config/themes/app_colors.dart';
import 'package:mind_feed/config/themes/app_text_style.dart';
import 'package:mind_feed/core/utls/app_images.dart';
import 'package:mind_feed/features/author/presentation/views/author_personal_info.dart';
import 'package:mind_feed/features/author/presentation/widgets/article_card_of_author.dart';
import 'package:mind_feed/features/author/presentation/widgets/author_app_bar.dart';

class AuthorView extends StatelessWidget {
  const AuthorView({super.key});
  static const String routeName = 'author';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: CustomScrollView(
        slivers: [
          AuthorAppBar(),
          AuthorPersonalInfo(),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Latest Articles',
                        style: AppTextStyles.headlineSmall,
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'View All',
                          style: AppTextStyles.bodyLarge!.copyWith(
                            color: AppColors.cyan,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: List.generate(
                      6,
                      (index) => ArticleCardOfAuthor(
                        imagePath: Assets.assetsImagesJustTest,
                        title: 'Just For testtsttetejdf djfsdfsdjf ',
                        isDwonload: false,
                        isFav: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
