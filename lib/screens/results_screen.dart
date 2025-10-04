import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/matches.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  List<Matches> allMatches = [];
  List<Matches> filteredMatches = [];

  bool isLoading = true;
  String? error;

  String? selectedSeason;
  String? selectedTeam;

  @override
  void initState() {
    super.initState();
    fetchMatches();
  }

  Future<void> fetchMatches() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final response = await http.get(
        Uri.parse('https://mpira-analytics.vercel.app/api/matches'),
      );

      if (response.statusCode == 200) {
        final matchesList = matchesFromJson(response.body);

        setState(() {
          allMatches = matchesList;
          isLoading = false;
        });

        _applyFilters();
      } else {
        setState(() {
          error = 'Failed to load matches: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error loading matches: $e';
        isLoading = false;
      });
    }
  }

  void _applyFilters() {
    List<Matches> temp = List.from(allMatches);

    if (selectedSeason != null && selectedSeason!.isNotEmpty) {
      temp = temp.where((m) => m.season == selectedSeason).toList();
    }

    if (selectedTeam != null && selectedTeam!.isNotEmpty) {
      temp = temp
          .where(
            (m) =>
                m.homeTeam.toLowerCase().contains(selectedTeam!.toLowerCase()) ||
                m.awayTeam.toLowerCase().contains(selectedTeam!.toLowerCase()),
          )
          .toList();
    }

    setState(() {
      filteredMatches = temp;
    });
  }

  List<String> _getSeasons() {
    return allMatches.map((m) => m.season).toSet().toList()..sort();
  }

  List<String> _getTeams() {
    final teams = <String>{};
    for (var match in allMatches) {
      teams.add(match.homeTeam);
      teams.add(match.awayTeam);
    }
    return teams.toList()..sort();
  }

  @override
  Widget build(BuildContext context) {
    final seasons = _getSeasons();
    final teams = _getTeams();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Match Results'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchMatches,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? _buildError()
              : RefreshIndicator(
                  onRefresh: fetchMatches,
                  child: ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      // Filters
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Season Dropdown
                          DropdownButtonFormField<String>(
                            value: selectedSeason,
                            decoration: const InputDecoration(
                              labelText: 'Select Season',
                              border: OutlineInputBorder(),
                            ),
                            items: seasons
                                .map(
                                  (season) => DropdownMenuItem(
                                    value: season,
                                    child: Text(season),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedSeason = value;
                              });
                              _applyFilters();
                            },
                          ),
                          const SizedBox(height: 12),

                          // Team Dropdown
                          DropdownButtonFormField<String>(
                            value: selectedTeam,
                            decoration: const InputDecoration(
                              labelText: 'Select Team',
                              border: OutlineInputBorder(),
                            ),
                            items: teams
                                .map(
                                  (team) => DropdownMenuItem(
                                    value: team,
                                    child: Text(team),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedTeam = value;
                              });
                              _applyFilters();
                            },
                          ),
                          const SizedBox(height: 8),

                          // Clear Filters
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  selectedSeason = null;
                                  selectedTeam = null;
                                  filteredMatches = allMatches;
                                });
                              },
                              icon: const Icon(Icons.clear),
                              label: const Text('Clear Filters'),
                            ),
                          ),
                          const Divider(),
                        ],
                      ),

                      // Match List
                      if (filteredMatches.isEmpty)
                        const Padding(
                          padding: EdgeInsets.only(top: 64.0),
                          child: Center(
                            child: Text(
                              'No matches found',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      else
                        ...filteredMatches
                            .map((match) => _buildMatchCard(match))
                            .toList(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            error!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.red),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: fetchMatches,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchCard(Matches match) {
    final isLive = match.finalScore.toUpperCase() == 'LIVE';
    final scoreColor = isLive ? Colors.red : Colors.black87;

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Season and Date Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Season ${match.season}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                Text(
                  match.matchDate,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Teams and Score
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        match.homeTeam,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        match.awayTeam,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  children: [
                    if (isLive)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'LIVE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    else
                      Text(
                        match.finalScore,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: scoreColor,
                        ),
                      ),
                    if (!isLive && match.halfTime.isNotEmpty)
                      Text(
                        'HT: ${match.halfTime}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 8),
            const Center(
              child: Text(
                'VS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
