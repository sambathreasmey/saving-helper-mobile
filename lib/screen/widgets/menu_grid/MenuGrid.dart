import 'package:flutter/cupertino.dart';

class MenuGrid extends StatelessWidget {
  final List<Widget> menuItems;

  const MenuGrid({super.key, required this.menuItems});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,                // So it sizes to its content
      physics: const NeverScrollableScrollPhysics(), // No internal scroll
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,             // 4 items per row
        mainAxisSpacing: 8,           // vertical spacing between items
        crossAxisSpacing: 0,          // horizontal spacing between items
        childAspectRatio: 1,           // item width:height ratio (square)
      ),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        return menuItems[index];
      },
    );
  }
}