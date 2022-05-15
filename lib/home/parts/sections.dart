// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Raw data for the animation demo.

import 'package:flutter/material.dart';
import 'package:recruitment_issues/home/contents_view.dart';
import 'package:recruitment_issues/home/parts/constants.dart';
import 'package:recruitment_issues/home/widgets/image_carousel_list/image_carousel_list.dart';
import 'package:recruitment_issues/home/widgets/switch_animation/switch_animation.dart';

const String _kGalleryAssetsPackage = 'shrine_images';

class Section {
  const Section({
    required this.title,
    required this.backgroundAsset,
    required this.backgroundAssetPackage,
    required this.leftColor,
    required this.rightColor,
    required this.details,
  });

  final String title;
  final String backgroundAsset;
  final String backgroundAssetPackage;
  final Color leftColor;
  final Color rightColor;
  final Widget details;

  @override
  bool operator ==(Object other) {
    if (other is! Section) return false;
    final Section otherSection = other;
    return title == otherSection.title;
  }

  @override
  int get hashCode => title.hashCode;
}

final List<Section> allSections = <Section>[
  const Section(
    title: '目次',
    leftColor: stopwatch_color,
    rightColor: stopwatch_color,
    backgroundAsset: '5-0.jpg',
    backgroundAssetPackage: _kGalleryAssetsPackage,
    details: ContentsView(contentsType: type.tableOfContents),
  ),
  const Section(
    title: '画像を用いたカルーセル',
    leftColor: logistics_color,
    rightColor: logistics_color,
    backgroundAsset: '1-0.jpg',
    backgroundAssetPackage: _kGalleryAssetsPackage,
    details: ImageCarouselList(),
  ),
  const Section(
    title: 'ボタンによるアニメーション切り替え',
    leftColor: stopwatch_color,
    rightColor: stopwatch_color,
    backgroundAsset: '0-0.jpg',
    backgroundAssetPackage: _kGalleryAssetsPackage,
    details: SwitchAnimation(),
  ),
  const Section(
    title: 'その他開発事例\n(箇条書き羅列)',
    leftColor: staffing_color,
    rightColor: staffing_color,
    backgroundAsset: '9-0.jpg',
    backgroundAssetPackage: _kGalleryAssetsPackage,
    details: ContentsView(contentsType: type.otherDevelopment),
  ),
];
