import 'package:rangking_cabang_olahraga/app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rangking_cabang_olahraga/app/widgets/filter_button_widgets.dart';
import 'package:rangking_cabang_olahraga/app/widgets/podium_widgets.dart';
import 'package:rangking_cabang_olahraga/app/widgets/preiod_filter_bottom_sheet.dart';
import 'package:rangking_cabang_olahraga/app/widgets/rangking_item_widgets.dart';
import 'package:rangking_cabang_olahraga/app/widgets/region_filter_bottom_sheet.dart';
import 'package:rangking_cabang_olahraga/app/widgets/sport_filter_bottom_sheet.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    AuthService authC = Get.find<AuthService>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome ${authC.userRole.value.toUpperCase()}'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.refreshData(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authC.logout(),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple, Colors.purple],
          ),
        ),
        child: Column(
          children: [
            // Filter Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: FilterButton(
                        title: "Periode",
                        subtitle: controller.selectedPeriod.value,
                        onTap: () => _showPeriodFilter(context),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilterButton(
                        title: "Cabor",
                        subtitle: controller.sportsDisplayText,
                        onTap: () => _showSportFilter(context),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilterButton(
                        title: "Region",
                        subtitle: controller.regionsDisplayText,
                        onTap: () => _showRegionFilter(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Scrollable Content with Disappearing Podium
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.deepPurple,
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => controller.refreshData(),
                  child: ScrollablePodiumList(controller: controller),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showPeriodFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => PeriodFilterBottomSheet(
        currentSelection: controller.selectedPeriod.value,
      ),
    ).then((selectedPeriod) {
      if (selectedPeriod != null) {
        controller.updatePeriod(selectedPeriod);
        Get.snackbar(
          "Filter Applied",
          "Period updated to: $selectedPeriod",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.deepPurple,
          colorText: Colors.white,
        );
      }
    });
  }

  void _showSportFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => SportFilterBottomSheet(
        currentSelections: controller.selectedSports.toList(),
      ),
    ).then((selectedSports) {
      if (selectedSports != null) {
        controller.updateSports(selectedSports);
        Get.snackbar(
          "Filter Applied",
          "Sports updated: ${controller.sportsDisplayText}",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.deepPurple,
          colorText: Colors.white,
        );
      }
    });
  }

  void _showRegionFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => RegionFilterBottomSheet(
        currentSelections: controller.selectedRegions.toList(),
      ),
    ).then((selectedRegions) {
      if (selectedRegions != null) {
        controller.updateRegions(selectedRegions);
        Get.snackbar(
          "Filter Applied",
          "Regions updated: ${controller.regionsDisplayText}",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.deepPurple,
          colorText: Colors.white,
        );
      }
    });
  }
}

// NEW: Scrollable Podium List Widget with Disappearing Logic
class ScrollablePodiumList extends StatefulWidget {
  final dynamic controller;

  const ScrollablePodiumList({super.key, required this.controller});

  @override
  State<ScrollablePodiumList> createState() => _ScrollablePodiumListState();
}

class _ScrollablePodiumListState extends State<ScrollablePodiumList> {
  final ScrollController _scrollController = ScrollController();
  bool _isPodiumVisible = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    // Threshold is 0 - disappears immediately when scrolled
    if (_scrollController.offset > 0) {
      if (_isPodiumVisible) {
        setState(() {
          _isPodiumVisible = false;
        });
      }
    } else {
      if (!_isPodiumVisible) {
        setState(() {
          _isPodiumVisible = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // Animated Podium Section
        SliverToBoxAdapter(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _isPodiumVisible ? 350 : 0, // Podium height + container
            child: _isPodiumVisible
                ? Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        // Dynamic Podium
                        widget.controller.topThree.isNotEmpty
                            ? DynamicPodiumWidget(
                                topThree: widget.controller.topThree,
                              )
                            : const PodiumWidget(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  )
                : Container(),
          ),
        ),

        // Add top padding only when podium is hidden
        if (!_isPodiumVisible)
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              height: 30, // Top padding when podium is gone
            ),
          ),

        // Show top 3 in list only when podium is hidden
        if (!_isPodiumVisible && widget.controller.topThree.isNotEmpty)
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              if (index >= widget.controller.topThree.length) return null;

              final topRanking = widget.controller.topThree[index];
              return Container(
                color: Colors.white,
                child: RankingItem(
                  rank: topRanking['rank'],
                  name: topRanking['name'],
                  username: topRanking['username'],
                  points: topRanking['points'],
                  avatar: topRanking['avatar'],
                  isHighlighted: index == 0, // Highlight #1 when in list
                ),
              );
            }, childCount: widget.controller.topThree.length),
          ),

        // Regular rankings (rank 4+)
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            if (index >= widget.controller.rankings.length) return null;

            final ranking = widget.controller.rankings[index];
            return Container(
              color: Colors.white,
              child: RankingItem(
                rank: ranking['rank'],
                name: ranking['name'],
                username: ranking['username'],
                points: ranking['points'],
                avatar: ranking['avatar'],
                isHighlighted: false,
              ),
            );
          }, childCount: widget.controller.rankings.length),
        ),

        // Bottom padding for better scrolling
        const SliverToBoxAdapter(child: SizedBox(height: 50)),

        // Empty state
        if (widget.controller.rankings.isEmpty &&
            widget.controller.topThree.isEmpty &&
            !widget.controller.isLoading.value)
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              height: 200,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      "No rankings found",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    Text(
                      "Try adjusting your filters",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// Dynamic Podium Widget (same as your original)
class DynamicPodiumWidget extends StatelessWidget {
  final List<Map<String, dynamic>> topThree;

  const DynamicPodiumWidget({super.key, required this.topThree});

  @override
  Widget build(BuildContext context) {
    if (topThree.length < 3) {
      return const PodiumWidget();
    }

    return Container(
      height: 300,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 2nd Place
          if (topThree.length > 1)
            PodiumItem(
              rank: 2,
              name: topThree[1]['name'],
              points: topThree[1]['points'],
              height: 120,
              color: Colors.grey.shade300,
              avatar: topThree[1]['avatar'],
            ),
          const SizedBox(width: 20),

          // 1st Place
          PodiumItem(
            rank: 1,
            name: topThree[0]['name'],
            points: topThree[0]['points'],
            height: 150,
            color: Colors.amber.shade300,
            avatar: topThree[0]['avatar'],
          ),
          const SizedBox(width: 20),

          // 3rd Place
          if (topThree.length > 2)
            PodiumItem(
              rank: 3,
              name: topThree[2]['name'],
              points: topThree[2]['points'],
              height: 100,
              color: Colors.orange.shade300,
              avatar: topThree[2]['avatar'],
            ),
        ],
      ),
    );
  }
}

// Podium Item (same as your original)
class PodiumItem extends StatelessWidget {
  final int rank;
  final String name;
  final String points;
  final double height;
  final Color color;
  final String avatar;

  const PodiumItem({
    super.key,
    required this.rank,
    required this.name,
    required this.points,
    required this.height,
    required this.color,
    required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Crown for 1st place
        if (rank == 1)
          Container(
            margin: const EdgeInsets.only(bottom: 4),
            child: const Icon(
              Icons.emoji_events,
              color: Colors.amber,
              size: 24,
            ),
          ),

        // Avatar
        CircleAvatar(radius: 25, backgroundImage: NetworkImage(avatar)),
        const SizedBox(height: 8),

        // Name
        SizedBox(
          width: 80,
          child: Text(
            name,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 4),

        // Points
        Text(
          points,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),

        // Podium
        Container(
          width: 80,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Center(
            child: Text(
              '$rank',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
