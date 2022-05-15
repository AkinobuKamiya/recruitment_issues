import 'package:flutter/material.dart';
import 'package:recruitment_issues/home/widgets/switch_animation/child/animated_positioned_sample.dart';
import 'package:recruitment_issues/home/widgets/switch_animation/child/animated_switcher_sample.dart';
import 'package:recruitment_issues/home/widgets/switch_animation/tab_item.dart';

class SwitchAnimation extends StatefulWidget {
  const SwitchAnimation({Key? key}) : super(key: key);

  @override
  _SwitchAnimationState createState() => _SwitchAnimationState();
}

class _SwitchAnimationState extends State<SwitchAnimation> {
  final List<TabItem> list = [
    TabItem('AnimatedSwitcher', const AnimatedSwitcherSample()),
    TabItem('AnimatedPositioned', const AnimatedPositionedSample()),
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: DefaultTabController(
              length: list.length,
              child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: TabBar(
                      tabs: list
                          .map((tabItem) => Center(
                              child: Text(tabItem.name,
                                  style: const TextStyle(color: Colors.black))))
                          .toList()),
                ),
                body: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: list.map((tabItem) => tabItem.widget).toList(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
