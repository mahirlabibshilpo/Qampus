import 'package:flutter/material.dart';

// Administrative Office er main screen
class AdministrativeOffice extends StatelessWidget {
  const AdministrativeOffice({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Screen er halka background color
      backgroundColor: Colors.grey.shade50,

      // Upore je AppBar ta thakbe
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,

        title: const Text(
          'Administrative Office',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Main content er charpashe padding
      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          // Ekhane screen er shob box gula thakbe
          children: [

            // Administrative Office er header box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(15),
              ),

              child: Row(
                children: [

                  // Office er icon
                  const Icon(
                    Icons.account_balance,
                    color: Colors.green,
                    size: 40,
                  ),

                  const SizedBox(width: 12),

                  // Header er title ar subtitle
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Administrative Office',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),

                      SizedBox(height: 5),

                      Text(
                        'Student administrative services',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Header ar next section er moddhe gap
            const SizedBox(height: 20),

            // Student services section er title
            const Text(
              'Student Services',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            // Student ID er box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),

              child: Row(
                children: [

                  // ID card er icon
                  const Icon(
                    Icons.badge,
                    color: Colors.green,
                    size: 30,
                  ),

                  const SizedBox(width: 12),

                  // ID card er information
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Student ID Card',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 4),

                        Text(
                          'Apply for or replace your student ID card',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),

                  // Right side er arrow
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                    color: Colors.green,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Fee management er box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),

              child: Row(
                children: [

                  // Fees er icon
                  const Icon(
                    Icons.payments,
                    color: Colors.green,
                    size: 30,
                  ),

                  const SizedBox(width: 12),

                  // Fee related information
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fee Management',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 4),

                        Text(
                          'Check fees and payment information',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),

                  // Box er right side er arrow
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                    color: Colors.green,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Official documents er box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),

              child: Row(
                children: [

                  // Documents er icon
                  const Icon(
                    Icons.description,
                    color: Colors.green,
                    size: 30,
                  ),

                  const SizedBox(width: 12),

                  // Documents er information
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Official Documents',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 4),

                        Text(
                          'Request certificates and official documents',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),

                  // Right side er arrow
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                    color: Colors.green,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Office information er box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),

              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(15),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Information box er heading
                  const Text(
                    'Office Information',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Office location
                  const Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.green,
                        size: 20,
                      ),

                      const SizedBox(width: 8),

                      Text(
                        'Main Administration Building',
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Office email
                  const Row(
                    children: [
                      Icon(
                        Icons.email,
                        color: Colors.green,
                        size: 20,
                      ),

                      const SizedBox(width: 8),

                      Text(
                        'admin@qampus.edu',
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Home screen e back korar button
            Center(
              child: ElevatedButton(
                onPressed: () {

                  // Previous screen e fire jabe
                  Navigator.pop(context);
                },

                child: const Text(
                  'Back to Home',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
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