Overview
CricLive is a Flutter-based application that provides live cricket match details, previous match highlights, and upcoming match schedules. It uses the SportsDevi API to fetch real-time cricket data.

Features
Live Matches: View live scores, team details, and odds.
Previous Matches: Access match highlights and results.
Upcoming Matches: Check schedules for future games.
Betting Odds: Displays odds and payout information.

API Used
SportsDevi API:
Endpoint 1: https://cricket.sportdevs.com/matches?tournament_id=eq.{tournamentID} Fetch Tournament Matches details.
Endpoint 2: https://cricket.sportdevs.com/matches-innings?match_id=eq.{matchID} - Fetch innings details.
Endpoint 3: https://cricket.sportdevs.com/odds/odd-even?match_id=eq.{matchID}- Fetch odds and payouts.

Folder Structure
models/: Data models.
screens/: UI screens like Dashboard, LiveMatchDetails.
utils/: Constants and utilities.
 Whatever data i got from these apis, i have tried my best to implement them, these apis were suggested to me by your team,also in the api documentaion the innings details were to be updated after every 10 secs, but in real it takes quite along time to fetch real time data.
 
