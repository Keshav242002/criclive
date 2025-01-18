import 'dart:convert';
import 'package:criclive/models/previousMatchDetailsModel.dart';
import 'package:criclive/screens/dashboard.dart';
import 'package:criclive/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class PreviousMatchdetails extends StatefulWidget {
  final int matchId;
  const PreviousMatchdetails({required this.matchId, super.key});
  static const id = "pmd";

  @override
  State<PreviousMatchdetails> createState() => _PreviousMatchdetailsState();
}

class _PreviousMatchdetailsState extends State<PreviousMatchdetails> {
  List<PreviousMatchModel> previousMatchData = [];
  bool isLoading = true; // Add a loading state

  @override
  void initState() {
    super.initState();
    fetchPreviousMatchData();
  }

  Future<void> fetchPreviousMatchData() async {
    try {
      var headers = {
        'Authorization': 'Bearer vRK9s_YuLUiKZ2_kBZKbBw',
      };
      var dio = Dio();
      final response = await dio.request(
        'https://cricket.sportdevs.com/matches-innings?match_id=eq.${widget.matchId.toString()}',
        options: Options(
          method: 'GET',
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        List<PreviousMatchModel> data =
        previousMatchModelFromJson(json.encode(response.data));
        setState(() {
          previousMatchData = data;
          isLoading = false; // Set loading to false
        });
        print('Fetched match data: $previousMatchData'); // Debug print
      } else {
        print('Error: ${response.statusMessage}');
        setState(() {
          isLoading = false; // Set loading to false on error
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false; // Set loading to false on error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kColorMidNightBlue,
        title: const Text(
          'Match Highlights',
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loader if loading
          : previousMatchData.isEmpty
          ? const Center(child: Text('No match data available')) // Handle empty state
          : Column(
        children: [
          Stack(
            children: [
              // Big Container
              Container(
                width: double.infinity,
                height: 240,
                color: kColorBase,
              ),
              // Winning Team Abbreviation and Run Difference
              Positioned(
                top: 100, // Adjust this value to place it in the middle
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    _getWinningMessage(), // Call helper function for the message
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              // Small Container at Bottom
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${getTeamAbbreviation(previousMatchData[0].innings[0].battingTeamName)} ${previousMatchData[0].innings[0].score}/${previousMatchData[0].innings[0].wickets}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${getTeamAbbreviation(previousMatchData[0].innings[1].battingTeamName)} ${previousMatchData[0].innings[1].score}/${previousMatchData[0].innings[1].wickets}',
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
        ],
      ),
    );
  }


  String getTeamAbbreviation(String teamName) {
    return teamName.split(' ').map((word) => word[0]).join('').toUpperCase();
  }

  String _getWinningMessage() {
    if (previousMatchData.isNotEmpty && previousMatchData[0].innings.length >= 2) {
      final inning1 = previousMatchData[0].innings[0];
      final inning2 = previousMatchData[0].innings[1];

      if (inning1.score > inning2.score) {
        final runDifference = inning1.score - inning2.score;
        return '${getTeamAbbreviation(inning1.battingTeamName)} won by $runDifference ${runDifference == 1 ? "run" : "runs"}';
      } else if (inning2.score > inning1.score) {
        final runDifference = inning2.score - inning1.score;
        return '${getTeamAbbreviation(inning2.battingTeamName)} won by $runDifference ${runDifference == 1 ? "run" : "runs"}';
      } else {
        return 'Match Tied';
      }
    }
    return ''; // Return an empty string if data is invalid
  }

}
