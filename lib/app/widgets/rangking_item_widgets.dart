import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:rangking_cabang_olahraga/app/modules/home/controllers/home_controller.dart';

class RankingItem extends GetView<HomeController> {
  final int rank;
  final String name;
  final String username;
  final String points;
  final String avatar;
  final String secondAvatar;
  final String status;
  final bool isHighlighted;

  const RankingItem({
    super.key,
    required this.rank,
    required this.name,
    required this.username,
    required this.points,
    required this.avatar,
    this.secondAvatar = '',
    required this.status,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final isGandaType = controller.selectedGameType.value == "Ganda";

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
        ),
      ),
      child: Row(
        children: [
          // Rank
          SizedBox(
            width: 20,
            child: Text(
              '$rank',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Avatar section - IMPROVED SPACING
          _buildAvatarSection(isGandaType),
          const SizedBox(width: 12),

          // Name + username
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  username,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Status and points
          SizedBox(
            height: 40,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildStatusIndicator(),
                Text(
                  "$points Pts",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarSection(bool isGandaType) {
    if (isGandaType && secondAvatar.isNotEmpty) {
      // IMPROVED: More compact overlapping for doubles
      return SizedBox(
        width: 42, // Fixed width to prevent taking too much space
        height: 36,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // First avatar (back)
            Positioned(
              left: -16,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: CircleAvatar(
                  radius: 15,
                  backgroundImage: avatar.isNotEmpty
                      ? NetworkImage(avatar)
                      : null,
                  backgroundColor: Colors.grey.shade200,
                  child: avatar.isEmpty
                      ? const Icon(Icons.person, color: Colors.grey, size: 15)
                      : null,
                ),
              ),
            ),
            // Second avatar (front) - better overlap
            Positioned(
              left: 10, // Reduced from 23 to 12 for better spacing
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: CircleAvatar(
                  radius: 15,
                  backgroundImage: secondAvatar.isNotEmpty
                      ? NetworkImage(secondAvatar)
                      : null,
                  backgroundColor: Colors.grey.shade200,
                  child: secondAvatar.isEmpty
                      ? const Icon(Icons.person, color: Colors.grey, size: 15)
                      : null,
                ),
              ),
            ),
            // Crown for 1st place - centered
            if (rank == 1)
              Positioned(
                bottom: -6,
                left: 2, // Centered between the two avatars
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.amber,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: const FaIcon(
                    FontAwesomeIcons.crown,
                    color: Colors.white,
                    size: 9,
                  ),
                ),
              ),
          ],
        ),
      );
    } else {
      // Single avatar for Tunggal (unchanged)
      return Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: avatar.isNotEmpty ? NetworkImage(avatar) : null,
            backgroundColor: Colors.grey.shade200,
            child: avatar.isEmpty
                ? const Icon(Icons.person, color: Colors.grey)
                : null,
          ),
          // Crown for 1st place
          if (rank == 1)
            Positioned(
              bottom: -6,
              left: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.amber,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: const FaIcon(
                  FontAwesomeIcons.crown,
                  color: Colors.white,
                  size: 9,
                ),
              ),
            ),
        ],
      );
    }
  }

  Widget _buildStatusIndicator() {
    IconData icon;
    Color color;

    switch (status.toLowerCase()) {
      case 'up':
      case 'increase':
        icon = Icons.keyboard_arrow_up;
        color = Colors.green;
        break;
      case 'down':
      case 'decrease':
        icon = Icons.keyboard_arrow_down;
        color = Colors.red;
        break;
      case 'stable':
      case 'same':
      default:
        icon = Icons.remove;
        color = Colors.grey;
        break;
    }

    return Icon(icon, color: color, size: 20);
  }
}
