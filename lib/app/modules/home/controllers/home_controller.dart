import 'package:get/get.dart';
import 'package:flutter/material.dart';

class HomeController extends GetxController {
  // --- Filters ---
  var selectedPeriod = "Summer 2025".obs;
  var selectedSports = <String>["Tenis Meja"].obs;
  var selectedRegions = <String>["All Region"].obs;

  // --- Rankings ---
  var rankings = <Map<String, dynamic>>[].obs;
  var topThree = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  // --- Scroll + Podium visibility ---
  final scrollController = ScrollController();
  var isPodiumVisible = true.obs;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_scrollListener);
    fetchRankings();
  }

  // Toggle podium visibility based on scroll
  void _scrollListener() {
    if (scrollController.offset > 250) {
      if (isPodiumVisible.value) {
        isPodiumVisible.value = false;
      }
    } else {
      if (!isPodiumVisible.value) {
        isPodiumVisible.value = true;
      }
    }
  }

  // --- Filters update ---
  void updatePeriod(String period) {
    selectedPeriod.value = period;
    fetchRankings();
  }

  void updateSports(List<String> sports) {
    selectedSports.assignAll(sports);
    fetchRankings();
  }

  void updateRegions(List<String> regions) {
    selectedRegions.assignAll(regions);
    fetchRankings();
  }

  // --- Fetch rankings (dummy) ---
  Future<void> fetchRankings() async {
    try {
      isLoading.value = true;

      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));

      var allRankings = getDummyRankings();

      // Split into top3 + rest
      topThree.assignAll(allRankings.take(3).toList());
      rankings.assignAll(allRankings.skip(3).toList());
    } catch (e) {
      Get.snackbar("Error", "Failed to load rankings: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // --- Refresh ---
  Future<void> refreshData() async {
    await fetchRankings();
  }

  // --- Display text for filters ---
  String get sportsDisplayText {
    if (selectedSports.isEmpty) return "All Sports";
    if (selectedSports.length == 1) return selectedSports.first;
    return "${selectedSports.first} +${selectedSports.length - 1}";
  }

  String get regionsDisplayText {
    if (selectedRegions.isEmpty || selectedRegions.contains("All Region")) {
      return "All Region";
    }
    if (selectedRegions.length == 1) return selectedRegions.first;
    return "${selectedRegions.first} +${selectedRegions.length - 1}";
  }

  // --- Dummy data ---
  List<Map<String, dynamic>> getDummyRankings() {
    return [
      {
        'rank': 1,
        'name': 'Gilang Kencana',
        'username': '@gilangkencana',
        'points': '201 Pts',
        'avatar':
            'https://ui-avatars.com/api/?name=Gilang+Kencana&background=f59e0b&color=fff',
      },
      {
        'rank': 2,
        'name': 'Kevin Halim',
        'username': '@kevinhalim',
        'points': '186 Pts',
        'avatar':
            'https://ui-avatars.com/api/?name=Kevin+Halim&background=6366f1&color=fff',
      },
      {
        'rank': 3,
        'name': 'Narpati Lukita',
        'username': '@narpati',
        'points': '150 Pts',
        'avatar':
            'https://ui-avatars.com/api/?name=Narpati+Lukita&background=f97316&color=fff',
      },
      {
        'rank': 4,
        'name': 'Budiman Mustofa',
        'username': '@budimanmustofa',
        'points': '105 Pts',
        'avatar':
            'https://ui-avatars.com/api/?name=Budiman+Mustofa&background=8b5cf6&color=fff',
      },
      {
        'rank': 5,
        'name': 'Leo Adriansyah',
        'username': '@leo.adrian',
        'points': '100 Pts',
        'avatar':
            'https://ui-avatars.com/api/?name=Leo+Adriansyah&background=06b6d4&color=fff',
      },
      {
        'rank': 6,
        'name': 'Fauzan Pratama',
        'username': '@fauzan',
        'points': '95 Pts',
        'avatar':
            'https://ui-avatars.com/api/?name=Fauzan+Pratama&background=84cc16&color=fff',
      },
      {
        'rank': 7,
        'name': 'Aulia Rahman',
        'username': '@aulia',
        'points': '90 Pts',
        'avatar':
            'https://ui-avatars.com/api/?name=Aulia+Rahman&background=ec4899&color=fff',
      },
      {
        'rank': 8,
        'name': 'Putri Wulandari',
        'username': '@putri',
        'points': '85 Pts',
        'avatar':
            'https://ui-avatars.com/api/?name=Putri+Wulandari&background=ef4444&color=fff',
      },
      {
        'rank': 9,
        'name': 'Rama Setiawan',
        'username': '@rama',
        'points': '80 Pts',
        'avatar':
            'https://ui-avatars.com/api/?name=Rama+Setiawan&background=3b82f6&color=fff',
      },
      {
        'rank': 10,
        'name': 'Dinda Cahyani',
        'username': '@dinda',
        'points': '78 Pts',
        'avatar':
            'https://ui-avatars.com/api/?name=Dinda+Cahyani&background=14b8a6&color=fff',
      },
      {
        'rank': 11,
        'name': 'Dinda Cahyani',
        'username': '@dinda',
        'points': '78 Pts',
        'avatar':
            'https://ui-avatars.com/api/?name=Dinda+Cahyani&background=14b8a6&color=fff',
      },
      {
        'rank': 12,
        'name': 'Dinda Cahyani',
        'username': '@dinda',
        'points': '78 Pts',
        'avatar':
            'https://ui-avatars.com/api/?name=Dinda+Cahyani&background=14b8a6&color=fff',
      },
      {
        'rank': 13,
        'name': 'Dinda Cahyani',
        'username': '@dinda',
        'points': '78 Pts',
        'avatar':
            'https://ui-avatars.com/api/?name=Dinda+Cahyani&background=14b8a6&color=fff',
      },
    ];
  }
}
