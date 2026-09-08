import 'package:flutter/material.dart';



class Notice {
  final IconData icon;
  final String title;
  final String date;
  final String description;

  const Notice(this.icon, this.title, this.date, this.description);
}



class NoticeBoard extends StatelessWidget {
  const NoticeBoard({super.key});




  
  final List<Notice> _notices = const [
    Notice(
      Icons.event_note,
      'Semester Final Exam Routine',
      'Sep 05, 2026',
      'Final exam schedule for all departments has been published.',
    ),
    Notice(
      Icons.beach_access,
      'University Closed - National Holiday',
      'Sep 02, 2026',
      'The campus will remain closed on account of a national holiday.',
    ),
    Notice(
      Icons.school,
      'Spring 2027 Admission Circular',
      'Aug 28, 2026',
      'Admission circular for Spring 2027 semester is now available.',
    ),
    Notice(
      Icons.payments,
      'Last Date for Fee Payment Extended',
      'Aug 20, 2026',
      'The semester fee payment deadline has been extended by one week.',
    ),
    Notice(
      Icons.groups,
      'Club Fair Registration Open',
      'Aug 15, 2026',
      'Students can now register their clubs for the annual club fair.',
    ),
  ];




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: const Text(
          'Notice Board',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.green.shade50,
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
                side: BorderSide(color: Colors.green.shade300),
              ),
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: 30,
                      child: Icon(Icons.campaign, color: Colors.white, size: 35),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Notice Board',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'University notices & announcements',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${_notices.length} active notices',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),
            const Text(
              'Recent Notices',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),
            for (var notice in _notices)
              _noticeCard(
                icon: notice.icon,
                title: notice.title,
                date: notice.date,
                description: notice.description,
                onTap: () => _showNoticeDetails(context, notice),
              ),
          ],
        ),
      ),
    );
  }
  Widget _noticeCard({
    required IconData icon,
    required String title,
    required String date,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.lightGreenAccent.shade200,
          child: Icon(icon, color: Colors.green.shade700),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Published on: $date'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }




  void _showNoticeDetails(BuildContext context, Notice notice) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(notice.title),
        content: Text(notice.description),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
