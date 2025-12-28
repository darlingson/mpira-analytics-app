import 'package:flutter/material.dart';

class CompetitionsScreen extends StatefulWidget {
  const CompetitionsScreen({super.key});

  @override
  State<CompetitionsScreen> createState() => _CompetitionsScreenState();
}

class _CompetitionsScreenState extends State<CompetitionsScreen> {
  int _selectedIndex = 0; // 0: Leagues, 1: Tournaments, 2: International
  bool _showGoals = true; // true: Goals, false: Assists

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1626),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(''), // placeholder
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
            ),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
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
            ),

            const SizedBox(height: 24),

            // Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildTab('Leagues', 0),
                  const SizedBox(width: 12),
                  _buildTab('Tournaments', 1),
                  const SizedBox(width: 12),
                  _buildTab('International', 2),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Scrollable content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // Featured
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Featured',
                        style: TextStyle(
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
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _buildFeaturedCard(
                          badgeColor: Colors.brown,
                          title: 'Premier League',
                          subtitle: 'England',
                          status: 'Live Matches: 2',
                          hasLiveDot: true,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildFeaturedCard(
                          badgeColor: Colors.teal,
                          title: 'La Liga',
                          subtitle: 'Spain',
                          status: 'Next: Today 20:00',
                          hasNextBadge: true,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Highest Goal Scorers section with tabs
                  Row(
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
                          const SizedBox(width: 32),
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
                  ),

                  const SizedBox(height: 16),

                  // Top 2 as special cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildTopScorerCard(
                          rank: 1,
                          name: 'Erling Haaland',
                          team: 'Man City',
                          value: 14,
                          rating: '7.21',
                          xG: '9.90',
                          apps: 14,
                          badgeColor: Colors.amber,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTopScorerCard(
                          rank: 2,
                          name: 'Mohamed Salah',
                          team: 'Liverpool',
                          value: _showGoals ? 10 : 10, // same in image for both
                          rating: '8.09',
                          xG: '6.90',
                          apps: 15,
                          badgeColor: Colors.red,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Rest of the list (3rd onwards)
                  _buildListScorer(rank: 3, name: 'Heung-Min Son', team: 'Tottenham', value: 9),
                  _buildListScorer(rank: 4, name: 'Jarrod Bowen', team: 'West Ham', value: 9),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
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

  Widget _buildFeaturedCard({
    required Color badgeColor,
    required String title,
    required String subtitle,
    required String status,
    bool hasLiveDot = false,
    bool hasNextBadge = false,
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
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              if (hasNextBadge) ...[
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('NEXT', style: TextStyle(fontSize: 12, color: Colors.white)),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          Text(subtitle, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 12),
          Row(
            children: [
              if (hasLiveDot)
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                ),
              if (hasLiveDot) const SizedBox(width: 8),
              Text(status, style: const TextStyle(color: Colors.blue)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopScorerCard({
    required int rank,
    required String name,
    required String team,
    required int value,
    required String rating,
    required String xG,
    required int apps,
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
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: badgeColor,
                child: Text('$rank', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
              const SizedBox(width: 16),
              Text(
                '$value',
                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
          Text(team, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          Text('$rating xG $xG • $apps Apps', style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: double.parse(rating.replaceAll('/', '')) / 10, // rough approximation
            backgroundColor: Colors.grey.shade800,
            color: Colors.blue,
          ),
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
          Text('$rank', style: const TextStyle(color: Colors.grey, fontSize: 18)),
          const SizedBox(width: 16),
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey.shade700,
            child: Text('$rank', style: const TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text(team, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Text(
            '$value',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }
}