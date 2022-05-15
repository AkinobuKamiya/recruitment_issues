import 'package:flutter/material.dart';
import 'package:recruitment_issues/home/widgets/image_carousel_list/list_item.dart';
import 'package:recruitment_issues/home/widgets/switch_animation/child/animated_positioned_sample_view_model.dart';
import 'package:recruitment_issues/home/widgets/switch_animation/child/animated_switcher_sample_view_model.dart';
import 'package:stacked/stacked.dart';

class AnimatedPositionedSample extends StatelessWidget {
  const AnimatedPositionedSample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AnimatedPositionedSampleViewModel>.reactive(
      viewModelBuilder: () => AnimatedPositionedSampleViewModel(),
      builder: (context, viewModel, _) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.refresh),
            onPressed: () => viewModel.onPress(),
          ),
          body: Container(
            alignment: Alignment.center,
            child: Stack(
              children: [
                Image.asset(
                  '9-0.jpg',
                  package: ImagePackage.shrine_images.package,
                  color: const Color.fromRGBO(255, 255, 255, 0.075),
                  colorBlendMode: BlendMode.modulate,
                ),
                AnimatedPositioned(
                  top: 0,
                  left: 0,
                  width: viewModel.width,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  child: Image.asset('9-0.jpg',
                      package: ImagePackage.shrine_images.package),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
