import 'package:flutter/material.dart';
class NoticeBoard extends StatelessWidget {
  const NoticeBoard({super.key});
  final List<String> titles = const [
    'Semester Final Exam Routine',
    'University Closed - Holiday',
    'Spring 2027 Admission Circular',
    'Fee Payment Date Extended',
    'Club Fair Registration Open',
  ];
  final List<String> dates = const [
    'Sep 05, 2026',
    'Sep 02, 2026',
    'Aug 28, 2026',
    'Aug 20, 2026',
    'Aug 15, 2026',
  ];
  final List<String> details = const [
    'Final exam schedule for all departments is published.',
    'Campus will remain closed on national holiday.',
    'Admission circular for Spring 2027 is now available.',
    'Semester fee payment deadline extended by one week.',
    'Students can register their clubs for the club fair.',
  ];
  void showDetails(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(titles[index]),
        content: Text(details[index]),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notice Board'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: titles.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: const Icon(Icons.campaign, color: Colors.green),
              title: Text(
                titles[index],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Published on: ${dates[index]}'),
              trailing: TextButton(
                onPressed: () => showDetails(context, index),
                child: const Text('View'),
              ),
              onTap: () => showDetails(context, index),
            ),
          );
        },
      ),
    );
  }
}
