import 'package:flutter/material.dart';
import 'package:recruitment_issues/home/widgets/image_carousel_list/list_item.dart';
import 'package:recruitment_issues/home/widgets/switch_animation/child/animated_switcher_sample_view_model.dart';
import 'package:stacked/stacked.dart';

class AnimatedSwitcherSample extends StatelessWidget {
  const AnimatedSwitcherSample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AnimatedSwitcherSampleViewModel>.reactive(
      viewModelBuilder: () => AnimatedSwitcherSampleViewModel(),
      onModelReady: (viewModel) => viewModel.init(),
      builder: (context, viewModel, _) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.refresh),
            onPressed: () => viewModel.onPress(),
          ),
          body: Container(
            alignment: Alignment.center,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation) {
                return ScaleTransition(child: child, scale: animation);
              },
              child: Column(
                key: ValueKey<String>(viewModel.selectedItem.title),
                children: [
                  Card(
                    child: Image.asset(
                      viewModel.selectedItem.imageAsset,
                      package: viewModel.selectedItem.imagePackage.package,
                      colorBlendMode: BlendMode.modulate,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(viewModel.selectedItem.title),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
