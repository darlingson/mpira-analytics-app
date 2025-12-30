import 'package:flutter/material.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  String selectedTab = 'Played';

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
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Matches Overview',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.search, color: Colors.white, size: 28),
                ],
              ),
            ),

            // Season and Competition
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E2A3B),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '2023/2024',
                              style: TextStyle(color: Colors.white),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E2A3B),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'All Competitions',
                              style: TextStyle(color: Colors.white),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: ['Played', 'Upcoming', 'Postponed'].map((tab) {
                  final bool isSelected = selectedTab == tab;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => selectedTab = tab),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF1E2A3B)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            tab,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.grey[600],
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // Matches List - now grouped by month
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  // October 2023
                  _buildMonthHeader('October 2023'),

                  // Premier League under October
                  _buildLeagueHeader('Premier League', Colors.blue),
                  _buildMatchRow('OCT 24', 'Man City', '3 - 1', 'Brighton'),
                  _buildMatchRow('OCT 24', 'Liverpool', '2 - 0', 'Everton'),
                  _buildMatchRow('OCT 23', 'Tottenham', '2 - 0', 'Fulham'),

                  const SizedBox(height: 20),

                  // Champions League under October
                  _buildLeagueHeader(
                    'Champions League',
                    Colors.purple,
                    subtitle: 'Group Stage',
                  ),
                  _buildMatchRow('OCT 22', 'Sevilla', '1 - 2', 'Arsenal'),
                  _buildMatchRow(
                    'OCT 22',
                    'Real Madrid',
                    '1 - 0',
                    'Napoli',
                    isLive: true,
                    liveMinute: 34,
                  ),
                  _buildMatchRow('OCT 22', 'Benfica', '0 - 1', 'Real Sociedad'),

                  const SizedBox(height: 20),

                  // La Liga under October
                  _buildLeagueHeader(
                    'La Liga',
                    Colors.green,
                    subtitle: 'Matchday 10',
                  ),
                  // No matches shown in screenshot for La Liga, but header is there
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthHeader(String month) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        month,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLeagueHeader(String title, Color iconColor, {String? subtitle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: iconColor,
            child: const Icon(
              Icons.sports_soccer,
              size: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtitle != null) ...[
            const Spacer(),
            Text(subtitle, style: const TextStyle(color: Colors.grey)),
          ],
        ],
      ),
    );
  }

  Widget _buildMatchRow(
    String date,
    String homeTeam,
    String score,
    String awayTeam, {
    bool isLive = false,
    int liveMinute = 0,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2A3B),
        borderRadius: BorderRadius.circular(12),
        border: isLive
            ? const Border(left: BorderSide(color: Colors.blue, width: 4))
            : null,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Text(
              date,
              style: const TextStyle(color: Colors.grey, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    homeTeam,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.end,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  score,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    awayTeam,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          if (isLive) ...[
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$liveMinute\'',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}
