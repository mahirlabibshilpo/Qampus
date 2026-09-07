import 'package:flutter/material.dart';

// Club Office er main screen
class ClubOffice extends StatelessWidget {
  const ClubOffice({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Upore Club Office er AppBar
      appBar: AppBar(
        title: const Text(
          'Club Office',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),

      // Main screen er content
      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student Clubs er heading
            const Text(
              'Student Clubs',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            // Computer Club er box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Computer Club er icon
                  const Icon(Icons.code, color: Colors.green, size: 28),

                  const SizedBox(height: 8),

                  const Text(
                    'Computer Club',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    'Programming and technology activities',
                    style: TextStyle(fontSize: 12),
                  ),

                  const SizedBox(height: 8),

                  // Join button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Join'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Sports Club er box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sports Club er icon
                  const Icon(
                    Icons.sports_soccer,
                    color: Colors.green,
                    size: 28,
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Sports Club',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    'Sports events and student activities',
                    style: TextStyle(fontSize: 12),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Join'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Cultural Club er box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cultural Club er icon
                  const Icon(Icons.music_note, color: Colors.green, size: 28),

                  const SizedBox(height: 8),

                  const Text(
                    'Cultural Club',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    'Music, art and cultural programs',
                    style: TextStyle(fontSize: 12),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Join'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Photography Club er box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Photography Club er icon
                  const Icon(Icons.camera_alt, color: Colors.green, size: 28),

                  const SizedBox(height: 8),

                  const Text(
                    'Photography Club',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    'Photography and creative activities',
                    style: TextStyle(fontSize: 12),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Join'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
