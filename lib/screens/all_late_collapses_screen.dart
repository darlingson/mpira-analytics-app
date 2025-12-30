import 'package:flutter/material.dart';

class AllLateCollapsesScreen extends StatefulWidget {
  const AllLateCollapsesScreen({super.key});

  @override
  State<AllLateCollapsesScreen> createState() => _AllLateCollapsesScreenState();
}

class _AllLateCollapsesScreenState extends State<AllLateCollapsesScreen> {
  String selectedSeason = '2023/2024';

  final List<String> seasons = ['2023/2024', '2022/2023', '2021/2022'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1626),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1626),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'All Late Collapses',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Season selector chips
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: seasons.map((season) {
                    final isSelected = selectedSeason == season;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(season),
                        selected: isSelected,
                        onSelected: (_) =>
                            setState(() => selectedSeason = season),
                        selectedColor: Colors.blue,
                        backgroundColor: const Color(0xFF1E2A3B),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[400],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Matches list
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  _buildCollapseSection(
                    league: 'Premier League',
                    iconColor: Colors.blue,
                  ),
                  _buildCollapseMatch(
                    teamLogo: 'CHE',
                    teamName: 'Chelsea',
                    isHome: true,
                    opponent: 'vs Wolves',
                    finalScore: '2 - 4',
                    collapseType: 'Late Collapse',
                    concededMinutes: ['79\'', '82\'', '90\''],
                    goalDiff: '-3',
                    goalDiffLabel: 'GOAL DIFF (85M)',
                  ),
                  const SizedBox(height: 12),
                  _buildCollapseMatch(
                    teamLogo: 'MUN',
                    teamName: 'Man Utd',
                    isHome: true,
                    opponent: 'vs Fulham',
                    finalScore: '1 - 2',
                    collapseType: 'Stoppage Loss',
                    concededMinutes: ['90+7\''],
                    goalDiff: '-1',
                    goalDiffLabel: 'GOAL DIFF (85T)',
                  ),

                  const SizedBox(height: 24),

                  _buildCollapseSection(
                    league: 'La Liga',
                    iconColor: Colors.green,
                  ),
                  _buildCollapseMatch(
                    teamLogo: 'BAR',
                    teamName: 'Barcelona',
                    isHome: true,
                    opponent: 'vs Villarreal',
                    finalScore: '3 - 5',
                    collapseType: 'Total Collapse',
                    concededMinutes: ['90+9\'', '90+11\''],
                    goalDiff: '-2',
                    goalDiffLabel: 'GOAL DIFF (85T)',
                  ),

                  const SizedBox(height: 24),

                  _buildCollapseSection(
                    league: 'Bundesliga',
                    iconColor: Colors.yellow,
                  ),
                  _buildCollapseMatch(
                    teamLogo: 'BVB',
                    teamName: 'Dortmund',
                    isHome: true,
                    opponent: 'vs Hoffenheim',
                    finalScore: '2 - 3',
                    collapseType: 'Late Defeat',
                    concededMinutes: ['85\''],
                    goalDiff: '-1',
                    goalDiffLabel: 'GOAL DIFF (85M)',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollapseSection({
    required String league,
    required Color iconColor,
  }) {
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
            league,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollapseMatch({
    required String teamLogo,
    required String teamName,
    required bool isHome,
    required String opponent,
    required String finalScore,
    required String collapseType,
    required List<String> concededMinutes,
    required String goalDiff,
    required String goalDiffLabel,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2A3B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFF2A374A),
                child: Text(
                  teamLogo,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      teamName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(opponent, style: TextStyle(color: Colors.grey[400])),
                    if (isHome)
                      Text(
                        'Home',
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                  ],
                ),
              ),
              Text(
                finalScore,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              const Text('FT', style: TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                collapseType.contains('Total') ||
                        collapseType.contains('Late Collapse')
                    ? Icons.arrow_downward
                    : Icons.warning_amber,
                color: Colors.red,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                collapseType,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                goalDiff,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('Conceded:', style: TextStyle(color: Colors.grey[400])),
              const SizedBox(width: 8),
              ...concededMinutes.map(
                (min) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      min,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Text(
                goalDiffLabel,
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
