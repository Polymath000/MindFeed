import 'package:flutter/material.dart';
import 'package:mind_feed/config/themes/app_text_style.dart';
import 'package:mind_feed/core/utls/app_images.dart';
import 'package:mind_feed/features/article/presentation/widgets/author_card.dart';
import 'package:mind_feed/features/article/presentation/widgets/custom_popup_menu_button_for_article_view.dart';

class ArticleViewBody extends StatelessWidget {
  const ArticleViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          actions: [CustomPopupMenuButtonForArticleView(isDwonload: true)],
        ),
        SliverPadding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 20),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Can AI really code? Study maps the roadblocks to autonomous software engineering',
                  style: AppTextStyles.headlineLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text('5 hours ago'),
                SizedBox(height: 8),
                AuthorCard(),
                SizedBox(height: 8),
                Image.asset(Assets.assetsImagesMITNewsAICoding),
                SizedBox(height: 32),
                Text(
                  'Imagine a future where artificial intelligence quietly shoulders the drudgery of software development: refactoring tangled code, migrating legacy systems, and hunting down race conditions, so that human engineers can devote themselves to architecture, design, and the genuinely novel problems still beyond a machine’s reach. Recent advances appear to have nudged that future tantalizingly close, but a new paper by researchers at MIT’s Computer Science and Artificial Intelligence Laboratory (CSAIL) and several collaborating institutions argues that this potential future reality demands a hard look at present-day challenges.',
                  style: AppTextStyles.headlineSmall!.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Titled “Challenges and Paths Towards AI for Software Engineering,” the work maps the many software-engineering tasks beyond code generation, identifies current bottlenecks, and highlights research directions to overcome them, aiming to let humans focus on high-level design while routine work is automated. ',
                  style: AppTextStyles.headlineSmall!.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  '"Everyone is talking about how we don’t need programmers anymore, and there’s all this automation now available,” says Armando Solar‑Lezama, MIT professor of electrical engineering and computer science, CSAIL principal investigator, and senior author of the study. “On the one hand, the field has made tremendous progress. We have tools that are way more powerful than any we’ve seen before. But there’s also a long way to go toward really getting the full promise of automation that we would expect.”',
                  style: AppTextStyles.headlineSmall!.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Solar-Lezama argues that popular narratives often shrink software engineering to “the undergrad programming part: someone hands you a spec for a little function and you implement it, or solving LeetCode-style programming interviews.” Real practice is far broader. It includes everyday refactors that polish design, plus sweeping migrations that move millions of lines from COBOL to Java and reshape entire businesses. It requires nonstop testing and analysis — fuzzing, property-based testing, and other methods — to catch concurrency bugs, or patch zero-day flaws. And it involves the maintenance grind: documenting decade-old code, summarizing change histories for new teammates, and reviewing pull requests for style, performance, and security.',
                  style: AppTextStyles.headlineSmall!.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Industry-scale code optimization — think re-tuning GPU kernels or the relentless, multi-layered refinements behind Chrome’s V8 engine — remains stubbornly hard to evaluate. Today’s headline metrics were designed for short, self-contained problems, and while multiple-choice tests still dominate natural-language research, they were never the norm in AI-for-code. The field’s de facto yardstick, SWE-Bench, simply asks a model to patch a GitHub issue: useful, but still akin to the “undergrad programming exercise” paradigm. It touches only a few hundred lines of code, risks data leakage from public repositories, and ignores other real-world contexts — AI-assisted refactors, human–AI pair programming, or performance-critical rewrites that span millions of lines. Until benchmarks expand to capture those higher-stakes scenarios, measuring progress — and thus accelerating it — will remain an open challenge.',
                  style: AppTextStyles.headlineSmall!.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'If measurement is one obstacle, human‑machine communication is another. First author Alex  Gu, an MIT graduate student in electrical engineering and computer science, sees today’s interaction as “a thin line of communication.” When he asks a system to generate code, he often receives a large, unstructured file and even a set of unit tests, yet those tests tend to be superficial. This gap extends to the AI’s ability to effectively use the wider suite of software engineering tools, from debuggers to static analyzers, that humans rely on for precise control and deeper understanding. “I don’t really have much control over what the model writes,” he says. “Without a channel for the AI to expose its own confidence — ‘this part’s correct … this part, maybe double‑check’ — developers risk blindly trusting hallucinated logic that compiles, but collapses in production. Another critical aspect is having the AI know when to defer to the user for clarification.” ',
                  style: AppTextStyles.headlineSmall!.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Scale compounds these difficulties. Current AI models struggle profoundly with large code bases, often spanning millions of lines. Foundation models learn from public GitHub, but “every company’s code base is kind of different and unique,” Gu says, making proprietary coding conventions and specification requirements fundamentally out of distribution. The result is code that looks plausible yet calls non‑existent functions, violates internal style rules, or fails continuous‑integration pipelines. This often leads to AI-generated code that “hallucinates,” meaning it creates content that looks plausible but doesn’t align with the specific internal conventions, helper functions, or architectural patterns of a given company. ',
                  style: AppTextStyles.headlineSmall!.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
