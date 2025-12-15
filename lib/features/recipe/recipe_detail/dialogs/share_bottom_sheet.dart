import 'package:flutter/material.dart';

void showShareBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Share Recipe', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _shareOption(Icons.share, 'Share Link', Colors.blue),
                _shareOption(Icons.copy, 'Copy Link', Colors.green),
                _shareOption(Icons.message, 'Message', Colors.purple),
                _shareOption(Icons.more_horiz, 'More', Colors.grey),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    },
  );
}

Widget _shareOption(IconData icon, String label, Color color) {
  return Column(
    children: [
      CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        radius: 30,
        child: Icon(icon, color: color, size: 24),
      ),
      const SizedBox(height: 8),
      Text(label, style: const TextStyle(fontSize: 12)),
    ],
  );
}