#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  #add winner team to teams table if not present
  if [[ $WINNER != "winner" ]]
  then
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'") #if team is present in teams table, choose it
    if [[ -z $WINNER_ID ]] #check if team exists in teams table, if not then add
    then
      INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')") #result of adding team to table
      if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]] #checking if added correctly
      then
        echo Added team: $WINNER
      fi
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'") #choosing existing team now
    fi
  fi

  #add opponent team to teams table if not present
  if [[ $OPPONENT != "opponent" ]]
  then
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'") #if team is present in teams table, choose it
    if [[ -z $OPPONENT_ID ]] #check if team exists in teams table, if not then add
    then
      INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')") #result of adding team to table
      if [[ $INSERT_OPPONENT_RESULT == "INSERT 0 1" ]] #checking if added correctly
      then
        echo Added team: $OPPONENT
      fi
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'") #choosing existing team now
    fi
  fi

  #insert to games table
  if [[ $YEAR != "year" ]]
  then
    INSERT_GAMES_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    if [[ $INSERT_GAMES_RESULT == "INSERT 0 1" ]]
    then
      echo Inserted into games table: Game of $YEAR $WINNER $WINNER_GOALS-$OPPONENT_GOALS $OPPONENT
    fi
  fi
done