import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart'; // adjust path as needed


class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryState();
}
class _HistoryState extends  State<HistoryPage>  {
  String formatDateTime(String? dateTimeStr) {
    if (dateTimeStr == null) return '';

    final dateTime = DateTime.tryParse(dateTimeStr);
    if (dateTime == null) return dateTimeStr;

    // Format as "YYYY-MM-DD HH:mm"
    final date =
        "${dateTime.year.toString().padLeft(4, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
    final time =
        "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
    return "$date $time";
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Back'),
        backgroundColor: Color(0xFFF05024),
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: Icon(Icons.chevron_left, color: Colors.white, size: 28),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
      ),
      body: RefreshIndicator(
        onRefresh: () => userProvider.getUserPoints(),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Top Section
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Color(0xFFF05024),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'History',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Review your past activities and records.',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),

              if (userProvider.isLoading)
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                )
              else if (userProvider.pointHistory.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text("No history found."),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: userProvider.pointHistory.length,
                  itemBuilder: (context, index) {
                    final item = userProvider.pointHistory[index];
                    return HistoryCard(
                      title: item['product'] ?? 'Unknown Product',
                      description: item['expired']
                          ? 'Expired'
                          : item['redeemed']
                          ? 'Redeemed'
                          : 'Active',
                      date: formatDateTime(item['created']),
                      points: '+${item['points']} pts',
                      expiredTime: formatDateTime(
                        item['expiration_date'],
                      ), // Add this line
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class HistoryCard extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final String points;
  final String expiredTime; // NEW

  const HistoryCard({
    Key? key,
    required this.title,
    required this.description,
    required this.date,
    required this.points,
    required this.expiredTime, // NEW
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Color(0xFFDCFCE7),
              child: Icon(
                Icons.trending_up,
                size: 30,
                color: Color(0xFF16A34A),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(description, style: TextStyle(color: Colors.grey[700])),
                  SizedBox(height: 8),
                  Text(date, style: TextStyle(color: Colors.grey)),
                  if (expiredTime.isNotEmpty) ...[
                    SizedBox(height: 8),
                    Text(
                      'Expired: $expiredTime',
                      style: TextStyle(color: Colors.red[300]),
                    ),
                  ],
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                points,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
