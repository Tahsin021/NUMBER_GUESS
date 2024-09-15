#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo "Enter your username:"
read NAME
if [[ ${#NAME} -le 22 && $NAME =~ ^[A-Za-z]+$ ]]
then
      ID=$($PSQL "SELECT player_id FROM players WHERE name='$NAME'")

    if [[ -z $ID ]]
    then
      echo "Welcome, $NAME! It looks like this is your first time here."
      INSERT_NAME=$($PSQL "INSERT INTO players(name) VALUES('$NAME')")
      ID=$($PSQL "SELECT player_id FROM players WHERE name='$NAME'")
    else
      SESSIONS_WITH_CURRENT_ID=$($PSQL "SELECT COUNT(session) FROM sessions WHERE player_id=$ID;")
      MIN_SCORE=$($PSQL "SELECT MIN(COUNTS) AS min  FROM (SELECT COUNT(player_id) AS COUNTS FROM games WHERE player_id=$ID GROUP BY session) AS sub;")
      echo "Welcome back, $NAME! You have played $SESSIONS_WITH_CURRENT_ID games, and your best game took $MIN_SCORE guesses."
    fi

    INSERT_NEW_SESSION=$($PSQL "INSERT INTO sessions(player_id) VALUES($ID)")
    CURRENT_SESSION=$($PSQL "SELECT session FROM sessions WHERE player_id=$ID ORDER BY session DESC LIMIT 1")

    RANDOM_NUM=$((RANDOM % 1000 + 1))

    GUESS(){
      if [[ $1 ]]
      then
        echo $1
      fi
      read GUESS

      if [[ $GUESS =~ ^[0-9]+$ ]] && (( $GUESS >= 1 && $GUESS <= 1000 ))
      then
        INSERT_NEW_GUESS=$($PSQL "INSERT INTO games(player_id,session) VALUES($ID,$CURRENT_SESSION)")

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
          GUESSES_IN_CURRENT_SESSION=$($PSQL "SELECT COUNT(player_id) FROM games WHERE session=$CURRENT_SESSION;")
          echo "You guessed it in $GUESSES_IN_CURRENT_SESSION tries. The secret number was $GUESS. Nice job!"
          exit
        fi
      else
        GUESS "That is not an integer, guess again:"
      fi
    }

    GUESS "Guess the secret number between 1 and 1000:"
fi


