import 'package:flutter/material.dart';

class ProductInfoPage extends StatelessWidget {
  final Map<String, dynamic> productInfo;

  const ProductInfoPage({Key? key, required this.productInfo})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = [
      {
        'label': 'Product',
        'value': productInfo['product'],
        'icon': Icons.shopping_bag,
      },
      {'label': 'Code', 'value': productInfo['code'], 'icon': Icons.qr_code},
      {
        'label': 'Inventory ID',
        'value': productInfo['inventory_id'],
        'icon': Icons.inventory,
      },
      {
        'label': 'Points',
        'value': productInfo['points'].toString(),
        'icon': Icons.star,
      },
      {
        'label': 'Claimed',
        'value': productInfo['claimed'] ? 'Yes' : 'No',
        'icon': Icons.check_circle,
      },
      {
        'label': 'Active',
        'value': productInfo['active'] ? 'Yes' : 'No',
        'icon': Icons.toggle_on,
      },
      {
        'label': 'Deleted',
        'value': productInfo['deleted'] ? 'Yes' : 'No',
        'icon': Icons.delete,
      },
      {
        'label': 'Created',
        'value': productInfo['created'],
        'icon': Icons.calendar_today,
      },
      {
        'label': 'Updated',
        'value': productInfo['updated'],
        'icon': Icons.update,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Information'),
        backgroundColor: Colors.orange,
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: const Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                return _buildCard(
                  item['label']!,
                  item['value']!,
                  item['icon'] as IconData,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Join Now'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(String label, String value, IconData icon) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.orange),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          value.isNotEmpty ? value : 'N/A',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
