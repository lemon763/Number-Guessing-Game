#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo "Enter your username:"
read USERNAME

USERNAME_AVL=$($PSQL "SELECT username FROM users WHERE username='$USERNAME'")
GAME_PLAYED=$($PSQL "SELECT COUNT(*) FROM users INNER JOIN games USING (user_id) WHERE username='$USERNAME'")
BEST_GAME=$($PSQL "SELECT min(number_guesses) FROM games INNER JOIN users USING (user_id) WHERE username='$USERNAME'")

if [[ -z $USERNAME_AVL ]]
then
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  INSERT_USER=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
else
  echo "Welcome back, $USERNAME! You have played $GAME_PLAYED games, and your best game took $BEST_GAME guesses."
fi

#RANDOM_NUM = $((1 + $RANDOM % 1000))
RANDOM_NUM=$(( RANDOM % 100 + 1 ))
GUESS=1
echo "Guess the secret number between 1 and 1000:"

while read NUM
do
  if ! [[ $NUM =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
  else
    if [[ $NUM -eq $RANDOM_NUM ]]
    then
      break;
    else
      if [[ $NUM -gt $RANDOM_NUM ]]
      then
        echo "It's lower than that, guess again:"
      elif [[ $NUM -lt $RANDOM_NUM ]]
      then
        echo "It's higher than that, guess again:"
      fi
    fi
  fi
  GUESS=$(( GUESS + 1 ))
done

if [[ $GUESS == 1 ]]
then 
  echo "You guessed it in $GUESS tries. The secret number was $RANDOM_NUM. Nice job!"
else
  echo "You guessed it in $GUESS tries. The secret number was $RANDOM_NUM. Nice job!"
fi

USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")

INSERT_GAME=$($PSQL "INSERT INTO games(number_guesses, user_id) VALUES($GUESS, $USER_ID)")
