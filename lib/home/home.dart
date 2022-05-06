import 'package:flutter/material.dart';
import 'package:recruitment_issues/home/home_view_model.dart';
import 'package:recruitment_issues/home/parts/constants.dart';
import 'package:recruitment_issues/home/parts/section_widgets.dart';
import 'package:recruitment_issues/home/parts/sections.dart';
import 'package:recruitment_issues/home/parts/selection_layout.dart';
import 'package:recruitment_issues/home/parts/slivers.dart';
import 'package:stacked/stacked.dart';

const double _kAppBarMinHeight = 90.0;
const double _kAppBarMidHeight = 256.0;

const Duration _kScrollDuration = const Duration(milliseconds: 400);
const Curve _kScrollCurve = Curves.fastOutSlowIn;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController _scrollController = ScrollController();
  final PageController _headingPageController = PageController();
  final PageController _detailsPageController = PageController();
  ScrollPhysics _headingScrollPhysics = const NeverScrollableScrollPhysics();
  ValueNotifier<double> _selectedIndex = ValueNotifier<double>(0.0);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => HomeViewModel(),
        onModelReady: (viewModel) => viewModel.init(),
        builder: (context, viewModel, _) {
          return Scaffold(
            body: _body(viewModel),
          );
        });
  }

  Widget _body(HomeViewModel viewModel) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double statusBarHeight = mediaQueryData.padding.top;
    final double screenHeight = mediaQueryData.size.height;
    final double appBarMaxHeight = screenHeight - statusBarHeight;

    // The scroll offset that reveals the appBarMidHeight appbar.
    final double appBarMidScrollOffset =
        statusBarHeight + appBarMaxHeight - _kAppBarMidHeight;

    return SizedBox.expand(
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          return _handleScrollNotification(notification, appBarMidScrollOffset);
        },
        child: CustomScrollView(
          controller: _scrollController,
          physics:
              SnappingScrollPhysics(midScrollOffset: appBarMidScrollOffset),
          slivers: <Widget>[
            // Start out below the status bar, gradually move to the top of the screen.
            StatusBarPaddingSliver(
              maxHeight: statusBarHeight,
              scrollFactor: 7.0,
            ),
            // Section Headings
            SliverPersistentHeader(
              pinned: true,
              delegate: SliverAppBarDelegate(
                minHeight: _kAppBarMinHeight,
                maxHeight: appBarMaxHeight,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification notification) {
                    return _handlePageNotification(notification,
                        _headingPageController, _detailsPageController);
                  },
                  child: PageView(
                    physics: _headingScrollPhysics,
                    controller: _headingPageController,
                    children: _allHeadingItems(
                        appBarMaxHeight, appBarMidScrollOffset),
                  ),
                ),
              ),
            ),
            // Details
            SliverToBoxAdapter(
              child: SizedBox(
                height: screenHeight + 100.0,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification notification) {
                    return _handlePageNotification(notification,
                        _detailsPageController, _headingPageController);
                  },
                  child: PageView(
                    controller: _detailsPageController,
                    children: allSections.map((Section section) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          section.details,
                          Expanded(
                            flex: 1,
                            child: Container(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _handleScrollNotification(
      ScrollNotification notification, double midScrollOffset) {
    if (notification.depth == 0 && notification is ScrollUpdateNotification) {
      final ScrollPhysics physics =
          _scrollController.position.pixels >= midScrollOffset
              ? const PageScrollPhysics()
              : const NeverScrollableScrollPhysics();
      if (physics != _headingScrollPhysics) {
        setState(() {
          // TODO change method
          _headingScrollPhysics = physics;
        });
      }
    }
    return false;
  }

  bool _handlePageNotification(
    ScrollNotification notification,
    PageController leader,
    PageController follower,
  ) {
    if (notification.depth == 0 && notification is ScrollUpdateNotification) {
      _selectedIndex.value = leader.page!;
      if (follower.page != leader.page) {
        // follower.position.jumpTo(leader.position.pixels);
        follower.position.jumpToWithoutSettling( leader.position.pixels); // ignore: deprecated_member_use
      }
      setState(() {
        // managementController();
      });
    }
    return false;
  }

  List<Widget> _allHeadingItems(double maxHeight, double midScrollOffset) {
    final List<Widget> sectionCards = <Widget>[];
    for (int index = 0; index < allSections.length; index++) {
      sectionCards.add(LayoutId(
        id: 'card$index',
        child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: SectionCard(section: allSections[index]),
            onTapUp: (TapUpDetails details) {
              final double xOffset = details.globalPosition.dx;
              setState(() {
                _maybeScroll(midScrollOffset, index, xOffset);
              });
            }),
      ));
    }
    final List<Widget> headings = <Widget>[];
    for (int index = 0; index < allSections.length; index++) {
      headings.add(Container(
        color: field_color,
        child: ClipRect(
          child: AllSectionsView(
            sectionIndex: index,
            sections: allSections,
            selectedIndex: _selectedIndex,
            minHeight: _kAppBarMinHeight,
            midHeight: _kAppBarMidHeight,
            maxHeight: maxHeight,
            sectionCards: sectionCards,
          ),
        ),
      ));
    }
    return headings;
  }

  void _maybeScroll(double midScrollOffset, int pageIndex, double xOffset) {
    if (_scrollController.offset < midScrollOffset) {
      // Scroll the overall list to the point where only one section card shows.
      // At the same time scroll the PageViews to the page at pageIndex.
      _headingPageController.animateToPage(pageIndex,
          curve: _kScrollCurve, duration: _kScrollDuration);
      _scrollController.animateTo(midScrollOffset,
          curve: _kScrollCurve, duration: _kScrollDuration);
    } else {
      // One one section card is showing: scroll one page forward or back.
      final double centerX =
          _headingPageController.position.viewportDimension / 2.0;
      final int newPageIndex =
          xOffset > centerX ? pageIndex + 1 : pageIndex - 1;
      _headingPageController.animateToPage(newPageIndex,
          curve: _kScrollCurve, duration: _kScrollDuration);
    }
  }

// void managementController(HomeViewModel viewModel) {
//   int selectedIndexInt = viewModel.selectedIndex.value.round();
//   isWithManagement = selectedIndexInt == managedIndexLogistics ||
//       selectedIndexInt == managedIndexStaffing ||
//       selectedIndexInt == managedIndexProgress ||
//       selectedIndexInt == managedIndexWave;
// }
}
