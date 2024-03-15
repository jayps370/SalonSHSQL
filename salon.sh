#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon -t -c"
echo -e "\n~~ Welcome to Salon ~~\n\nServices :"
# List of Services
MAIN_MENU(){
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi


SERVICE=$($PSQL "SELECT * FROM SERVICES")
echo "$SERVICE" | while read SERVICE_ID BAR NAME
do
  echo "$SERVICE_ID) $NAME"
done

echo -e "\nSelect service:"
read SERVICE_ID_SELECTED

case $SERVICE_ID_SELECTED in
1) HAIRCUT;;
2) MANICURE;;
3) MASSAGE;;
*) MAIN_MENU "I could not find that service. What would you like today?";;
esac
}



HAIRCUT(){
echo "Hair Cut"
}
MANICURE(){
echo "Manicure"
}
MASSAGE(){
echo "Massage"
}

MAIN_MENU
# Get service name
SERVICE=$($PSQL "select name from services where service_id = $SERVICE_ID_SELECTED")
if [[ -z $SERVICE ]]
  then
    MAIN_MENU "I could not find that service. What would you like today?"
fi

# Get customer phone
echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE

# Get customer ID
CUSTOMER_ID=$($PSQL "select customer_id from customers where phone = '$CUSTOMER_PHONE'")
# If no customer ID
if [[ -z $CUSTOMER_ID ]]
then
# Get customer name
echo -e '\nI don't have a record for that phone number, what's your name?'
read CUSTOMER_NAME
# Insert new customer
CUSTOMER_INSERT_RESULT=$($PSQL "INSERT INTO customers(name,phone) VALUES('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
CUSTOMER_ID=$($PSQL "select customer_id from customers where phone = '$CUSTOMER_PHONE'")
else
CUSTOMER_NAME=$($PSQL "select name from customers where phone = '$CUSTOMER_PHONE'")
fi

# Appointment Time
echo -e "\nWhat time would you like your $SERVICE, $CUSTOMER_NAME?"
read SERVICE_TIME

# Create an appointment
APPOINTMENT_RESULT=$($PSQL "insert into appointments(customer_id,service_id,time) values($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")

# Greet customer with their appointment schedule
echo -e "\nI have put you down for a $SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."