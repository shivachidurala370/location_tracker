import 'package:background_location_tracker/data/models/location_model.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class LocationHistoryTile extends StatelessWidget {
  final LocationModel item;

  const LocationHistoryTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.location_on_outlined,
              color: Color(0xFF1D61FF),
            ),
          ),
          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.latitude.toStringAsFixed(4)}, ${item.longitude.toStringAsFixed(4)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                Text(
                  'Accuracy ±${item.accuracy.toStringAsFixed(0)}m',
                  style: const TextStyle(color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                timeago.format(item.timestamp),
                style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
              ),
              Text(
                '${item.timestamp.hour}:${item.timestamp.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 10, color: Color(0xFF9CA3AF)),
              ),
            ],
          ),

          // Text(
          //   timeago.format(item.timestamp),
          //   style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
          // ),
        ],
      ),
    );
  }
}
