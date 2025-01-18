import 'dart:async';
import 'dart:convert';

import 'package:criclive/models/livematchdetails.dart';
import 'package:criclive/screens/dashboard.dart';
import 'package:criclive/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class LiveMatchdetails extends StatefulWidget {
  final int matchId;
  const LiveMatchdetails({required this.matchId, super.key});
  static const id = "pmd";

  @override
  State<LiveMatchdetails> createState() => _LiveMatchdetailsState();
}

class _LiveMatchdetailsState extends State<LiveMatchdetails>
    with WidgetsBindingObserver {
  List<LiveMatchModel> liveMatchData = [];
  Timer? _pollingTimer;
  Timer? _oddsPollingTimer;

  List<dynamic> oddsData = [];
  String bookmakerName = 'N/A';
  double oddValue = 0.0;
  double evenValue = 0.0;
  double payout = 0.0;
  bool isLoading = true;
  bool isFirstLoad = true;



  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    fetchLiveMatchData(); // Fetch initial match data
    fetchOddsData(); // Fetch initial odds data
    _startPolling(); // Start match API polling
    _startOddsPolling(); // Start odds API polling
  }


  @override
  void dispose() {
    _pollingTimer?.cancel(); // Cancel polling
    WidgetsBinding.instance.removeObserver(this); // Remove lifecycle observer
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startPolling(); // Resume polling when app comes to foreground
    } else if (state == AppLifecycleState.paused) {
      _pollingTimer?.cancel(); // Pause polling when app goes to background
    }
  }
  void _startOddsPolling() {
    _oddsPollingTimer?.cancel(); // Ensure no duplicate timers
    _oddsPollingTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
      print('Polling Odds API at ${DateTime.now()}');
      fetchOddsData();
    });
  }


  void _startPolling() {
    _pollingTimer?.cancel(); // Ensure no duplicate timers
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      print('Polling API at ${DateTime.now()}'); // Debug statement for polling
      fetchLiveMatchData();
    });
  }
  Future<void> fetchLiveMatchData({int offset = 0, int limit = 50}) async {
    try {
      if (isFirstLoad) {
        setState(() {
          isLoading = true;
        });
      }
      print('Fetching live match data...');
      var headers = {
        'Authorization': 'Bearer vRK9s_YuLUiKZ2_kBZKbBw',
      };
      var dio = Dio();
      final response = await dio.get(
        'https://cricket.sportdevs.com/matches-innings',
        queryParameters: {
          'match_id': 'eq.${widget.matchId}',
          'offset': offset,
          'limit': limit,
        },
        options: Options(
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        List<LiveMatchModel> data =
        liveMatchModelFromJson(json.encode(response.data));
        setState(() {
          liveMatchData = data; // Update live match data
        });
      } else {
        print('Error: ${response.statusMessage}');
      }
    } catch (e) {
      print('Error fetching match data: $e');
    } finally {
      if (isFirstLoad) {
        setState(() {
          isLoading = false; // Stop loading after the first load
          isFirstLoad = false; // Mark the first load as complete
        });
      }
    }
  }

  Future<void> fetchOddsData() async {
    try {
      if (isFirstLoad) {
        setState(() {
          isLoading = true; // Show loading only for the first load
        });
      }
      print('Fetching odds data...');
      var headers = {
        'Authorization': 'Bearer vRK9s_YuLUiKZ2_kBZKbBw',
      };
      var dio = Dio();
      final response = await dio.request(
        'https://cricket.sportdevs.com/odds/odd-even?match_id=eq.${widget.matchId}',
        options: Options(
          method: 'GET',
          headers: headers,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;

        if (data.isNotEmpty) {
          final periods = data[0]['periods'] as List<dynamic>?;
          if (periods != null && periods.isNotEmpty) {
            final odds = periods[0]['odds'] as List<dynamic>?;
            if (odds != null && odds.isNotEmpty) {
              final firstOdd = odds[0];
              setState(() {
                bookmakerName = firstOdd['bookmaker_name'] ?? 'Unknown';
                oddValue = _parseDouble(firstOdd['odd']);
                evenValue = _parseDouble(firstOdd['even']);
                payout = _parseDouble(firstOdd['payout']);
              });
            }
          }
        }
      } else {
        print('Error: ${response.statusMessage}');
      }
    } catch (e) {
      print('Error fetching odds data: $e');
    } finally {
      if (isFirstLoad) {
        setState(() {
          isLoading = false; // Stop loading after the first load
          isFirstLoad = false; // Mark the first load as complete
        });
      }
    }
  }



  double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }







  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      // Show loading indicator only for the first load
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (liveMatchData.isEmpty) {
      // Show "No match data available" only if lists are empty
      return const Scaffold(
        body: Center(
          child: Text('No match data available'),
        ),
      );
    }


    final currentInning = liveMatchData[0].innings.last;

    // Get the current batters
    final currentBatters = currentInning.battingLines
        .where((player) => player.wicketTypeName == WicketTypeName.BATTING)
        .toList();

    // Get the current bowler (last bowler in the list)
    final currentBowler = currentInning.bowlingLines.isNotEmpty
        ? currentInning.bowlingLines.last
        : null;

    return Scaffold(
      backgroundColor: kColorWhite,
      appBar: AppBar(
        backgroundColor: kColorMidNightBlue,
        title: const Text(
          'Live Match Details',
          style: TextStyle(color: kColorWhite),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          iconSize: 20,
          color: kColorWhite,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Dashboard()),
            );
          },
        ),
      ),
      body: Column(
        children: [
          // Match Summary
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 240,
                color: kColorBase,
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kColorBase,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Display batting team abbreviation and score/wickets
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${getTeamAbbreviation(liveMatchData[0].innings.last.battingTeamName)} '
                                '${liveMatchData[0].innings.last.score}/${liveMatchData[0].innings.last.wickets}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),

                      // Display bowling team abbreviation (or "Yet To Bat" if applicable)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          liveMatchData[0].innings.length > 1
                              ? Text(
                            '${getTeamAbbreviation(liveMatchData[0].innings.first.battingTeamName)} '
                                '${liveMatchData[0].innings.first.score}/${liveMatchData[0].innings.first.wickets}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          )
                              : Text(
                            '${getTeamAbbreviation(liveMatchData[0].innings.first.bowlingTeamName)} Yet To Bat',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),


            ],
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Overs: ${liveMatchData[0].innings.last.overs}'),
                Text('Wides: ${liveMatchData[0].innings.last.wide}'),
                Text('Extras: ${liveMatchData[0].innings.last.extra}'),
                Text('No Balls: ${liveMatchData[0].innings.last.noBall}'),
              ],
            ),
          ),

          // Current Batters
          if (currentBatters.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Batters',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  ...currentBatters.map(
                        (batter) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(batter.playerName),
                          Text('${batter.score} runs (${batter.balls} balls)'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          // Current Bowler
          if (currentBowler != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Bowler',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(currentBowler.playerName),
                      Text(
                          '${currentBowler.over} overs, ${currentBowler.run} runs, ${currentBowler.wicket} wickets'),
                    ],
                  ),
                ],
              ),
            ),
          Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Bookmaker name
                Center(
                  child: Text(
                    bookmakerName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                // Odds and Even values
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text(
                          'Odd',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          oddValue.toString(),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text(
                          'Even',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          evenValue.toString(),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),
                // Payout
                Center(
                  child: Text(
                    'Payout: $payout',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          )

        ],
      ),
    );
  }

  String getTeamAbbreviation(String teamName) {
    return teamName.split(' ').map((word) => word[0]).join('').toUpperCase();
  }
}
