import 'package:hexcolor/hexcolor.dart';
import 'package:rangking_cabang_olahraga/app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rangking_cabang_olahraga/app/widgets/filter_button_widgets.dart';
import 'package:rangking_cabang_olahraga/app/widgets/podium_widgets.dart';
import 'package:rangking_cabang_olahraga/app/widgets/period_filter_bottom_sheet.dart';
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
        title: Obx(() => Text('Welcome ${authC.userRole.value.toUpperCase()}')),
        centerTitle: true,
        backgroundColor: HexColor("#7A5AF8"),
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
      body: Stack(
        children: [
          // Solid purple background
          Container(
            color: HexColor("#7A5AF8"), // purple (adjust as needed)
          ),

          // Concentric circles
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 2,
                    ),
                  ),
                ),
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 2,
                    ),
                  ),
                ),
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Your actual content
          Column(
            children: [
              // --- Filters ---
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

              // --- Scrollable Content ---
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => controller.refreshData(),
                    child: CustomScrollView(
                      controller: controller.scrollController,
                      slivers: [
                        // Podium - keep space but make invisible
                        Obx(
                          () => SliverToBoxAdapter(
                            child: AnimatedOpacity(
                              opacity: controller.isPodiumVisible.value
                                  ? 1.0
                                  : 0.0,
                              duration: const Duration(milliseconds: 300),
                              child: const SizedBox(
                                height: 350,
                                child:
                                    PodiumWidget(), // No parameters needed - uses GetX controller directly
                              ),
                            ),
                          ),
                        ),

                        Obx(
                          () =>
                              !controller.isPodiumVisible.value &&
                                  controller.topThree.isNotEmpty
                              ? SliverList(
                                  delegate: SliverChildBuilderDelegate((
                                    context,
                                    index,
                                  ) {
                                    if (index >= controller.topThree.length)
                                      return null;

                                    final topRanking =
                                        controller.topThree[index];
                                    return Container(
                                      color: Colors.white,
                                      child: RankingItem(
                                        rank: topRanking['rank'],
                                        name: topRanking['name'],
                                        username: topRanking['username'],
                                        points: topRanking['points'],
                                        status: topRanking['status'],
                                        avatar: topRanking['avatar'],
                                      ),
                                    );
                                  }, childCount: controller.topThree.length),
                                )
                              : const SliverToBoxAdapter(child: SizedBox()),
                        ),

                        // Regular rankings (rank 4+ or all rankings if no top 3)
                        Obx(
                          () => SliverList(
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              if (index >= controller.rankings.length) {
                                return null;
                              }
                              final ranking = controller.rankings[index];
                              return Container(
                                color: Colors.white,
                                child: RankingItem(
                                  rank: ranking['rank'],
                                  name: ranking['name'],
                                  username: ranking['username'],
                                  points: ranking['points'],
                                  avatar: ranking['avatar'],
                                  status: ranking['status'],
                                  isHighlighted: false,
                                ),
                              );
                            }, childCount: controller.rankings.length),
                          ),
                        ),

                        // Empty state
                        Obx(
                          () =>
                              controller.rankings.isEmpty &&
                                  controller.topThree.isEmpty &&
                                  !controller.isLoading.value
                              ? SliverToBoxAdapter(
                                  child: Container(
                                    color: Colors.white,
                                    height: 200,
                                    child: const Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.search_off,
                                            size: 64,
                                            color: Colors.grey,
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                            "No rankings found",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            "Try adjusting your filters",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : const SliverToBoxAdapter(child: SizedBox()),
                        ),

                        const SliverToBoxAdapter(child: SizedBox(height: 50)),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ],
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
