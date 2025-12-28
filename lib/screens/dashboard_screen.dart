import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedLeagueIndex = 0;
  final List<String> _leagues = ['Premier League', 'La Liga', 'Serie A'];

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
            ),

            // League tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _leagues.asMap().entries.map((entry) {
                    int index = entry.key;
                    String league = entry.value;
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
                          league,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Main scrollable content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // Season Overview Card
                  Container(
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
                        const Text(
                          '842',
                          style: TextStyle(
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
                          children: const [
                            Icon(Icons.trending_up, color: Colors.green, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Higher than last season',
                              style: TextStyle(color: Colors.white70),
                            ),
                            Spacer(),
                            Text(
                              '+12%',
                              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // League Pulse
                  const Text(
                    'League Pulse',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),

                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.6,
                    children: [
                      _buildPulseCard('AVG CARDS', '3.2', 'per match', Icons.credit_card, Colors.orange),
                      _buildPulseCard('HOME WIN %', '45%', '', Icons.home, Colors.blue),
                      _buildPulseCard('GOALS/90M', '2.8', 'League avg', Icons.sports_soccer, Colors.green),
                      _buildPulseCard('ADDED TIME', '+7m', 'avg per half', Icons.timer, Colors.purple),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Late Collapse Risks
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Late Collapse Risks',
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

                  // Everton risk bar
                  Container(
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
                              radius: 16,
                              backgroundColor: Colors.blue,
                              child: Text('E', style: TextStyle(color: Colors.white)),
                            ),
                            const SizedBox(width: 12),
                            const Text('Everton', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text('Med Risk', style: TextStyle(color: Colors.white, fontSize: 12)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: 0.75,
                            minHeight: 8,
                            backgroundColor: Colors.grey.shade800,
                            color: Colors.orange,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('0\'', style: TextStyle(color: Colors.grey)),
                            Text('45\'', style: TextStyle(color: Colors.grey)),
                            Text('75\'+', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Comeback Kings
                  const Text('Comeback Kings', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('Teams scoring the most when trailing', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(child: _buildComebackCard('LIV', 'Liverpool', '18 pts', Colors.red)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildComebackCard('TOT', 'Tottenham', '14 pts', Colors.white)),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Attack Patterns
                  const Text('Attack Patterns', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),

                  _buildAttackPatternCard(
                    title: 'SINGLE POINT OF FAILURE',
                    team: 'Brentford',
                    description: '1. Toney scored 55% of goals',
                    icon: Icons.warning_amber,
                    color: Colors.orange,
                    progress: 0.85,
                  ),
                  const SizedBox(height: 16),
                  _buildAttackPatternCard(
                    title: 'DISTRIBUTED ATTACK',
                    team: 'Arsenal',
                    description: '5 Players scored 5+ goals',
                    icon: Icons.group,
                    color: Colors.blue,
                    progress: null,
                  ),

                  const SizedBox(height: 32),

                  // Clutch Involvement
                  const Text('Clutch Involvement', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('Goal events in 75\'+ minutes.', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildClutchPlayer('DN', 'D. Nunez\nLIVERPOOL', '6 Goals', Colors.red),
                      _buildClutchPlayer('OP', 'C. Palmer\nCHELSEA', '5 Goals', Colors.blue),
                      _buildClutchPlayer('OW', 'O. Watkins\nASTON VILLA', '4 Goals', Colors.purple),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPulseCard(String title, String value, String subtitle, IconData icon, Color color) {
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
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
          Text(title, style: const TextStyle(color: Colors.grey)),
          if (subtitle.isNotEmpty) Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildComebackCard(String short, String team, String points, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF162133),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(short, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),
          Text(team, style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 4),
          Text(points, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          const Text('Recovered', style: TextStyle(color: Colors.green)),
        ],
      ),
    );
  }

  Widget _buildAttackPatternCard({
    required String title,
    required String team,
    required String description,
    required IconData icon,
    required Color color,
    double? progress,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF162133),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
                Text(team, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text(description, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          if (progress != null)
            SizedBox(
              width: 60,
              height: 60,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 6,
                    backgroundColor: Colors.grey.shade800,
                    color: Colors.orange,
                  ),
                  Text('${(progress * 100).toInt()}%', style: const TextStyle(color: Colors.white)),
                ],
              ),
            )
          else
            Row(
              children: List.generate(5, (i) => Icon(Icons.circle, size: 12, color: i < 3 ? Colors.blue : Colors.grey.shade600)),
            ),
        ],
      ),
    );
  }

  Widget _buildClutchPlayer(String initials, String name, String goals, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: color,
          child: Text(initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        ),
        const SizedBox(height: 8),
        Text(name, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 12)),
        const SizedBox(height: 4),
        Text(goals, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }
}