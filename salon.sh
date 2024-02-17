#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --no-align --tuples-only -c"

echo -e "\nWelcome to Helen's Salon!\n"

SERVICE_MENU() {
  if [[ $1 ]] 
  then
  echo $1
  fi
  echo -e "\nHow may I help you today?\n"
  SERVICES=$($PSQL "SELECT service_id, name FROM services")
  echo "$SERVICES" | sed 's/|/) /g'
  read SERVICE_ID_SELECTED
  SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE service_id=$SERVICE_ID_SELECTED")

  #if service id doesn't exist
  if [[ -z $SERVICE_ID ]] 
  then
  #go to service menu
  SERVICE_MENU "Please enter a valid service."
   #else ask for phone number CUSTOMER_PHONE
   else
   SERVICE=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID")
   echo -e "\nWhat is your phone number?"
   read CUSTOMER_PHONE
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  #if phone number doesn't exist, ask for name CUSTOMER_NAME
  if [[ -z $CUSTOMER_ID ]]
  then
  echo -e "\n What is your name?"
  read CUSTOMER_NAME
  #insert name and number into customers table
  CUSTOMER=$($PSQL "INSERT INTO customers (phone,name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

  fi
   #ask for time SERVICE_TIME
   CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  echo -e "\nWhat time would you like your appointment, $CUSTOMER_NAME?"
  read SERVICE_TIME
  #enter into appointments table
  APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID, '$SERVICE_TIME')")
   #output
  echo -e "\nI have put you down for a $SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."

  fi


  }

SERVICE_MENU