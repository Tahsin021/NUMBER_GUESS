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

INSERT_NEW_SESSION=$($PSQL "INSERT INTO sessions(player_id) VALUES($ID)")


RANDOM_NUM=$((RANDOM % 1000 + 1))

GUESS(){
  if [[ $1 ]]
  then
    echo $1
  fi
  read GUESS

  if [[ ! $GUESS =~ ^[0-9]+$ ]]
  then
    GUESS "That is not an integer, guess again:"
  else
    INSERT_NEW_GUESS=$($PSQL "INSERT INTO games(player_id,session) VALUES($ID)")

    if [[ $GUESS -lt $RANDOM_NUM ]]
    then
      GUESS "It's higher than that, guess again:"
    fi

    if [[ $GUESS -gt $RANDOM_NUM ]]
    then
      GUESS "It's lower than that, guess again:"
    fi

    if [[ $GUESS -eq $RANDOM_NUM ]]
    then
      echo "You guessed it in <number_of_guesses> tries. The secret number was $GUESS. Nice job!"
      exit
    fi

  fi
}

GUESS "Guess the secret number between 1 and 1000:"

