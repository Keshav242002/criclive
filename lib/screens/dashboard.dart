import 'package:criclive/models/getmatchinfo.dart';
import 'package:criclive/screens/livematchdetails.dart';
import 'package:criclive/screens/matchDetails.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:criclive/utils/constants.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  static const id = 'dashboard';

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<GetMatchInfo> matches = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchMatchData();
  }

  Future<void> fetchMatchData() async {
    try {
      var headers = {
        'Authorization': 'Bearer vRK9s_YuLUiKZ2_kBZKbBw',
      };
      var dio = Dio();
      final response = await dio.request(
        'https://cricket.sportdevs.com/matches?start_time=gte.2025-01-16&tournament_id=eq.11462',
        options: Options(
          method: 'GET',
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        setState(() {
          matches = data.map((json) => GetMatchInfo.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Error: ${response.statusMessage}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  String getTeamAbbreviation(String teamName) {
    return teamName.split(' ').map((word) => word[0]).join('');
  }

  void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Big Bash League Matches',
          style: TextStyle(color: kColorWhite),
        ),
        backgroundColor: kColorMidNightBlue,
      ),
      backgroundColor: Colors.grey[200],
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!))
          : Column(
        children: [
          if (matches.where((match) => match.statusType == 'live').isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Live Matches',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: matches.where((match) => match.statusType == 'live').length,
                      itemBuilder: (context, index) {
                        final liveMatches = matches
                            .where((match) => match.statusType == 'live')
                            .toList();
                        final match = liveMatches[index];
                        final date = match.startTime;

                        final homeAbbreviation = getTeamAbbreviation(match.homeTeamName);
                        final awayAbbreviation = getTeamAbbreviation(match.awayTeamName);

                        return GestureDetector(
                          onTap: () {
                            final matchId = match.id;
                            print('Tapped live match ID: $matchId');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LiveMatchdetails(matchId: matchId),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 16),
                            width: 150,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      bottomLeft: Radius.circular(8),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${date.day}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const Text(
                                        'JAN',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 4.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '$homeAbbreviation vs $awayAbbreviation',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${date.hour}:${date.minute.toString().padLeft(2, '0')} AM',
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

          if (matches
              .where((match) => match.statusType == 'upcoming')
              .isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Coming Soon',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: matches
                          .where((match) =>
                      match.statusType == 'upcoming')
                          .length,
                      itemBuilder: (context, index) {
                        final upcomingMatches = matches
                            .where((match) =>
                        match.statusType == 'upcoming')
                            .toList();
                        final match = upcomingMatches[index];
                        final date = match.startTime;

                        final homeAbbreviation =
                        getTeamAbbreviation(match.homeTeamName);
                        final awayAbbreviation =
                        getTeamAbbreviation(match.awayTeamName);

                        return Container(
                          margin: const EdgeInsets.only(right: 16),
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                decoration: const BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    bottomLeft: Radius.circular(8),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${date.day}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const Text(
                                      'JAN',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 4.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '$homeAbbreviation vs $awayAbbreviation',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${date.hour}:${date.minute.toString().padLeft(2, '0')} AM',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          if (matches
              .where((match) =>
          match.statusType != 'upcoming' &&
              match.statusType != 'live')
              .isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Previous Matches',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: matches
                          .where((match) =>
                      match.statusType != 'upcoming' &&
                          match.statusType != 'live')
                          .length,
                      itemBuilder: (context, index) {
                        final previousMatches = matches
                            .where((match) =>
                        match.statusType != 'upcoming' &&
                            match.statusType != 'live')
                            .toList();
                        final match = previousMatches[index];

                        final homeAbbreviation =
                        getTeamAbbreviation(
                            match.homeTeamName);
                        final awayAbbreviation =
                        getTeamAbbreviation(
                            match.awayTeamName);

                        final homeScore =
                            match.homeTeamScore?.display ?? 0;
                        final awayScore =
                            match.awayTeamScore?.display ?? 0;

                        final subtitle = match.statusType == 'finished'
                            ? '${homeScore > awayScore ? homeAbbreviation : awayAbbreviation} wins by ${homeScore > awayScore ? homeScore : awayScore}'
                            : ' ${match.status.reason}';

                        return GestureDetector(
                          onTap: () {
                            if (match.statusType == 'canceled') {
                              showSnackBar(context,
                                  'This match was canceled. No relevant data available.');
                            } else {
                              final matchId = match.id;
                              print('Tapped match ID: $matchId');

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PreviousMatchdetails(
                                          matchId: matchId),
                                ),
                              );
                            }
                          },
                          child: Container(
                            margin:
                            const EdgeInsets.only(right: 16),
                            width: 150,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.circular(8),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  decoration: const BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      bottomLeft:
                                      Radius.circular(8),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${match.startTime.day}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight:
                                          FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const Text(
                                        'JAN',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight:
                                          FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                        vertical: 4.0),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '$homeAbbreviation vs $awayAbbreviation',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight:
                                            FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          subtitle,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
