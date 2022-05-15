class ListItem {
  ListItem(this.title, this.imageAsset, this.imagePackage);

  String title;
  String imageAsset;
  ImagePackage imagePackage;
}

enum ImagePackage {
  shrine_images,
}

extension ImagePackageExtension on ImagePackage {
  static final packages = {
    ImagePackage.shrine_images: 'shrine_images'
  };

  String get package => packages[this] ?? '';
}