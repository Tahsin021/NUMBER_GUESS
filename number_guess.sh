#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=<database_name> -t --no-align -c"

echo "Enter your username:"
read NAME

ID=$($PSQL "SELECT player_id FROM players WHERE name=$NAME")

if [[ -z $ID ]]
then
  echo "Welcome, $NAME! It looks like this is your first time here."
  INSERT_NAME=$($PSQL "INSERT INTO players(name) VALUES($NAME)")
  ID=$($PSQL "SELECT player_id FROM players WHERE name=$NAME")
fi

