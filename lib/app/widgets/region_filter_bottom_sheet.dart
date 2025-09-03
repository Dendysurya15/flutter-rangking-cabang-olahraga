import 'package:flutter/material.dart';

class RegionFilterBottomSheet extends StatefulWidget {
  final List<String>? currentSelections;

  const RegionFilterBottomSheet({super.key, this.currentSelections});

  @override
  State<RegionFilterBottomSheet> createState() =>
      _RegionFilterBottomSheetState();
}

class _RegionFilterBottomSheetState extends State<RegionFilterBottomSheet> {
  List<String> selectedRegions = [];
  String searchQuery = "";
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedRegions = widget.currentSelections?.toList() ?? [];
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  final List<String> regions = [
    "Jakarta",
    "Tangerang",
    "Bekasi",
    "Bogor",
    "Depok",
    "Bandung",
    "Yogyakarta",
    "Surabaya",
    "Malang",
    "Bali",
    "Medan",
    "Semarang",
    "Palembang",
    "Makassar",
    "Balikpapan",
    "Manado",
    "Pontianak",
    "Jayapura",
    "Denpasar",
    "Solo",
  ];

  List<String> get filteredRegions {
    if (searchQuery.isEmpty) return regions;
    return regions
        .where(
          (region) => region.toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
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

          // Title and Close
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Pilih Region",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, size: 24),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Search bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.grey.shade500, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: "Cari nama kota",
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                ),
                if (searchQuery.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        searchController.clear();
                        searchQuery = "";
                      });
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.grey.shade500,
                      size: 20,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Region display - chips when no search, list when searching
          Expanded(
            child: searchQuery.isEmpty
                ? // Chips layout when not searching
                  SingleChildScrollView(
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: filteredRegions.map((region) {
                        final isSelected = selectedRegions.contains(region);

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                selectedRegions.remove(region);
                              } else {
                                selectedRegions.add(region);
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF7A5AF8)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF7A5AF8)
                                    : Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              region,
                              style: TextStyle(
                                fontSize: 14,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.black87,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  )
                : // List layout when searching
                  ListView.builder(
                    itemCount: filteredRegions.length,
                    itemBuilder: (context, index) {
                      final region = filteredRegions[index];
                      final isSelected = selectedRegions.contains(region);

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selectedRegions.remove(region);
                            } else {
                              selectedRegions.add(region);
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF7A5AF8).withOpacity(0.1)
                                : null,
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.shade200,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: RichText(
                                  text: _buildHighlightedText(
                                    region,
                                    searchQuery,
                                    isSelected,
                                  ),
                                ),
                              ),
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFF7A5AF8)
                                        : Colors.grey.shade400,
                                    width: 2,
                                  ),
                                  color: isSelected
                                      ? const Color(0xFF7A5AF8)
                                      : null,
                                ),
                                child: isSelected
                                    ? const Icon(
                                        Icons.check,
                                        size: 14,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          const SizedBox(height: 20),

          // Apply button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, selectedRegions),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7A5AF8),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                selectedRegions.isEmpty
                    ? "Pilih All Region"
                    : "Terapkan (${selectedRegions.length})",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextSpan _buildHighlightedText(String text, String query, bool isSelected) {
    if (query.isEmpty) {
      return TextSpan(
        text: text,
        style: TextStyle(
          fontSize: 16,
          color: isSelected ? const Color(0xFF7A5AF8) : Colors.black87,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      );
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    List<TextSpan> spans = [];
    int start = 0;

    while (start < text.length) {
      final index = lowerText.indexOf(lowerQuery, start);
      if (index == -1) {
        spans.add(
          TextSpan(
            text: text.substring(start),
            style: TextStyle(
              fontSize: 16,
              color: isSelected ? const Color(0xFF7A5AF8) : Colors.black87,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        );
        break;
      }

      if (index > start) {
        spans.add(
          TextSpan(
            text: text.substring(start, index),
            style: TextStyle(
              fontSize: 16,
              color: isSelected ? const Color(0xFF7A5AF8) : Colors.black87,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        );
      }

      // Highlighted search match
      spans.add(
        TextSpan(
          text: text.substring(index, index + query.length),
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF7A5AF8),
            fontWeight: FontWeight.bold,
          ),
        ),
      );

      start = index + query.length;
    }

    return TextSpan(children: spans);
  }
}
