import 'package:get/get.dart';

class HomeController extends GetxController {
  // Observable variables
  var selectedPeriod = "Summer 2025".obs;
  var selectedSports = <String>["Tenis Meja"].obs;
  var selectedRegions = <String>["All Region"].obs;

  // Ranking data
  var rankings = <Map<String, dynamic>>[].obs;
  var topThree = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRankings();
  }

  // Update period filter
  void updatePeriod(String period) {
    selectedPeriod.value = period;
    fetchRankings();
  }

  // Update sports filter
  void updateSports(List<String> sports) {
    selectedSports.assignAll(sports);
    fetchRankings();
  }

  // Update regions filter
  void updateRegions(List<String> regions) {
    selectedRegions.assignAll(regions);
    fetchRankings();
  }

  // Fetch rankings
  Future<void> fetchRankings() async {
    try {
      isLoading.value = true;

      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));

      var allRankings = getDummyRankings();

      // Separate top 3 and the rest
      topThree.assignAll(allRankings.take(3).toList());
      rankings.assignAll(allRankings.skip(3).toList());
    } catch (e) {
      Get.snackbar("Error", "Failed to load rankings: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Get display text for filters
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

  // Refresh data
  Future<void> refreshData() async {
    await fetchRankings();
  }

  // Dummy data
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
        'name': 'Leo Adriansyah',
        'username': '@leo.adrian',
        'points': '100 Pts',
        'avatar':
            'https://ui-avatars.com/api/?name=Leo+Adriansyah&background=06b6d4&color=fff',
      },
      {
        'rank': 7,
        'name': 'Leo Adriansyah',
        'username': '@leo.adrian',
        'points': '100 Pts',
        'avatar':
            'https://ui-avatars.com/api/?name=Leo+Adriansyah&background=06b6d4&color=fff',
      },
      {
        'rank': 8,
        'name': 'Leo Adriansyah',
        'username': '@leo.adrian',
        'points': '100 Pts',
        'avatar':
            'https://ui-avatars.com/api/?name=Leo+Adriansyah&background=06b6d4&color=fff',
      },
      {
        'rank': 9,
        'name': 'Leo Adriansyah',
        'username': '@leo.adrian',
        'points': '100 Pts',
        'avatar':
            'https://ui-avatars.com/api/?name=Leo+Adriansyah&background=06b6d4&color=fff',
      },
      {
        'rank': 10,
        'name': 'Leo Adriansyah',
        'username': '@leo.adrian',
        'points': '100 Pts',
        'avatar':
            'https://ui-avatars.com/api/?name=Leo+Adriansyah&background=06b6d4&color=fff',
      },
      {
        'rank': 11,
        'name': 'Leo Adriansyah',
        'username': '@leo.adrian',
        'points': '100 Pts',
        'avatar':
            'https://ui-avatars.com/api/?name=Leo+Adriansyah&background=06b6d4&color=fff',
      },
      {
        'rank': 12,
        'name': 'Leo Adriansyah',
        'username': '@leo.adrian',
        'points': '100 Pts',
        'avatar':
            'https://ui-avatars.com/api/?name=Leo+Adriansyah&background=06b6d4&color=fff',
      },
    ];
  }
}
