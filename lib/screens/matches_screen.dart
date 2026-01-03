import 'package:flutter/material.dart';
import 'package:mpira_analytics_app/models/matches_response.dart';
import 'package:mpira_analytics_app/models/competitions.dart';
import '../api_client.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  String selectedTab = 'Played';
  final ApiClient _apiClient = ApiClient();
  List<Datum> competitions = [];
  List<Match> matches = [];
  String? selectedSeason;
  String? selectedCompetition;
  int currentPage = 1;
  bool isLoading = true;
  bool hasMoreMatches = true;
  Pagination pagination = Pagination(
    page: 1,
    limit: 50,
    total: 0,
    totalPages: 1,
    hasNext: false,
    hasPrev: false,
  );

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      await Future.wait([_loadCompetitions(), _loadMatches()]);
    } catch (e) {
      print('Error initializing data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadCompetitions() async {
    try {
      final competitionsData = await _apiClient.getCompetitions();

      setState(() {
        competitions = competitionsData.data;
        // Set default season to latest if available
        if (competitions.isNotEmpty) {
          selectedSeason = competitions.first.season;
        }
      });
    } catch (e) {
      print('Error loading competitions: $e');
      // Handle error appropriately - show snackbar or retry button
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load competitions: $e')),
      );
    }
  }

  Future<void> _loadMatches({bool refresh = false}) async {
    if (refresh) {
      setState(() {
        currentPage = 1;
        matches.clear();
        isLoading = true;
      });
    } else {
      setState(() {
        isLoading = true;
      });
    }

    try {
      final matchesData = await _apiClient.getSeasonMatches(
        season: selectedSeason,
        page: currentPage,
        limit: 50,
      );

      setState(() {
        if (refresh) {
          matches = matchesData.data.matches;
        } else {
          matches.addAll(matchesData.data.matches);
        }
        pagination = matchesData.data.pagination;
        hasMoreMatches = pagination.hasNext;
        selectedSeason = matchesData.data.season;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading matches: $e');
      setState(() {
        isLoading = false;
      });
      // Show user-friendly error
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load matches: $e')));
    }
  }

  // Group matches by month and competition for display
  Map<String, Map<String, List<Match>>> _groupMatchesByMonthAndCompetition() {
    final Map<String, Map<String, List<Match>>> grouped = {};

    for (final match in matches) {
      final monthKey = match.monthKey;
      final competitionName = match.competition.name;

      if (!grouped.containsKey(monthKey)) {
        grouped[monthKey] = {};
      }

      if (!grouped[monthKey]!.containsKey(competitionName)) {
        grouped[monthKey]![competitionName] = [];
      }

      grouped[monthKey]![competitionName]!.add(match);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final groupedMatches = _groupMatchesByMonthAndCompetition();
    final sortedMonths = groupedMatches.keys.toList()
      ..sort((a, b) => b.compareTo(a)); // Sort descending

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
                  IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () {
                      // Implement search functionality
                    },
                  ),
                ],
              ),
            ),

            // Season and Competition Dropdowns
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  // Season Dropdown
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E2A3B),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedSeason,
                          dropdownColor: const Color(0xFF1E2A3B),
                          style: const TextStyle(color: Colors.white),
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                          ),
                          items: competitions
                              .map((comp) => comp.season)
                              .toSet()
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
                              _loadMatches(refresh: true);
                            });
                          },
                          hint: const Text(
                            'Select Season',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Competition Dropdown
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E2A3B),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedCompetition,
                          dropdownColor: const Color(0xFF1E2A3B),
                          style: const TextStyle(color: Colors.white),
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                          ),
                          items: [
                            const DropdownMenuItem(
                              value: null,
                              child: Text('All Competitions'),
                            ),
                            ...competitions
                                .where((comp) => comp.season == selectedSeason)
                                .map(
                                  (comp) => DropdownMenuItem(
                                    value: comp.name,
                                    child: Text(comp.name),
                                  ),
                                )
                                .toList(),
                          ],
                          onChanged: (value) {
                            setState(() {
                              selectedCompetition = value;
                              // Filter matches by competition
                            });
                          },
                          hint: const Text(
                            'All Competitions',
                            style: TextStyle(color: Colors.grey),
                          ),
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

            // Matches List - now with real data
            Expanded(
              child: isLoading && matches.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : matches.isEmpty
                  ? const Center(
                      child: Text(
                        'No matches found',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: sortedMonths.length + (hasMoreMatches ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == sortedMonths.length) {
                          // Load more button
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      setState(() {
                                        currentPage++;
                                      });
                                      _loadMatches();
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1E2A3B),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'Load More',
                                      style: TextStyle(color: Colors.white),
                                    ),
                            ),
                          );
                        }

                        final monthKey = sortedMonths[index];
                        final monthData = groupedMatches[monthKey]!;
                        final monthName =
                            monthData.values.first.first.monthName;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildMonthHeader(monthName),
                            ...monthData.entries.map((compEntry) {
                              final competitionName = compEntry.key;
                              final compMatches = compEntry.value;
                              final competition = compMatches.first.competition;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLeagueHeader(
                                    competitionName,
                                    _getCompetitionColor(competition.type),
                                    subtitle: competition.type,
                                  ),
                                  ...compMatches.map(
                                    (match) => _buildMatchRow(
                                      _formatDate(match.date),
                                      match.homeTeam.name,
                                      '${match.scoreHome ?? 0} - ${match.scoreAway ?? 0}',
                                      match.awayTeam.name,
                                      isLive: _isMatchLive(match.date),
                                      liveMinute: _getLiveMinute(match.date),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              );
                            }).toList(),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods remain the same...
  String _formatDate(DateTime date) {
    return '${_getMonthAbbrev(date.month)} ${date.day}';
  }

  String _getMonthAbbrev(int month) {
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];
    return months[month - 1];
  }

  Color _getCompetitionColor(String type) {
    switch (type.toLowerCase()) {
      case 'league':
        return Colors.blue;
      case 'cup':
        return Colors.purple;
      case 'friendly':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  bool _isMatchLive(DateTime matchDate) {
    final now = DateTime.now();
    final difference = now.difference(matchDate);
    return difference.inMinutes >= 0 && difference.inHours < 2;
  }

  int _getLiveMinute(DateTime matchDate) {
    final now = DateTime.now();
    final difference = now.difference(matchDate);
    return difference.inMinutes;
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
