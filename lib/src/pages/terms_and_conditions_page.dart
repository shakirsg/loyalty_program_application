import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:metsec_loyalty_app/src/models/terms_and_conditions.dart';
import 'package:metsec_loyalty_app/src/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  State<TermsAndConditionsScreen> createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  late Future<TermsAndConditions> _termsFuture;

  @override
  void initState() {
    super.initState();
    _termsFuture = _loadTerms();
  }

  void _handleAcceptTerms(){
    final authProvider = context.read<AuthProvider>();
    authProvider.termsAccepted = true;
    Navigator.popAndPushNamed(context, '/register');
  }

  void _handleDeclineTerms() => Navigator.popAndPushNamed(context, '/login');

  Future<TermsAndConditions> _loadTerms() async {
    final String jsonString = await rootBundle.loadString(
      'assets/terms_and_conditions.json',
    );
    final Map<String, dynamic> jsonData = json.decode(jsonString);
    return TermsAndConditions.fromJson(jsonData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Conditions'),
        leading: IconButton(
          onPressed: () => Navigator.popAndPushNamed(context, '/register'),
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: FutureBuilder<TermsAndConditions>(
        future: _termsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No terms available'));
          }

          final terms = snapshot.data!;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        terms.title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      ...terms.sections.map(
                        (section) => _buildSection(section),
                      ),
                      const SizedBox(height: 24),
                      _buildContactInfo(terms.contactInfo),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () => _handleDeclineTerms(),
                        child: const Text(
                          'Decline',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () => _handleAcceptTerms(),
                        child: const Text('Accept'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection(Section section) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section.title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            section.content,
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(ContactInfo contactInfo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(contactInfo.description, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 8),
        Text(contactInfo.address),
        Text(contactInfo.email),
        Text(contactInfo.phone),
      ],
    );
  }
}
