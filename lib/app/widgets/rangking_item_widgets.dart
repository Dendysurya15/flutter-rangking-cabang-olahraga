import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RankingItem extends StatelessWidget {
  final int rank;
  final String name;
  final String username;
  final String points;
  final String avatar;
  final String status; // "up", "down", "stable"
  final bool isHighlighted;

  const RankingItem({
    super.key,
    required this.rank,
    required this.name,
    required this.username,
    required this.points,
    required this.avatar,
    required this.status,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
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

          // Avatar with optional crown
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: avatar.isNotEmpty
                    ? NetworkImage(avatar)
                    : null,
                backgroundColor: Colors.grey.shade200,
                child: avatar.isEmpty
                    ? const Icon(Icons.person, color: Colors.grey)
                    : null,
              ),

              if (rank == 1)
                Positioned(
                  bottom: -6,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4), // space inside circle
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.amber, // background amber
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: const FaIcon(
                      FontAwesomeIcons.crown,
                      color: Colors.white, // crown icon white
                      size: 9,
                    ),
                  ),
                ),
            ],
          ),
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

          SizedBox(
            height: 40,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment:
                  CrossAxisAlignment.end, // Everything aligned to the right
              children: [
                _buildStatusIndicator(), // Top right
                Text(
                  "$points Pts",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ), // Bottom right
              ],
            ),
          ),
        ],
      ),
    );
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
