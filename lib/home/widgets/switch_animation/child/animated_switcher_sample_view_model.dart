import 'package:recruitment_issues/base/base_change_notifier.dart';
import 'package:recruitment_issues/home/widgets/image_carousel_list/list_item.dart';

class AnimatedSwitcherSampleViewModel extends BaseChangeNotifier {
  String? text;

  final List<AnimatedItem> animatedItems = [
    AnimatedItem('バックパック', '0-0.jpg', ImagePackage.shrine_images),
    AnimatedItem('ベルト', '2-0.jpg', ImagePackage.shrine_images),
    AnimatedItem('くつした', '5-0.jpg', ImagePackage.shrine_images),
    AnimatedItem('サングラス', '1-0.jpg', ImagePackage.shrine_images),
  ];

  late AnimatedItem selectedItem;

  int _selectedIndex = 0;

  void init() {
    selectedItem = animatedItems[_selectedIndex];
  }

  void onPress() {
    _selectedIndex++;
    if (_selectedIndex > animatedItems.length - 1) {
      _selectedIndex = 0;
    }

    selectedItem = animatedItems[_selectedIndex];
    notifyListeners();
  }

  String get title => text ?? '';
}

class AnimatedItem {
  AnimatedItem(this.title, this.imageAsset, this.imagePackage);

  String title;
  String imageAsset;
  ImagePackage imagePackage;
}
