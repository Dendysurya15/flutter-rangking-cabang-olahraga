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
import 'package:rangking_cabang_olahraga/app/widgets/user_point_card.dart';
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
          child: Obx(
            () => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  controller.selectedPeriod.value, // ✅ dynamic now
                  style: GoogleFonts.rubik(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.all(1),
                  decoration: const BoxDecoration(
                    color: Colors.white,
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
                padding: const EdgeInsets.only(left: 16, right: 16),
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
                          subtitle: controller.regionDisplayText,
                          onTap: () => _showRegionFilter(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: UserPointCard(),
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
                    child: // Replace your entire CustomScrollView slivers section with this:
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: CustomScrollView(
                        controller: controller.scrollController,
                        slivers: [
                          // Podium - keep space but make invisible (KEEP THIS AS IS!)
                          Obx(
                            () => SliverToBoxAdapter(
                              child: AnimatedOpacity(
                                opacity: controller.isPodiumVisible.value
                                    ? 1.0
                                    : 0.0,
                                duration: const Duration(milliseconds: 300),
                                child: const SizedBox(
                                  height: 300,
                                  child: PodiumWidget(),
                                ),
                              ),
                            ),
                          ),

                          Obx(() {
                            final hasData =
                                controller.rankings.isNotEmpty ||
                                controller.topThree.isNotEmpty;

                            if (hasData) {
                              // ✅ Rankings exist (KEEP YOUR EXISTING LOGIC!)
                              return SliverToBoxAdapter(
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
                                      Column(
                                        children: [
                                          const SizedBox(
                                            height: 16,
                                          ), // space for handle bar
                                          // Top 3 block (if podium is hidden)
                                          if (!controller
                                                  .isPodiumVisible
                                                  .value &&
                                              controller.topThree.isNotEmpty)
                                            Column(
                                              children: List.generate(
                                                controller.topThree.length,
                                                (index) {
                                                  final topRanking = controller
                                                      .topThree[index];
                                                  return RankingItem(
                                                    rank: topRanking['rank'],
                                                    name: topRanking['name'],
                                                    username:
                                                        topRanking['username'],
                                                    points:
                                                        topRanking['points'],
                                                    avatar:
                                                        topRanking['avatar'],
                                                    secondAvatar:
                                                        topRanking['secondAvatar'] ??
                                                        '', // ADD THIS
                                                    status:
                                                        topRanking['status'],
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
                                                  secondAvatar:
                                                      ranking['secondAvatar'] ??
                                                      '', // ADD THIS
                                                  status: ranking['status'],
                                                  isHighlighted: false,
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),

                                      // Tiny handle bar
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
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              // ❌ No data
                              return SliverFillRemaining(
                                child: Container(
                                  color: Colors.white,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.description_outlined,
                                          size: 80,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(height: 24),
                                        const Text(
                                          "Leaderboard belum tersedia",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        const Text(
                                          "Jadilah yang pertama untuk memulai\npertandingan dan raih posisi terbaikmu!",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                        ElevatedButton(
                                          onPressed: () {
                                            // 👉 TODO: add action here
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.deepPurple,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 24,
                                              vertical: 12,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text("Mulai Tanding"),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                          }),

                          // ADD THIS: Fill remaining space with white background when there's data
                          Obx(() {
                            final hasData =
                                controller.rankings.isNotEmpty ||
                                controller.topThree.isNotEmpty;

                            if (hasData) {
                              return SliverFillRemaining(
                                hasScrollBody: false,
                                child: Container(
                                  color: Colors
                                      .white, // Just white background, nothing else
                                ),
                              );
                            } else {
                              return const SliverToBoxAdapter(
                                child: SizedBox.shrink(),
                              );
                            }
                          }),
                        ],
                      ),
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
        currentSelections: controller.selectedRegions
            .toList(), // Pass current selections
      ),
    ).then((selectedRegions) {
      if (selectedRegions != null && selectedRegions is List<String>) {
        controller.updateRegions(selectedRegions); // Update with list
        Get.snackbar(
          "Filter Applied",
          selectedRegions.isEmpty
              ? "All regions selected"
              : "Regions updated: ${controller.regionDisplayText}",
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
