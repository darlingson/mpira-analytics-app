import 'package:flutter/material.dart';
import 'package:mpira_analytics_app/models/competitions_home.dart';
import '../api_client.dart';

class CompetitionsScreen extends StatefulWidget {
  const CompetitionsScreen({super.key});

  @override
  State<CompetitionsScreen> createState() => _CompetitionsScreenState();
}

class _CompetitionsScreenState extends State<CompetitionsScreen> {
  int _selectedIndex = 0;
  bool _showGoals = true;
  late Future<CompetitionsHome> _competitionsFuture;

  @override
  void initState() {
    super.initState();
    _competitionsFuture = ApiClient().getCompetitionsHomepage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1626),
      body: SafeArea(
        child: FutureBuilder<CompetitionsHome>(
          future: _competitionsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.blue),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
              return const Center(
                child: Text(
                  'No competitions found',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            final competitions = snapshot.data!.data;
            final selectedComp =
                competitions[_selectedIndex % competitions.length];
            final scorers = selectedComp.topScorers;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                _buildSearchBar(),
                const SizedBox(height: 24),

                // Dynamic Tabs from API
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: competitions.asMap().entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: _buildTab(entry.value.name, entry.key),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      // Featured Section
                      _buildSectionHeader('Featured'),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildFeaturedCard(
                              badgeColor: Colors.brown,
                              title: competitions[0].name,
                              subtitle: competitions[0].season,
                            ),
                          ),
                          const SizedBox(width: 16),
                          if (competitions.length > 1)
                            Expanded(
                              child: _buildFeaturedCard(
                                badgeColor: Colors.teal,
                                title: competitions[1].name,
                                subtitle: competitions[1].season,
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Scorers Header
                      _buildScorerHeader(),
                      const SizedBox(height: 16),

                      // Top 2 Scorers Cards
                      if (scorers.isNotEmpty)
                        Row(
                          children: [
                            Expanded(
                              child: _buildTopScorerCard(
                                rank: 1,
                                name: scorers[0].playerName,
                                team: scorers[0].teamName?.toString() ?? "N/A",
                                value: scorers[0].goals,
                                badgeColor: Colors.amber,
                              ),
                            ),
                            const SizedBox(width: 16),
                            if (scorers.length > 1)
                              Expanded(
                                child: _buildTopScorerCard(
                                  rank: 2,
                                  name: scorers[1].playerName,
                                  team:
                                      scorers[1].teamName?.toString() ?? "N/A",
                                  value: scorers[1].goals,
                                  badgeColor: Colors.red,
                                ),
                              ),
                          ],
                        ),

                      const SizedBox(height: 24),
                      if (scorers.length > 2)
                        for (var i = 2; i < scorers.length; i++)
                          _buildListScorer(
                            rank: i + 1,
                            name: scorers[i].playerName,
                            team: scorers[i].teamName?.toString() ?? "N/A",
                            value: scorers[i].goals,
                          ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 12),
          const Text(
            'Competitions',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search leagues, teams, or players...',
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: const Color(0xFF1A2639),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    final bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text('View All', style: TextStyle(color: Colors.blue)),
        ),
      ],
    );
  }

  Widget _buildFeaturedCard({
    required Color badgeColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF162133),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildScorerHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Highest Goal Scorers',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () => setState(() => _showGoals = true),
              child: Text(
                'Goals',
                style: TextStyle(
                  color: _showGoals ? Colors.white : Colors.grey,
                  fontWeight: _showGoals ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            const SizedBox(width: 24),
            GestureDetector(
              onTap: () => setState(() => _showGoals = false),
              child: Text(
                'Assists',
                style: TextStyle(
                  color: !_showGoals ? Colors.white : Colors.grey,
                  fontWeight: !_showGoals ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTopScorerCard({
    required int rank,
    required String name,
    required String team,
    required int value,
    required Color badgeColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF162133),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: badgeColor,
                child: Text(
                  '$rank',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                '$value',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(team, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildListScorer({
    required int rank,
    required String name,
    required String team,
    required int value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 25,
            child: Text(
              '$rank',
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.grey.shade800,
            child: const Icon(Icons.person, size: 20, color: Colors.white70),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  team,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            '$value',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
