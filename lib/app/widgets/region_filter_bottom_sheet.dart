import 'package:flutter/material.dart';

class RegionFilterBottomSheet extends StatefulWidget {
  final List<String> currentSelections;

  const RegionFilterBottomSheet({super.key, required this.currentSelections});

  @override
  State<RegionFilterBottomSheet> createState() =>
      _RegionFilterBottomSheetState();
}

class _RegionFilterBottomSheetState extends State<RegionFilterBottomSheet> {
  late List<String> selectedRegions;

  @override
  void initState() {
    super.initState();
    selectedRegions = List.from(widget.currentSelections);
  }

  final Map<String, List<String>> regions = {
    "DKI Jakarta": [
      "Jakarta Pusat",
      "Jakarta Utara",
      "Jakarta Barat",
      "Jakarta Timur",
      "Jakarta Selatan",
    ],
    "Jawa Barat": ["Bandung", "Bogor", "Bekasi", "Depok", "Cimahi"],
    "Jawa Tengah": ["Solo", "Semarang", "Magelang", "Yogyakarta"],
    "Jawa Timur": ["Surabaya", "Malang", "Sidoarjo", "Gresik"],
    "Bali": ["Denpasar", "Ubud", "Sanur", "Kuta"],
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Pilih Region",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Regions
          Container(
            height: 400,
            child: ListView(
              children: regions.entries.map((entry) {
                return ExpansionTile(
                  title: Text(entry.key),
                  children: entry.value.map((city) {
                    final isSelected = selectedRegions.contains(city);
                    return CheckboxListTile(
                      title: Text(city),
                      value: isSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedRegions.add(city);
                          } else {
                            selectedRegions.remove(city);
                          }
                        });
                      },
                    );
                  }).toList(),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 20),

          // Apply button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, selectedRegions);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Terapkan"),
            ),
          ),
        ],
      ),
    );
  }
}
