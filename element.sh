#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c" 

$($PSQL "DELETE FROM properties WHERE atomic_number = 1000")
$($PSQL "DELETE FROM elements WHERE atomic_number = 1000")
$($PSQL "ALTER TABLE properties RENAME COLUMN type TO category")

ELEMENT_OUTPUT() {
  FORMATTED_ATOMIC_NUMBER=$(echo $ATOMIC_NUMBER | sed 's/ |/"/')
  FORMATTED_NAME=$(echo $NAME | sed 's/ |/"/')
  FORMATTED_SYMBOL=$(echo $SYMBOL | sed 's/ |/"/')
  FORMATTED_CATEGORY=$(echo $CATEGORY | sed 's/ |/"/')
  FORMATTED_MASS=$(echo $ATOMIC_MASS | sed 's/ |/"/')
  FORMATTED_MELTING=$(echo $MELTING_POINT | sed 's/ |/"/')
  FORMATTED_BOILING=$(echo $BOILING_POINT | sed 's/ |/"/')

  echo "The element with atomic number $FORMATTED_ATOMIC_NUMBER is "$FORMATTED_NAME" ("$FORMATTED_SYMBOL"). It's a "$FORMATTED_CATEGORY", with a mass of $FORMATTED_MASS amu. "$FORMATTED_NAME" has a melting point of $FORMATTED_MELTING celsius and a boiling point of $FORMATTED_BOILING celsius."

}

SEARCH_ELEMENT_INFO() {
  NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $ATOMIC_NUMBER")
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ATOMIC_NUMBER")
  CATEGORY=$($PSQL "SELECT category FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
  ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
  MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
  BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
  ELEMENT_OUTPUT
}

  # if input is a number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER=${1}
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $ATOMIC_NUMBER")
    if [[ -z $NAME ]]
    then 
      echo "I could not find that element in the database."
    else
      SEARCH_ELEMENT_INFO
    fi
  # if input is not a number
  elif [[ ! -z $1 && ! $1 =~ ^[0-9]+$ ]]
  then 
    length=${#1}
    if [[ $length > 2 ]]
      then
        NAME=${1}
        ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$NAME'")
        if [[ -z $ATOMIC_NUMBER ]]
        then 
          echo "I could not find that element in the database."
        else
          SEARCH_ELEMENT_INFO
        fi
    else
        SYMBOL=${1}
        ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$SYMBOL'")
        if [[ -z $ATOMIC_NUMBER ]]
        then 
          echo "I could not find that element in the database."
        else
          SEARCH_ELEMENT_INFO
        fi
    fi
  else 
    # if input is not a number nor a text
    echo "Please provide an element as an argument."
  fi
