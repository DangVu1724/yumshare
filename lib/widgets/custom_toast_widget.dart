import 'package:flutter/material.dart';

class CustomToast {
  static void show(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (_) => Center(
        child: AnimatedOpacity(
          opacity: 1,
          duration: Duration(milliseconds: 250),
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 22, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 22, offset: Offset(0, 6))],
                border: Border.all(color: Colors.redAccent, width: 1.2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bookmark, color: Colors.redAccent, size: 20),
                  SizedBox(width: 10),
                  Text(
                    message,
                    style: TextStyle(color: Colors.redAccent, fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);

    Future.delayed(Duration(milliseconds: 1200), () {
      entry.remove();
    });
  }
}
