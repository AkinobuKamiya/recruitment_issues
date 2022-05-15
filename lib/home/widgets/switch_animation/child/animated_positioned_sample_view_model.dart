import 'package:recruitment_issues/base/base_change_notifier.dart';

class AnimatedPositionedSampleViewModel extends BaseChangeNotifier {
  bool _shrinked = true;

  void onPress() {
    _shrinked = !_shrinked;
    notifyListeners();
  }

  double get width => _shrinked ? 50 : 300;
}
