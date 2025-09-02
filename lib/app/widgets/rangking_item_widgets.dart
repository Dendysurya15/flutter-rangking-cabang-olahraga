import 'package:flutter/material.dart';

class RankingItem extends StatelessWidget {
  final int rank;
  final String name;
  final String username;
  final String points;
  final String avatar;
  final String status; // New status parameter: "up", "down", or "stable"
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
          // Rank - Simple text
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

          // Avatar
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(avatar),
            backgroundColor: Colors.grey.shade200,
          ),
          const SizedBox(width: 12),

          // Name and Username
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

          // Status indicator
          _buildStatusIndicator(),
          const SizedBox(width: 8),

          // Points - Simple text, right aligned
          Text(
            points,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
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
