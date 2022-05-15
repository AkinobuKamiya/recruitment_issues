import 'package:flutter/material.dart';
import 'package:recruitment_issues/home/widgets/image_carousel_list/list_item.dart';

class ImageCarouselList extends StatefulWidget {
  const ImageCarouselList({Key? key}) : super(key: key);

  @override
  _ImageCarouselListState createState() => _ImageCarouselListState();
}

class _ImageCarouselListState extends State<ImageCarouselList> {
  final List<ListItem> list = [
    ListItem('バックパック', '0-0.jpg', ImagePackage.shrine_images),
    ListItem('サングラス', '1-0.jpg', ImagePackage.shrine_images),
    ListItem('ベルト', '2-0.jpg', ImagePackage.shrine_images),
    ListItem('アクセサリー', '3-0.jpg', ImagePackage.shrine_images),
  ];

  @override
  Widget build(BuildContext context) {
    return
        Expanded(child:LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: list.length,
              itemBuilder: _buildVerticalItem,
            ));
      },),
      // ),
    );
  }

  Widget _buildVerticalItem(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: SizedBox(
        height: 320,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'カルーセルその${index + 1}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            _buildHorizontalItem(context, index),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalItem(BuildContext context, int verticalIndex) {
    return SizedBox(
      height: 240,
      child: PageView.builder(
          controller: PageController(viewportFraction: 0.8),
          itemCount: list.length,
          itemBuilder: _buildHorizontalView),
    );
  }

  Widget _buildHorizontalView(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        child: Image.asset(
          list[index].imageAsset,
          package: list[index].imagePackage.package,
          colorBlendMode: BlendMode.modulate,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
