import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rangking_cabang_olahraga/app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rangking_cabang_olahraga/app/widgets/filter_button_widgets.dart';
import 'package:rangking_cabang_olahraga/app/widgets/game_type_filter_bottom_sheet.dart';
import 'package:rangking_cabang_olahraga/app/widgets/podium_widgets.dart';
import 'package:rangking_cabang_olahraga/app/widgets/period_filter_bottom_sheet.dart';
import 'package:rangking_cabang_olahraga/app/widgets/points_widgets.dart';
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
        backgroundColor: const Color(0xFF7A5AF8), // your purple
        foregroundColor: Colors.white,
        centerTitle: true,
        title: InkWell(
          onTap: () {
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
              }
            });
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Summer 2025",
                style: GoogleFonts.rubik(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white, // keep white for app bar
                ),
              ),

              const SizedBox(width: 6),
              // arrow wrapped in circle
              Container(
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Colors.white, // faint circle bg
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.deepPurple,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const PointsBottomSheet(),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF5B3CC4), // darker purple
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.help_outline, color: Colors.white),
              ),
            ),
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

          Column(
            children: [
              // --- Filters ---
              // Replace your existing filter buttons section with this:
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Obx(
                  () => Row(
                    children: [
                      Expanded(
                        child: FilterButton(
                          title:
                              "Sport", // Not used anymore, but kept for compatibility
                          subtitle: controller.sportsDisplayText,
                          onTap: () => _showSportFilter(context),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilterButton(
                          title: "Type", // Not used anymore
                          subtitle: controller.selectedGameType.value,
                          onTap: () => _showGameTypeFilter(context),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilterButton(
                          title: "Region", // Not used anymore
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
                          () => SliverToBoxAdapter(
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Stack(
                                children: [
                                  // Content below
                                  Column(
                                    children: [
                                      const SizedBox(
                                        height: 16,
                                      ), // space for the handle bar
                                      // Top 3 block (if podium is hidden)
                                      if (!controller.isPodiumVisible.value &&
                                          controller.topThree.isNotEmpty)
                                        Column(
                                          children: List.generate(
                                            controller.topThree.length,
                                            (index) {
                                              final topRanking =
                                                  controller.topThree[index];
                                              return RankingItem(
                                                rank: topRanking['rank'],
                                                name: topRanking['name'],
                                                username:
                                                    topRanking['username'],
                                                points: topRanking['points'],
                                                avatar: topRanking['avatar'],
                                                status: topRanking['status'],
                                              );
                                            },
                                          ),
                                        ),

                                      // Main rankings
                                      Column(
                                        children: List.generate(
                                          controller.rankings.length,
                                          (index) {
                                            final ranking =
                                                controller.rankings[index];
                                            return RankingItem(
                                              rank: ranking['rank'],
                                              name: ranking['name'],
                                              username: ranking['username'],
                                              points: ranking['points'],
                                              avatar: ranking['avatar'],
                                              status: ranking['status'],
                                              isHighlighted: false,
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),

                                  // Tiny handle bar (overlayed at the top center)
                                  Positioned(
                                    top: 10,
                                    left: 0,
                                    right: 0,
                                    child: Center(
                                      child: Container(
                                        width: 40,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          color: HexColor("#CACCCF"),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
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

                        const SliverToBoxAdapter(child: SizedBox(height: 0)),
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

  void _showGameTypeFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => GameTypeFilterBottomSheet(
        currentSelection: controller.selectedGameType.value,
      ),
    ).then((selectedType) {
      if (selectedType != null) {
        controller.updateGameType(selectedType);
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
