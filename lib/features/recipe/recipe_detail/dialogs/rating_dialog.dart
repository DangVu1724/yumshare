import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:yumshare/utils/themes/app_colors.dart';

void showRatingDialog(BuildContext context, double initialRating) {
  double selectedRating = initialRating;
  bool isSubmitting = false;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Rate this Recipe'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                StarRating(
                  rating: selectedRating,
                  size: 50.0, 
                  color: Colors.amber, 
                  borderColor: Colors.amber.withOpacity(0.5), 
                  starCount: 5, 
                  allowHalfRating: false, 
                  onRatingChanged: (rating) {
                    setState(() {
                      selectedRating = rating;
                    });
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  '${selectedRating.toStringAsFixed(1)} stars',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Text(
                  selectedRating >= 4.5
                      ? 'Outstanding! 🌟🌟🌟'
                      : selectedRating >= 4
                      ? 'Excellent! ⭐'
                      : selectedRating >= 3
                      ? 'Good! 👍'
                      : selectedRating >= 2
                      ? 'Fair 👌'
                      : 'Could be better 👎',
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: isSubmitting
                    ? null
                    : () async {
                        setState(() => isSubmitting = true);
                        // TODO: Gửi rating lên server ở đây
                        await Future.delayed(const Duration(seconds: 1)); 
                        setState(() => isSubmitting = false);
                        if (context.mounted) Navigator.pop(context);
                      },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                child: isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Submit Rating'),
              ),
            ],
          );
        },
      );
    },
  );
}
