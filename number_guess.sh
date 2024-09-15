#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo "Enter your username:"
read NAME

ID=$($PSQL "SELECT player_id FROM players WHERE name='$NAME'")

if [[ -z $ID ]]
then
  echo "Welcome, $NAME! It looks like this is your first time here."
  INSERT_NAME=$($PSQL "INSERT INTO players(name) VALUES('$NAME')")
  ID=$($PSQL "SELECT player_id FROM players WHERE name='$NAME'")
else
  echo "Welcome back, $NAME! You have played <games_played> games, and your best game took <best_game> guesses."
fi

echo "Guess the secret number between 1 and 1000:"
read GUESS