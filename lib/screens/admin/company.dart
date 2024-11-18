import 'package:flutter/material.dart';

class CompanyScreen extends StatelessWidget {
  const CompanyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CompanyAppbar(),
      body: CompanyBody(),
    );
  }
}

class CompanyAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CompanyAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Company',
        style: TextStyle(color: Colors.white),
      ),
      foregroundColor: Colors.white,
      backgroundColor: const Color.fromARGB(255, 80, 160, 170),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CompanyBody extends StatelessWidget {
  const CompanyBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What\'s Happening in the Company',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: const [
                _CompanyFeatureCard(
                  title: 'Company News',
                  description: 'Latest updates and happenings in the company.',
                  icon: Icons.campaign,
                ),
                SizedBox(height: 10),
                _CompanyFeatureCard(
                  title: 'Documents',
                  description: 'Access and manage company documents.',
                  icon: Icons.folder,
                ),
                SizedBox(height: 10),
                _CompanyFeatureCard(
                  title: 'Announcements',
                  description: 'View all important company announcements.',
                  icon: Icons.announcement,
                ),
                SizedBox(height: 10),
                _CompanyFeatureCard(
                  title: 'Events',
                  description:
                      'Check out upcoming company events and activities.',
                  icon: Icons.event,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CompanyFeatureCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const _CompanyFeatureCard({
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color.fromARGB(255, 80, 160, 170),
          size: 40,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          // Navigate to specific feature screen
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$title screen not implemented yet')),
          );
        },
      ),
    );
  }
}
