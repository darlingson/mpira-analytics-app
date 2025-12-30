import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:mpira_analytics_app/screens/all_late_collapses_screen.dart';
import 'package:mpira_analytics_app/screens/comeback_kings_screen.dart';
import '../models/overview_models.dart';
import '../api_client.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedLeagueIndex = 0;
  final List<String> _leagues = ['Premier League', 'La Liga', 'Serie A'];
  late Future<Overview?> _overviewFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _overviewFuture = ApiClient().getOverview();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1626),
      body: SafeArea(
        child: FutureBuilder<Overview?>(
          future: _overviewFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.blue),
              );
            }

            if (snapshot.hasError) {
              return _buildErrorState(snapshot.error);
            }

            final data = snapshot.data;
            if (data == null) {
              return const Center(
                child: Text(
                  "No Data Available",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                _buildLeagueTabs(),
                const SizedBox(height: 24),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async => _loadData(),
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        _buildSeasonOverviewCard(data.goals),
                        const SizedBox(height: 32),
                        _buildSectionHeader('League Pulse'),
                        const SizedBox(height: 16),
                        _buildPulseGrid(data.leaguePulse),
                        const SizedBox(height: 32),
                        _buildSectionHeader(
                          'Late Collapse Risks',
                          hasViewAll: true,
                          onViewAll: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AllLateCollapsesScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        ...data.lateCollapses
                            .take(2)
                            .map((c) => _buildCollapseCard(c))
                            .toList(),
                        const SizedBox(height: 24),
                        _buildSectionHeader(
                          'Comeback Kings',
                          hasViewAll: true,
                          onViewAll: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ComebackKingsScreen(),
                              ),
                            );
                          },
                        ),
                        const Text(
                          'Teams scoring the most when trailing',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        _buildComebackRow(data.comebackKings),
                        const SizedBox(height: 32),
                        _buildSectionHeader('Attack Patterns'),
                        const SizedBox(height: 16),
                        ...data.attackPatterns
                            .take(2)
                            .map((p) => _buildAttackPatternCard(p))
                            .toList(),
                        const SizedBox(height: 32),
                        _buildSectionHeader('Clutch Involvement'),
                        const Text(
                          'Goal events in 75\'+ minutes.',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        _buildClutchRow(data.clutchPlayers),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // --- RESTORED UI COMPONENTS ---

  Widget _buildSectionHeader(
    String title, {
    bool hasViewAll = false,
    VoidCallback? onViewAll,
  }) {
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
        if (hasViewAll)
          TextButton(
            onPressed: onViewAll ?? () {},
            child: const Text('View All', style: TextStyle(color: Colors.blue)),
          ),
      ],
    );
  }

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
            'Overview',
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

  Widget _buildLeagueTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _leagues.asMap().entries.map((entry) {
            bool isSelected = _selectedLeagueIndex == entry.key;
            return GestureDetector(
              onTap: () => setState(() => _selectedLeagueIndex = entry.key),
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  entry.value,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSeasonOverviewCard(Goals goals) {
    bool isPositive = !goals.percentageChange.startsWith('-');
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Season Overview',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 12),
          Text(
            '${goals.currentSeasonTotal}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Total Goals Scored',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                isPositive ? Icons.trending_up : Icons.trending_down,
                color: isPositive ? Colors.green : Colors.redAccent,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Vs last season',
                style: const TextStyle(color: Colors.white70),
              ),
              const Spacer(),
              Text(
                goals.percentageChange,
                style: TextStyle(
                  color: isPositive ? Colors.green : Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPulseGrid(LeaguePulse pulse) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.6,
      children: [
        _buildPulseCard(
          'AVG CARDS',
          '${pulse.avgCardsPerMatch}',
          'per match',
          Icons.credit_card,
          Colors.orange,
        ),
        _buildPulseCard(
          'HOME WIN %',
          '${pulse.homeWinPercentage}%',
          '',
          Icons.home,
          Colors.blue,
        ),
        _buildPulseCard(
          'GOALS/90M',
          '${pulse.avgGoalsPerMatch}',
          'League avg',
          Icons.sports_soccer,
          Colors.green,
        ),
        _buildPulseCard(
          'DRAWS',
          '${pulse.totalDraws}',
          'Total season',
          Icons.equalizer,
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildPulseCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF162133),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildCollapseCard(LateCollapse collapse) {
    double riskLevel = (double.parse(collapse.collapseCount) / 10).clamp(
      0.0,
      1.0,
    ); // Mock risk calculation
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF162133),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.blue,
                child: Text(
                  collapse.teamName[0],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                collapse.teamName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${collapse.collapseCount} Collapses',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: riskLevel,
              minHeight: 8,
              backgroundColor: Colors.grey.shade800,
              color: Colors.orange,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('0\'', style: TextStyle(color: Colors.grey, fontSize: 10)),
              Text('45\'', style: TextStyle(color: Colors.grey, fontSize: 10)),
              Text('75\'+', style: TextStyle(color: Colors.grey, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildComebackRow(List<ComebackKing> kings) {
    return Row(
      children: kings.take(2).map((king) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF162133),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  king.teamName.substring(0, 3).toUpperCase(),
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  king.teamName,
                  style: const TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${king.comebackWins} Wins',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Recovered',
                  style: TextStyle(color: Colors.green, fontSize: 12),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAttackPatternCard(AttackPattern pattern) {
    bool isWarning = pattern.patternType == PatternType.SINGLE_POINT_OF_FAILURE;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF162133),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            isWarning ? Icons.warning_amber : Icons.group,
            color: isWarning ? Colors.orange : Colors.blue,
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pattern.patternType
                      .toString()
                      .split('.')
                      .last
                      .replaceAll('_', ' '),
                  style: TextStyle(
                    color: isWarning ? Colors.orange : Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Text(
                  pattern.teamName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${pattern.uniqueScorers} unique scorers',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          if (isWarning)
            SizedBox(
              width: 50,
              height: 50,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: 0.8,
                    strokeWidth: 4,
                    backgroundColor: Colors.grey.shade800,
                    color: Colors.orange,
                  ),
                  const Text(
                    '80%',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildClutchRow(List<ClutchPlayer> players) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: players.take(3).map((player) {
        return Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blueGrey,
              child: Text(
                player.playerName[0],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              player.playerName.split(' ').last,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            Text(
              '${player.clutchGoals} Goals',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildErrorState(Object? error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
          const SizedBox(height: 16),
          Text(
            error is DioException
                ? "Server Timeout. Retrying..."
                : "Error loading data",
            style: const TextStyle(color: Colors.white),
          ),
          TextButton(onPressed: _loadData, child: const Text("Retry")),
        ],
      ),
    );
  }
}
