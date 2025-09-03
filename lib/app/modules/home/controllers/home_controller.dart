import 'package:get/get.dart';
import 'package:flutter/material.dart';

class HomeController extends GetxController {
  // --- Filters ---
  var selectedPeriod = "Summer 2025".obs;
  var selectedSports = <String>["Tenis Meja"].obs;
  var selectedRegions = <String>[].obs; // Changed to List for multi-select
  var selectedGameType = "Tunggal".obs;

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

  void updateGameType(String gameType) {
    selectedGameType.value = gameType;
    fetchRankings();
  }

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

  Future<void> fetchRankings() async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(milliseconds: 500));

      var allRankings = getDummyRankingsForFilters();
      print('📊 All Rankings count: ${allRankings.length}');

      topThree.assignAll(allRankings.take(3).toList());
      rankings.assignAll(allRankings.skip(3).toList());
    } catch (e) {
      Get.snackbar("Error", "Failed to load rankings: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    await fetchRankings();
  }

  String get sportsDisplayText {
    if (selectedSports.isEmpty) return "All Sports";
    if (selectedSports.length == 1) return selectedSports.first;
    return "${selectedSports.first} +${selectedSports.length - 1}";
  }

  String get regionDisplayText {
    if (selectedRegions.isEmpty) return "All Region";
    if (selectedRegions.length == 1) return selectedRegions.first;
    return "${selectedRegions.first} +${selectedRegions.length - 1}";
  }

  // Generate rankings based on current filters
  List<Map<String, dynamic>> getDummyRankingsForFilters() {
    print('=== FILTER DEBUG ===');
    print('Selected Sports: ${selectedSports.toList()}');
    print('Selected Regions: ${selectedRegions.toList()}');
    print('Selected Game Type: ${selectedGameType.value}');
    print('Selected Period: ${selectedPeriod.value}');
    print('==================');

    // Expanded players pool with more regions
    List<Map<String, dynamic>> allPlayers = [
      // --- Summer 2025 ---
      {
        'name': 'Jakarta Tennis Pro',
        'username': '@jakartatennis',
        'sport': 'Tenis',
        'region': 'Jakarta',
        'type': 'Tunggal',
        'season': 'Summer 2025',
      },
      {
        'name': 'Andi Badminton',
        'username': '@andibad',
        'sport': 'Badminton',
        'region': 'Jakarta',
        'type': 'Tunggal',
        'season': 'Summer 2025',
      },
      {
        'name': 'Bandung Pingpong',
        'username': '@bandungping',
        'sport': 'Tenis Meja',
        'region': 'Bandung',
        'type': 'Tunggal',
        'season': 'Summer 2025',
      },
      {
        'name': 'Surabaya Champion',
        'username': '@sbychamp',
        'sport': 'Tenis Meja',
        'region': 'Surabaya',
        'type': 'Tunggal',
        'season': 'Summer 2025',
      },
      {
        'name': 'Bogor Tennis Star',
        'username': '@bogorstar',
        'sport': 'Tenis',
        'region': 'Bogor',
        'type': 'Tunggal',
        'season': 'Summer 2025',
      },
      {
        'name': 'Yogya Master',
        'username': '@yogyamaster',
        'sport': 'Tenis Meja',
        'region': 'Yogyakarta',
        'type': 'Tunggal',
        'season': 'Summer 2025',
      },
      {
        'name': 'Medan Pro Player',
        'username': '@medanpro',
        'sport': 'Badminton',
        'region': 'Medan',
        'type': 'Tunggal',
        'season': 'Summer 2025',
      },
      {
        'name': 'Bali Tennis Ace',
        'username': '@baliace',
        'sport': 'Tenis',
        'region': 'Bali',
        'type': 'Tunggal',
        'season': 'Summer 2025',
      },

      // --- Januari - Maret 2024 ---
      {
        'name': 'Gilang Kencana',
        'username': '@gilangkencana',
        'sport': 'Tenis Meja',
        'region': 'Jakarta',
        'type': 'Tunggal',
        'season': 'Januari - Maret 2024',
      },
      {
        'name': 'Budi Racket',
        'username': '@budiracket',
        'sport': 'Badminton',
        'region': 'Surabaya',
        'type': 'Tunggal',
        'season': 'Januari - Maret 2024',
      },
      {
        'name': 'Dinda Cahyani',
        'username': '@dinda',
        'sport': 'Pickleball',
        'region': 'Yogyakarta',
        'type': 'Tunggal',
        'season': 'Januari - Maret 2024',
      },
      {
        'name': 'Bandung Star',
        'username': '@bandungstar',
        'sport': 'Tenis Meja',
        'region': 'Bandung',
        'type': 'Tunggal',
        'season': 'Januari - Maret 2024',
      },
      {
        'name': 'Bogor Champion',
        'username': '@bogorchamp',
        'sport': 'Tenis',
        'region': 'Bogor',
        'type': 'Tunggal',
        'season': 'Januari - Maret 2024',
      },

      // --- Oktober - Desember 2023 ---
      {
        'name': 'Kevin Halim',
        'username': '@kevinhalim',
        'sport': 'Tenis Meja',
        'region': 'Bandung',
        'type': 'Tunggal',
        'season': 'Oktober - Desember 2023',
      },
      {
        'name': 'Sari Shuttlecock',
        'username': '@sarishuttle',
        'sport': 'Badminton',
        'region': 'Bandung',
        'type': 'Ganda',
        'season': 'Oktober - Desember 2023',
      },
      {
        'name': 'Jakarta Tennis Pro 2023',
        'username': '@jkttennis23',
        'sport': 'Tenis',
        'region': 'Jakarta',
        'type': 'Tunggal',
        'season': 'Oktober - Desember 2023',
      },
      {
        'name': 'Surabaya Pingpong',
        'username': '@sbyping',
        'sport': 'Tenis Meja',
        'region': 'Surabaya',
        'type': 'Tunggal',
        'season': 'Oktober - Desember 2023',
      },
      {
        'name': 'Bogor Tennis Legend',
        'username': '@bogorlegend',
        'sport': 'Tenis',
        'region': 'Bogor',
        'type': 'Tunggal',
        'season': 'Oktober - Desember 2023',
      },

      // --- Juli - Agustus 2023 ---
      {
        'name': 'Maya Pingpong',
        'username': '@mayaping',
        'sport': 'Tenis Meja',
        'region': 'Yogyakarta',
        'type': 'Ganda',
        'season': 'Juli - Agustus 2023',
      },
      {
        'name': 'Fauzan Pratama',
        'username': '@fauzan',
        'sport': 'Tenis',
        'region': 'Bali',
        'type': 'Komunitas',
        'season': 'Juli - Agustus 2023',
      },
      {
        'name': 'Medan Table Tennis',
        'username': '@medantt',
        'sport': 'Tenis Meja',
        'region': 'Medan',
        'type': 'Tunggal',
        'season': 'Juli - Agustus 2023',
      },
    ];

    // Filter based on current selections
    List<Map<String, dynamic>> filteredPlayers = allPlayers.where((player) {
      bool sportMatch =
          selectedSports.isEmpty ||
          selectedSports.contains(player['sport']) ||
          selectedSports.contains("All Sports");

      bool regionMatch =
          selectedRegions.isEmpty || selectedRegions.contains(player['region']);

      bool typeMatch = player['type'] == selectedGameType.value;

      bool periodMatch =
          selectedPeriod.value == "All Time" ||
          player['season'] == selectedPeriod.value;

      // Detailed logging
      if (sportMatch && regionMatch && typeMatch && periodMatch) {
        print(
          '✅ ${player['name']} - Sport: ${player['sport']}, Region: ${player['region']}, Type: ${player['type']}, Period: ${player['season']}',
        );
      } else {
        print(
          '❌ ${player['name']} - Sport: ${player['sport']} (${sportMatch ? '✅' : '❌'}), Region: ${player['region']} (${regionMatch ? '✅' : '❌'}), Type: ${player['type']} (${typeMatch ? '✅' : '❌'}), Period: ${player['season']} (${periodMatch ? '✅' : '❌'})',
        );
      }

      return sportMatch && regionMatch && typeMatch && periodMatch;
    }).toList();

    print('Total filtered players: ${filteredPlayers.length}');
    print('==================');

    // Generate rankings with points based on filters and period
    List<Map<String, dynamic>> rankings = [];

    for (int i = 0; i < filteredPlayers.length; i++) {
      var player = filteredPlayers[i];

      // Vary points based on period
      int basePoints = 200 - (i * 15);
      int periodMultiplier = _getPeriodMultiplier();
      int finalPoints = (basePoints * periodMultiplier / 100).round();

      rankings.add({
        'rank': i + 1,
        'name': player['name'],
        'username': player['username'],
        'points': '$finalPoints',
        'status': _getRandomStatus(i),
        'avatar':
            'https://ui-avatars.com/api/?name=${Uri.encodeComponent(player['name'])}&background=${_getRandomColor()}&color=fff',
      });
    }

    return rankings;
  }

  int _getPeriodMultiplier() {
    switch (selectedPeriod.value) {
      case "All Time":
        return 150;
      case "Summer 2025":
      case "Januari - Maret 2024":
        return 100;
      case "Oktober - Desember 2023":
        return 80;
      case "Juli - Agustus 2023":
        return 60;
      default:
        return 100;
    }
  }

  String _getRandomStatus(int index) {
    List<String> statuses = ['up', 'down', 'stable'];
    return statuses[index % 3];
  }

  String _getRandomColor() {
    List<String> colors = [
      'f59e0b',
      '6366f1',
      'f97316',
      '8b5cf6',
      '06b6d4',
      '84cc16',
      'ec4899',
      'ef4444',
      '3b82f6',
      '14b8a6',
    ];
    return colors[(DateTime.now().millisecondsSinceEpoch) % colors.length];
  }
}
