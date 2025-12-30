import 'package:flutter/material.dart';

class ComebackKingsScreen extends StatefulWidget {
  const ComebackKingsScreen({super.key});

  @override
  State<ComebackKingsScreen> createState() => _ComebackKingsScreenState();
}

class _ComebackKingsScreenState extends State<ComebackKingsScreen> {
  String selectedTab = 'All';

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
          'Comeback Kings',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Text(
                'Teams that refuse to lose when trailing.\nHighlighting resilience and dramatic turnarounds across major competitions.',
                style: TextStyle(color: Colors.grey[400], fontSize: 14),
              ),
            ),

            const SizedBox(height: 16),

            // Time filter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: ['Current season', 'All Time'].map((tab) {
                  final isSelected = tab == 'Current season';
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(tab),
                        selected: isSelected,
                        onSelected: (_) {},
                        selectedColor: const Color(0xFF1E2A3B),
                        backgroundColor: Colors.transparent,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey,
                        ),
                        side: BorderSide(
                          color: isSelected ? Colors.blue : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 16),

            // Competition tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['All', 'Premier League', 'La Liga', 'Serie A'].map(
                    (comp) {
                      final isSelected = selectedTab == comp;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(comp),
                          selected: isSelected,
                          onSelected: (_) => setState(() => selectedTab = comp),
                          selectedColor: Colors.blue,
                          backgroundColor: const Color(0xFF1E2A3B),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey[400],
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
            ),

            const SizedBox(height: 12),
            Center(
              child: Text(
                '2023/2024',
                style: TextStyle(color: Colors.grey[500]),
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  _buildComebackCard(
                    league: 'PREMIER LEAGUE',
                    logo: 'LIV',
                    team: 'Liverpool',
                    opponent: 'vs Newcastle United',
                    score: '2 - 1',
                    result: 'Won',
                    scores: ['0 - 1', '1 - 1', '2 - 1'],
                    minutes: ['25\'', '81\'', '90+3\''],
                  ),
                  const SizedBox(height: 16),
                  _buildComebackCard(
                    league: 'PREMIER LEAGUE',
                    logo: 'MUN',
                    team: 'Man Utd',
                    opponent: 'vs Nott\'m Forest',
                    score: '3 - 2',
                    result: 'Won',
                    scores: ['0 - 2', '1 - 2', '2 - 2', '3 - 2'],
                    minutes: ['4\'', '17\'', '52\'', '78\''],
                    highlight: 'FROM 2 GOALS DOWN',
                  ),
                  const SizedBox(height: 16),
                  _buildComebackCard(
                    league: 'LA LIGA',
                    logo: 'RMA',
                    team: 'Real Madrid',
                    opponent: 'vs Almeria',
                    score: '3 - 2',
                    result: 'Won',
                    scores: ['0 - 2', '1 - 2', '2 - 2', '3 - 2'],
                    minutes: ['HT', '57\'', '67\'', '90+9\''],
                    highlight: '9TH MIN WINNER',
                  ),
                  const SizedBox(height: 16),
                  _buildComebackCard(
                    league: 'LA LIGA',
                    logo: 'GET',
                    team: 'Getafe',
                    opponent: 'vs Barcelona',
                    score: '0 - 0',
                    result: 'Draw',
                    note: 'Resisted 15 shots with 10 men',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComebackCard({
    required String league,
    required String logo,
    required String team,
    required String opponent,
    required String score,
    required String result,
    List<String>? scores,
    List<String>? minutes,
    String? highlight,
    String? note,
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
          Text(
            league,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFF2A374A),
                child: Text(
                  logo,
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
                      team,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(opponent, style: TextStyle(color: Colors.grey[400])),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(
                    score,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        result == 'Won' ? Icons.arrow_upward : Icons.remove,
                        color: result == 'Won' ? Colors.green : Colors.orange,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        result,
                        style: TextStyle(
                          color: result == 'Won' ? Colors.green : Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          if (scores != null) ...[
            const SizedBox(height: 16),
            if (highlight != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  highlight,
                  style: const TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(height: 8),
            const Text(
              'SCORE PROGRESSION',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                scores.length,
                (i) => Column(
                  children: [
                    Text(
                      scores[i],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      minutes![i],
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 4,
              color: Colors.grey[800],
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: 0.9,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.red, Colors.blue],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
          if (note != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                note,
                style: const TextStyle(color: Colors.orange),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
