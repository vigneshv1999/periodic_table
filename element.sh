PSQL="psql -X --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ [0-9] ]]
  then
    A="$($PSQL "select * from elements where atomic_number=$1")"
  else
    A="$($PSQL "select * from elements where symbol ilike '$1'")"
    if [[ -z $A ]]
    then
      A="$($PSQL "select * from elements where name ilike '$1'")"
      if [[ -z $A ]]
      then
        echo "I could not find that element in the database."
        exit
      fi
    fi
  fi
  echo "$A" | while IFS='|' read an s e
  do
    B="$($PSQL "select atomic_mass,melting_point_celsius,boiling_point_celsius,type_id from properties where atomic_number=$an")"
    echo "$B" | while IFS='|' read am mp bp ti
    do
      C="$($PSQL "select type from types where type_id=$ti")"
      echo "$C" | while IFS='|' read t
      do
        echo "The element with atomic number $an is $e ($s). It's a $t, with a mass of $am amu. $e has a melting point of $mp celsius and a boiling point of $bp celsius."
      done
    done
  done
fi