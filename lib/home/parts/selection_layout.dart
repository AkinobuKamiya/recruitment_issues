import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:recruitment_issues/home/parts/section_widgets.dart';
import 'package:recruitment_issues/home/parts/sections.dart';

// Support snapping scrolls to the midScrollOffset: the point at which the
// app bar's height is _kAppBarMidHeight and only one section heading is
// visible.
const double kSectionIndicatorWidth = 32.0;

class SnappingScrollPhysics extends ClampingScrollPhysics {
  const SnappingScrollPhysics({
    ScrollPhysics? parent,
    required this.midScrollOffset,
  }) : super(parent: parent);

  final double midScrollOffset;

  @override
  SnappingScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return SnappingScrollPhysics(
        parent: buildParent(ancestor), midScrollOffset: midScrollOffset);
  }

  Simulation _toMidScrollOffsetSimulation(double offset, double dragVelocity) {
    final double velocity = math.max(dragVelocity, minFlingVelocity);
    return ScrollSpringSimulation(spring, offset, midScrollOffset, velocity,
        tolerance: tolerance);
  }

  Simulation _toZeroScrollOffsetSimulation(double offset, double dragVelocity) {
    final double velocity = math.max(dragVelocity, minFlingVelocity);
    return ScrollSpringSimulation(spring, offset, 0.0, velocity,
        tolerance: tolerance);
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double dragVelocity) {
    final Simulation? simulation =
        super.createBallisticSimulation(position, dragVelocity);
    final double offset = position.pixels;

    if (simulation != null) {
      // The drag ended with sufficient velocity to trigger creating a simulation.
      // If the simulation is headed up towards midScrollOffset but will not reach it,
      // then snap it there. Similarly if the simulation is headed down past
      // midScrollOffset but will not reach zero, then snap it to zero.
      final double simulationEnd = simulation.x(double.infinity);
      if (simulationEnd >= midScrollOffset) return simulation;
      if (dragVelocity > 0.0) {
        return _toMidScrollOffsetSimulation(offset, dragVelocity);
      }
      if (dragVelocity < 0.0) {
        return _toZeroScrollOffsetSimulation(offset, dragVelocity);
      }
    } else {
      // The user ended the drag with little or no velocity. If they
      // didn't leave the offset above midScrollOffset, then
      // snap to midScrollOffset if they're more than halfway there,
      // otherwise snap to zero.
      final double snapThreshold = midScrollOffset / 2.0;
      if (offset >= snapThreshold && offset < midScrollOffset) {
        return _toMidScrollOffsetSimulation(offset, dragVelocity);
      }
      if (offset > 0.0 && offset < snapThreshold) {
        return _toZeroScrollOffsetSimulation(offset, dragVelocity);
      }
    }
    return simulation;
  }
}

class AllSectionsLayout extends MultiChildLayoutDelegate {
  AllSectionsLayout({
    required this.translation,
    required this.tColumnToRow,
    required this.tCollapsed,
    required this.cardCount,
    required this.selectedIndex,
  });

  final Alignment translation;
  final double tColumnToRow;
  final double tCollapsed;
  final int cardCount;
  final double selectedIndex;

  Rect? _interpolateRect(Rect begin, Rect end) {
    return Rect.lerp(begin, end, tColumnToRow);
  }

  Offset _interpolatePoint(Offset begin, Offset end) {
    return Offset.lerp(begin, end, tColumnToRow)!;
  }

  @override
  void performLayout(Size size) {
    final double columnCardX = size.width / 5.0;
    final double columnCardWidth = size.width - columnCardX;
    final double columnCardHeight = size.height / cardCount;
    final double rowCardWidth = size.width;
    final Offset offset = translation.alongSize(size);
    double columnCardY = 0.0;
    double rowCardX = -(selectedIndex * rowCardWidth);

    // When tCollapsed > 0 the titles spread apart
    final double columnTitleX = size.width / 10.0;
    final double rowTitleWidth = size.width * ((1 + tCollapsed) / 2.25);
    double rowTitleX =
        (size.width - rowTitleWidth) / 2.0 - selectedIndex * rowTitleWidth;

    // When tCollapsed > 0, the indicators move closer together
    //final double rowIndicatorWidth = 48.0 + (1.0 - tCollapsed) * (rowTitleWidth - 48.0);
    const double paddedSectionIndicatorWidth = kSectionIndicatorWidth + 8.0;
    final double rowIndicatorWidth = paddedSectionIndicatorWidth +
        (1.0 - tCollapsed) * (rowTitleWidth - paddedSectionIndicatorWidth);
    double rowIndicatorX = (size.width - rowIndicatorWidth) / 2.0 -
        selectedIndex * rowIndicatorWidth;

    // Compute the size and origin of each card, title, and indicator for the maxHeight
    // "column" layout, and the midHeight "row" layout. The actual layout is just the
    // interpolated value between the column and row layouts for t.
    for (int index = 0; index < cardCount; index++) {
      // Layout the card for index.
      final Rect columnCardRect = Rect.fromLTWH(
          columnCardX, columnCardY, columnCardWidth, columnCardHeight);
      final Rect rowCardRect =
          Rect.fromLTWH(rowCardX, 0.0, rowCardWidth, size.height);
      final Rect cardRect =
          _interpolateRect(columnCardRect, rowCardRect)!.shift(offset);
      final String cardId = 'card$index';
      if (hasChild(cardId)) {
        layoutChild(cardId, BoxConstraints.tight(cardRect.size));
        positionChild(cardId, cardRect.topLeft);
      }

      // Layout the title for index.
      final Size titleSize =
          layoutChild('title$index', BoxConstraints.loose(cardRect.size));
      final double columnTitleY =
          columnCardRect.centerLeft.dy - titleSize.height / 2.0;
      final double rowTitleY =
          rowCardRect.centerLeft.dy - titleSize.height / 2.0;
      final double centeredRowTitleX =
          rowTitleX + (rowTitleWidth - titleSize.width) / 2.0;
      final Offset columnTitleOrigin = Offset(columnTitleX, columnTitleY);
      final Offset rowTitleOrigin = Offset(centeredRowTitleX, rowTitleY);
      final Offset titleOrigin =
          _interpolatePoint(columnTitleOrigin, rowTitleOrigin);
      positionChild('title$index', titleOrigin + offset);

      // Layout the selection indicator for index.
      final Size indicatorSize =
          layoutChild('indicator$index', BoxConstraints.loose(cardRect.size));
      final double columnIndicatorX =
          cardRect.centerRight.dx - indicatorSize.width - 16.0;
      final double columnIndicatorY =
          cardRect.bottomRight.dy - indicatorSize.height - 16.0;
      final Offset columnIndicatorOrigin =
          Offset(columnIndicatorX, columnIndicatorY);
      final Rect titleRect =
          Rect.fromPoints(titleOrigin, titleSize.bottomRight(titleOrigin));
      final double centeredRowIndicatorX =
          rowIndicatorX + (rowIndicatorWidth - indicatorSize.width) / 2.0;
      final double rowIndicatorY = titleRect.bottomCenter.dy + 16.0;
      final Offset rowIndicatorOrigin =
          Offset(centeredRowIndicatorX, rowIndicatorY);
      final Offset? indicatorOrigin =
          _interpolatePoint(columnIndicatorOrigin, rowIndicatorOrigin);
      positionChild('indicator$index', indicatorOrigin! + offset);

      columnCardY += columnCardHeight;
      rowCardX += rowCardWidth;
      rowTitleX += rowTitleWidth;
      rowIndicatorX += rowIndicatorWidth;
    }
  }

  @override
  bool shouldRelayout(AllSectionsLayout oldDelegate) {
    return tColumnToRow != oldDelegate.tColumnToRow ||
        cardCount != oldDelegate.cardCount ||
        selectedIndex != oldDelegate.selectedIndex;
  }
}

class AllSectionsView extends AnimatedWidget {
  AllSectionsView({
    Key? key,
    required this.sectionIndex,
    required this.sections,
    required this.selectedIndex,
    required this.minHeight,
    required this.midHeight,
    required this.maxHeight,
    this.sectionCards = const <Widget>[],
  })  : assert(sectionCards.length == sections.length),
        assert(sectionIndex >= 0 && sectionIndex < sections.length),
        assert(selectedIndex.value >= 0.0 &&
            selectedIndex.value < sections.length.toDouble()),
        super(key: key, listenable: selectedIndex);

  final int sectionIndex;
  final List<Section> sections;
  final ValueNotifier<double> selectedIndex;
  final double minHeight;
  final double midHeight;
  final double maxHeight;
  final List<Widget> sectionCards;

  double _selectedIndexDelta(int index) {
    return (index.toDouble() - selectedIndex.value).abs().clamp(0.0, 1.0);
  }

  Widget _build(BuildContext context, BoxConstraints constraints) {
    final Size size = constraints.biggest;

    // The layout's progress from from a column to a row. Its value is
    // 0.0 when size.height equals the maxHeight, 1.0 when the size.height
    // equals the midHeight.
    // The layout's progress from from a column to a row. Its value is
    // 0.0 when size.height equals the maxHeight, 1.0 when the size.height
    // equals the midHeight.
    final double tColumnToRow = 1.0 -
        ((size.height - midHeight) / (maxHeight - midHeight)).clamp(0.0, 1.0);

    // The layout's progress from from the midHeight row layout to
    // a minHeight row layout. Its value is 0.0 when size.height equals
    // midHeight and 1.0 when size.height equals minHeight.
    final double tCollapsed = 1.0 -
        ((size.height - minHeight) / (midHeight - minHeight)).clamp(0.0, 1.0);

    double _indicatorOpacity(int index) {
      return 1.0 - _selectedIndexDelta(index) * 0.5;
    }

    double _titleOpacity(int index) {
      return 1.0 - _selectedIndexDelta(index) * tColumnToRow * 0.5;
    }

    double _titleScale(int index) {
      return 1.0 - _selectedIndexDelta(index) * tColumnToRow * 0.15;
    }

    final List<Widget> children = List<Widget>.from(sectionCards);

    for (int index = 0; index < sections.length; index++) {
      final Section section = sections[index];
      children.add(LayoutId(
        id: 'title$index',
        child: SectionTitle(
          section: section,
          scale: _titleScale(index),
          opacity: _titleOpacity(index),
        ),
      ));
    }

    for (int index = 0; index < sections.length; index++) {
      children.add(LayoutId(
        id: 'indicator$index',
        child: SectionIndicator(
          opacity: _indicatorOpacity(index),
        ),
      ));
    }

    return CustomMultiChildLayout(
      delegate: AllSectionsLayout(
        translation:
            Alignment((selectedIndex.value - sectionIndex) * 2.0 - 1.0, -1.0),
        tColumnToRow: tColumnToRow,
        tCollapsed: tCollapsed,
        cardCount: sections.length,
        selectedIndex: selectedIndex.value,
      ),
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: _build);
  }
}
