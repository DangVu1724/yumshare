import 'package:flutter/material.dart';
import 'package:yumshare/models/recipes.dart';

void showRecipeInfoDialog(BuildContext context, Recipe recipe) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Recipe Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoRow('Created', recipe.createdAt.toLocal().toString()),
            _infoRow('Last Updated', recipe.updatedAt.toLocal().toString()),
            _infoRow('Category', recipe.category),
            _infoRow('ID', recipe.id),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
      );
    },
  );
}

Widget _infoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600)),
        Expanded(child: Text(value)),
      ],
    ),
  );
}
