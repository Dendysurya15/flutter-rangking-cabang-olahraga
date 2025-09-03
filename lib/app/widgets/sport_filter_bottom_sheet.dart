import 'package:flutter/material.dart';

class SportFilterBottomSheet extends StatefulWidget {
  final List<String> currentSelections;

  const SportFilterBottomSheet({super.key, required this.currentSelections});

  @override
  State<SportFilterBottomSheet> createState() => _SportFilterBottomSheetState();
}

class _SportFilterBottomSheetState extends State<SportFilterBottomSheet> {
  String? selectedSport;

  @override
  void initState() {
    super.initState();
    // If already has a selection, pick the first one
    selectedSport = widget.currentSelections.isNotEmpty
        ? widget.currentSelections.first
        : null;
  }

  final Map<String, List<SportItem>> sportsCategories = {
    "Preferensi Olahragamu": [
      SportItem("Badminton", Icons.sports_tennis),
      SportItem("Squash", Icons.sports_tennis),
      SportItem("Padel", Icons.sports_tennis),
      SportItem("Mini Soccer", Icons.sports_soccer),
    ],
    "Semua Olahraga": [
      SportItem("Tenis Meja", Icons.sports_tennis),
      SportItem("Tenis", Icons.sports_tennis),
      SportItem("Pickleball", Icons.sports_tennis),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Cabang Olahraga",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.grey),
                ),
              ],
            ),
          ),

          // Sports list
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: sportsCategories.entries.map((category) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                category.key == "Preferensi Olahragamu"
                                    ? Icons.star
                                    : Icons.sports,
                                size: 16,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                category.key,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Sports items
                      ...category.value.map((sport) {
                        final isSelected = selectedSport == sport.name;
                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedSport = sport.name; // ✅ only one
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey.shade200,
                                  width: 0.5,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  sport.icon,
                                  size: 20,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    sport.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFF6C63FF)
                                          : Colors.grey.shade400,
                                      width: 2,
                                    ),
                                    color: isSelected
                                        ? const Color(0xFF6C63FF)
                                        : Colors.transparent,
                                  ),
                                  child: isSelected
                                      ? const Icon(
                                          Icons.circle,
                                          size: 8,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),

          // Apply button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  selectedSport != null ? [selectedSport!] : [],
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                "Terapkan",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SportItem {
  final String name;
  final IconData icon;

  SportItem(this.name, this.icon);
}

// Example usage
void showSportFilterBottomSheet(
  BuildContext context,
  List<String> currentSelections,
) {
  showModalBottomSheet<List<String>>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) =>
        SportFilterBottomSheet(currentSelections: currentSelections),
  ).then((selectedSports) {
    if (selectedSports != null) {
      // Handle the selected sport (single)
      print("Selected sport: $selectedSports");
    }
  });
}
