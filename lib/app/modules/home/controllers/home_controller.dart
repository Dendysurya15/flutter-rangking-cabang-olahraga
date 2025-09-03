import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:rangking_cabang_olahraga/app/data/dummy_rangkings.dart';

class HomeController extends GetxController {
  // --- Filters ---
  var selectedPeriod = "Summer 2025".obs;
  var selectedSports = <String>["Tenis Meja"].obs;
  var selectedRegions = <String>[
    "DKI Jakarta",
  ].obs; // Changed to List for multi-select
  var selectedGameType = "Ganda".obs;

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
  // Replace your getDummyRankingsForFilters() method with this updated version:

  // Replace your getDummyRankingsForFilters() method with this updated version:

  List<Map<String, dynamic>> getDummyRankingsForFilters() {
    print('=== FILTER DEBUG ===');
    print('Selected Sports: ${selectedSports.toList()}');
    print('Selected Regions: ${selectedRegions.toList()}');
    print('Selected Game Type: ${selectedGameType.value}');
    print('Selected Period: ${selectedPeriod.value}');
    print('==================');

    // Add some Ganda players to your existing allPlayers list

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

    // Generate rankings with support for second avatar
    List<Map<String, dynamic>> rankings = [];

    for (int i = 0; i < filteredPlayers.length; i++) {
      var player = filteredPlayers[i];

      // Calculate points
      int basePoints = 200 - (i * 15);
      int periodMultiplier = _getPeriodMultiplier();
      int finalPoints = (basePoints * periodMultiplier / 100).round();

      String displayName = player['name'];
      String firstAvatar = '';
      String secondAvatar = '';

      // Check if this is a Ganda player with "&" in name
      if (player['type'] == 'Ganda' && player['name'].contains(' & ')) {
        List<String> playerNames = player['name'].split(' & ');
        String firstName = playerNames[0].trim();
        String secondName = playerNames.length > 1
            ? playerNames[1].trim()
            : 'Partner';

        // Generate separate avatars for each player
        firstAvatar =
            'https://ui-avatars.com/api/?name=${Uri.encodeComponent(firstName)}&background=${_getRandomColor()}&color=fff';
        secondAvatar =
            'https://ui-avatars.com/api/?name=${Uri.encodeComponent(secondName)}&background=${_getRandomColor()}&color=fff';
      } else {
        // For Tunggal players or Ganda without "&", use single avatar
        firstAvatar =
            'https://ui-avatars.com/api/?name=${Uri.encodeComponent(player['name'])}&background=${_getRandomColor()}&color=fff';
        secondAvatar = ''; // Empty for single players
      }

      rankings.add({
        'rank': i + 1,
        'name': displayName,
        'username': player['username'],
        'points': '$finalPoints',
        'status': _getRandomStatus(i),
        'avatar': firstAvatar,
        'secondAvatar': secondAvatar,
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
