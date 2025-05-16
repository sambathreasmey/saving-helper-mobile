import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:saving_helper/controllers/invite_controller.dart';

class AnimatedInviteBanner extends StatefulWidget {
  const AnimatedInviteBanner({super.key});

  @override
  State<AnimatedInviteBanner> createState() => _AnimatedInviteBannerState();
}

class _AnimatedInviteBannerState extends State<AnimatedInviteBanner> with SingleTickerProviderStateMixin {
  final List<List<Color>> _gradientPairs = [
    [Colors.deepPurpleAccent, Colors.purpleAccent],
    [Colors.pinkAccent, Colors.orangeAccent],
    [Colors.blueAccent, Colors.cyanAccent],
    [Colors.greenAccent, Colors.tealAccent],
    [Colors.indigoAccent, Colors.deepPurple],
  ];

  late List<Color> _currentColors;
  late Timer _timer;

  late AnimationController _textAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  void _changeGradient() {
    final random = Random();
    setState(() {
      _currentColors = _gradientPairs[random.nextInt(_gradientPairs.length)];
    });

    _textAnimationController.forward(from: 0.0); // restart text animation
  }

  @override
  void initState() {
    super.initState();
    _currentColors = _gradientPairs.first;

    // Start gradient change timer
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _changeGradient());

    // Setup animation controller
    _textAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textAnimationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0.1, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: _textAnimationController, curve: Curves.easeOut),
    );

    _textAnimationController.forward(); // run on first load
  }

  @override
  void dispose() {
    _timer.cancel();
    _textAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final InviteController controller = InviteController();

        showDialog(
          context: context,
          builder: (context) => Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: StatefulBuilder(
              builder: (context, setState) {
                final color1 = const Color(0xFF536DFE);
                final color2 = const Color(0xFF673AB7);

                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [color1, color2],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color2.withOpacity(0.6),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        child: Image.asset(
                          'assets/images/invite_banner_2.png',
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'អញ្ជើញដៃគូសន្សំប្រាក់',
                              style: TextStyle(
                                fontFamily: 'MyBaseFont',
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'សូមបញ្ចូលឈ្មោះអ្នកប្រើប្រាស់ ដើម្បីស្វែងរក និងអញ្ជើញចូលរួមក្រុម។',
                              style: TextStyle(
                                fontFamily: 'MyBaseFont',
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: controller.searchController,
                              decoration: InputDecoration(
                                hintText: 'ស្វែងរកឈ្មោះអ្នកប្រើប្រាស់...',
                                prefixIcon: const Icon(Icons.search),
                                hintStyle: const TextStyle(color: Colors.black45),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              style: const TextStyle(fontFamily: 'MyBaseFont'),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: controller.selectedGroup,
                                underline: const SizedBox(),
                                hint: const Text('ជ្រើសរើសក្រុម', style: TextStyle(fontFamily: 'MyBaseFont')),
                                items: controller.groups.map((group) {
                                  return DropdownMenuItem(
                                    value: group,
                                    child: Text(group, style: const TextStyle(fontFamily: 'MyBaseFont')),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    controller.selectedGroup = value;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    controller.dispose();
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'បិទ',
                                    style: TextStyle(
                                      fontFamily: 'MyBaseFont',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (controller.validate()) {
                                      print("Inviting ${controller.username} to ${controller.selectedGroup}");
                                      controller.dispose();
                                      Navigator.of(context).pop();
                                    } else {
                                      print("Username or group missing");
                                    }
                                  },
                                  child: Text(
                                    'អញ្ជើញ',
                                    style: TextStyle(
                                      fontFamily: 'MyBaseFont',
                                      fontWeight: FontWeight.bold,
                                      color: color2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _currentColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: _currentColors.first.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.group_add, color: Colors.white, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: const Text(
                    'មុខងារថ្មី សម្រាប់អញ្ជើញដៃគូសន្សំប្រាក់!',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'MyBaseFont',
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
