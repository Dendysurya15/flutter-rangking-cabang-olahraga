import 'package:flutter/material.dart';

class PeriodFilterBottomSheet extends StatefulWidget {
  final String currentSelection;

  const PeriodFilterBottomSheet({super.key, required this.currentSelection});

  @override
  State<PeriodFilterBottomSheet> createState() =>
      _PeriodFilterBottomSheetState();
}

class _PeriodFilterBottomSheetState extends State<PeriodFilterBottomSheet> {
  late String selectedPeriod;

  @override
  void initState() {
    super.initState();
    selectedPeriod = widget.currentSelection;
  }

  final List<Map<String, String>> periods = [
    {"title": "All Time", "subtitle": ""},
    {"title": "Januari - Maret 2025", "subtitle": "Current Season"},
    {"title": "Oktober - Desember 2024", "subtitle": ""},
    {"title": "Juli - September 2024", "subtitle": ""},
    {"title": "April - Juni 2024", "subtitle": ""},
    {"title": "Januari - Maret 2024", "subtitle": ""},
  ];

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
                "Periode",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Period options
          ...periods.map(
            (period) => RadioListTile<String>(
              title: Text(period["title"]!),
              subtitle: period["subtitle"]!.isNotEmpty
                  ? Text(
                      period["subtitle"]!,
                      style: TextStyle(color: Colors.grey.shade600),
                    )
                  : null,
              value: period["title"]!,
              groupValue: selectedPeriod,
              onChanged: (value) {
                setState(() {
                  selectedPeriod = value!;
                });
              },
            ),
          ),

          const SizedBox(height: 20),

          // Apply button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, selectedPeriod);
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
