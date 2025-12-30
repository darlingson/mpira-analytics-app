import 'package:flutter/material.dart';
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
    _overviewFuture = ApiClient().getOverview();
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
              return _buildErrorState(snapshot.error.toString());
            }
            final data = snapshot.data;
            if (data == null)
              return const Center(
                child: Text("No Data", style: TextStyle(color: Colors.white)),
              );

            return Column(
              children: [
                _buildHeader(),
                _buildLeagueTabs(),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async => setState(() => _loadData()),
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        const SizedBox(height: 24),
                        _buildSeasonOverview(data.goals),
                        const SizedBox(height: 32),
                        _buildPulseSection(data.leaguePulse),
                        const SizedBox(height: 32),
                        _buildCollapseSection(data.lateCollapses),
                        const SizedBox(height: 24),
                        _buildComebackSection(data.comebackKings),
                        const SizedBox(height: 32),
                        _buildAttackPatternSection(data.attackPatterns),
                        const SizedBox(height: 32),
                        _buildClutchSection(data.clutchPlayers),
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

  // --- UI SECTION BUILDERS ---

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          const CircleAvatar(
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
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _leagues.length,
        itemBuilder: (context, index) {
          bool isSelected = _selectedLeagueIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedLeagueIndex = index),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.transparent,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                _leagues[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSeasonOverview(Goals goals) {
    final bool isPositive = !goals.percentageChange.startsWith('-');
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Season Overview',
            style: TextStyle(color: Colors.white70),
          ),
          Text(
            '${goals.currentSeasonTotal}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Icon(
                isPositive ? Icons.trending_up : Icons.trending_down,
                color: isPositive ? Colors.greenAccent : Colors.redAccent,
              ),
              const SizedBox(width: 8),
              Text(
                goals.percentageChange,
                style: TextStyle(
                  color: isPositive ? Colors.greenAccent : Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPulseSection(LeaguePulse pulse) {
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
          Icons.credit_card,
          Colors.orange,
        ),
        _buildPulseCard(
          'HOME WIN %',
          '${pulse.homeWinPercentage}%',
          Icons.home,
          Colors.blue,
        ),
        _buildPulseCard(
          'GOALS/90M',
          '${pulse.avgGoalsPerMatch}',
          Icons.sports_soccer,
          Colors.green,
        ),
        _buildPulseCard(
          'DRAWS',
          '${pulse.totalDraws}',
          Icons.equalizer,
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildPulseCard(
    String title,
    String value,
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
        children: [
          Icon(icon, color: color, size: 24),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildCollapseSection(List<LateCollapse> collapses) {
    return Column(
      children: collapses
          .take(2)
          .map(
            (item) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF162133),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  CircleAvatar(radius: 14, child: Text(item.teamName[0])),
                  const SizedBox(width: 12),
                  Text(
                    item.teamName,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const Spacer(),
                  Text(
                    '${item.collapseCount} Collapses',
                    style: const TextStyle(color: Colors.orangeAccent),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildComebackSection(List<ComebackKing> kings) {
    return Row(
      children: kings
          .take(2)
          .map(
            (king) => Expanded(
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
                      king.teamName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${(int.tryParse(king.comebackWins) ?? 0) * 3} pts',
                      style: const TextStyle(color: Colors.greenAccent),
                    ),
                    const Text(
                      'Recovered',
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildAttackPatternSection(List<AttackPattern> patterns) {
    return Column(
      children: patterns
          .take(2)
          .map(
            (p) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF162133),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(
                    p.patternType == PatternType.SINGLE_POINT_OF_FAILURE
                        ? Icons.warning
                        : Icons.hub,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.teamName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${p.uniqueScorers} unique scorers',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildClutchSection(List<ClutchPlayer> players) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: players
          .take(3)
          .map(
            (player) => Column(
              children: [
                CircleAvatar(radius: 25, child: Text(player.playerName[0])),
                const SizedBox(height: 8),
                Text(
                  player.playerName,
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
                Text(
                  '${player.clutchGoals} Goals',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          )
          .toList(),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Text(
        'Error: $error',
        style: const TextStyle(color: Colors.redAccent),
      ),
    );
  }
}
