import 'package:chimini/pallete.dart';
import 'package:flutter/material.dart';

class FeatureBox extends StatelessWidget {
  final Color color;
  final String headerText;
  final String descriptionText;
  final VoidCallback onPressed; // For the icon's onPressed action


  const FeatureBox({
    super.key,
    required this.color,
    required this.headerText,
    required this.descriptionText,
    required this.onPressed, // Add the onPressed callback
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 35,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20).copyWith(
          left: 15,
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                headerText,
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Cera Pro',
                  color: Pallete.blackColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // This Expanded widget takes up the remaining space, so the icon stays on the right
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 0),
                    child: Text(
                      descriptionText,
                      style: TextStyle(
                        fontFamily: 'Cera Pro',
                        color: Pallete.blackColor,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_circle_right_outlined), // Use the icon passed to the constructor
                  onPressed: onPressed, // Use the onPressed callback passed to the constructor
                ),
              ],
            ),
          ],
        ),
      ),
    );

  }
}
