import 'package:flutter/material.dart';
import 'package:loyalty_program_application/src/pages/redeem_reward_page.dart';
import 'package:loyalty_program_application/src/providers/auth_provider.dart';
import 'package:loyalty_program_application/src/providers/user_provider.dart';
import 'package:loyalty_program_application/src/widgets/topTabBar/waveBar.dart';
import 'package:provider/provider.dart';

class RewardsPage extends StatefulWidget {
  const RewardsPage({super.key});

  @override
  _RewardsPageState createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  String _selectedCategory = 'All'; // Default category

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<UserProvider>(context, listen: false).fetchRewardsList();
      await Provider.of<UserProvider>(context, listen: false).getRedeemedPoints();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final points = context.watch<UserProvider>().total_points.toStringAsFixed(3);

    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          leading: Navigator.of(context).canPop()
              ? IconButton(
                  icon: Icon(Icons.chevron_left, color: Colors.white, size: 28),
                  onPressed: () => Navigator.of(context).pop(),
                )
              : null,
          title: Text('Rewards'),
          bottom: TabBar(
            indicator: FullTabPillIndicator(
              color: Colors.white.withOpacity(
                0.3,
              ), // semi-transparent white fill
              radius: 0,
            ),
            tabs: const [
              Tab(
                child: SizedBox.expand(child: Center(child: Text('Catalog'))),
              ),
              Tab(
                child: SizedBox.expand(child: Center(child: Text('History'))),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Catalog Tab content (your existing code)
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: Color(0xFFF05024),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   'Rewards Catalog',
                        //   style: TextStyle(fontSize: 30, color: Colors.white),
                        // ),
                        // SizedBox(height: 10),
                        Consumer<UserProvider>(
                          builder: (context, userProvider, child) {
                            final userData = userProvider.userData;
                            final totalPoints = userData != null
                                ? userData['total'].toString()
                                : 'your';

                            return Text(
                              'Redeem $totalPoints points for rewards',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white70,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Search Bar
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Search...',
                                  border: OutlineInputBorder(),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.search,
                                  color: Color(0xFFF05024),
                                ),
                                onPressed: () {
                                  // Handle search logic
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),

                        // Search Categories (Scroll-x)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _categoryButton('All'),
                              _categoryButton('Food'),
                              _categoryButton('Electronics'),
                              _categoryButton('Fashion'),
                              _categoryButton('Clock'),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),

                        // Available Rewards Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Available Rewards',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '$points pts',
                              style: TextStyle(fontSize: 18, color: Colors.red),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),

                        // // Reward Cards
                        // _rewardCard(
                        //   imageUrl: './assets/coffee.png',
                        //   title: 'Free Coffee',
                        //   description:
                        //       'Get a free coffee at any participating store',
                        //   points: '200',
                        // ),
                        // SizedBox(height: 20),
                        // _rewardCard(
                        //   imageUrl: './assets/carousel_3.png',
                        //   title: '15% Discount',
                        //   description: '15% off your next purchase',
                        //   points: '300',
                        // ),
                        userProvider.rewards.isNotEmpty
                            ? Column(
                                children: userProvider.rewards.map((reward) {
                                  return Column(
                                    children: [
                                      _rewardCard(
                                        itemId: int.tryParse(reward['id']?.toString() ?? '') ?? 0,
                                        imageUrl: reward['image'] ?? '',
                                        title: reward['description'] ?? '',
                                        description:
                                            'Redeem for ${reward['uom']}', // or any custom text
                                        points: reward['points_required']
                                            .toString(),
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  );
                                }).toList(),
                              )
                            : Column(
                                children: List.generate(
                                  2,
                                  (index) => _rewardCardSkeleton(),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // History Tab content (you can customize this)
            _buildRewardsHistoryTab(),
          ],
        ),
      ),
    );
  }

  Widget _rewardCardSkeleton() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade300,
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 16, width: 120, color: Colors.grey.shade400),
                const SizedBox(height: 8),
                Container(height: 14, width: 180, color: Colors.grey.shade400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryButton(String label) {
    bool isSelected = _selectedCategory == label;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedCategory = label;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Color(0xFFF05024) : Colors.white,
          padding: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          side: BorderSide(color: Color(0xFFF05024)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? Colors.white : Color(0xFFF05024),
          ),
        ),
      ),
    );
  }

  Widget _rewardCard({
    required int itemId,

    required String imageUrl,
    required String title,
    required String description,
    required String points,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(description),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RedeemRewardPage(
                              itemId: itemId,
                              imageUrl: imageUrl,
                              title: title,
                              description: description,
                              points: points,
                            ),
                          ),
                        );
                      },
                      child: Text('Redeem Reward'),
                    ),
                    Text(
                      '$points pts',
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardsHistoryTab() {
  final history = context.watch<UserProvider>().redeemedHistory;

  Color _getStatusColor({required bool redeemed, required bool expired}) {
    if (redeemed) return Colors.green;
    if (expired) return Colors.grey;
    return Colors.blueGrey;
  }

  IconData _getStatusIcon({required bool redeemed, required bool expired}) {
    if (redeemed) return Icons.check_circle_outline;
    if (expired) return Icons.cancel_outlined;
    return Icons.info_outline;
  }

  String _getStatusText({required bool redeemed, required bool expired}) {
    if (redeemed) return 'Redeemed';
    if (expired) return 'Expired';
    return 'Pending';
  }

  return ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: history.length,
    itemBuilder: (context, index) {
      final item = history[index];
      final product = item['product'] ?? 'Unknown';
      final date = item['created']?.toString().split('T')[0] ?? '';
      final points = item['points'] ?? 0;
      final redeemed = item['redeemed'] ?? false;
      final expired = item['expired'] ?? false;

      final statusColor = _getStatusColor(redeemed: redeemed, expired: expired);
      final statusIcon = _getStatusIcon(redeemed: redeemed, expired: expired);
      final statusText = _getStatusText(redeemed: redeemed, expired: expired);

      return Card(
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                statusIcon,
                color: statusColor,
                size: 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Date: $date',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    Text(
                      'Status: $statusText',
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$points pts',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
}
