#!/bin/bash

set -e

function create-billing-alarm {
    local TOPIC_ARN=$(aws sns create-topic --name billing-alarm-topic --output text)
    EMAIL_ADDRESS="freskimaliu@gmail.com"

    # Subscribe the email address to the SNS topic
    aws sns subscribe \
        --topic-arn $TOPIC_ARN \
        --protocol email \
        --notification-endpoint $EMAIL_ADDRESS \
        --return-subscription-arn \
        --output text

    # Wait for the subscription to be confirmed
    while true; do
        SUBSCRIPTION_STATUS=$(aws sns list-subscriptions-by-topic \
            --topic-arn $TOPIC_ARN \
            --query 'Subscriptions[0].SubscriptionArn' \
            --output text)
        if [ "$SUBSCRIPTION_STATUS" != "PendingConfirmation" ]; then
            printf "Subscription confirmed\n"
            break
        else
            printf "Subscription status: %s\n" "$SUBSCRIPTION_STATUS"
            sleep 10
        fi
    done

    # The subscription is now confirmed, continue with the script
    printf "Subscribed to %s with %s\n" "$TOPIC_ARN" "$EMAIL_ADDRESS"

    # Update json file to get SNS Topic ARN
    jq --arg value "$TOPIC_ARN" '.AlarmActions[0] = $value' json/alarm_config.json.example > json/alarm_config.json
    printf "Generated new alarm_config.json file\n"

    # Put metric alarm
    aws cloudwatch put-metric-alarm --cli-input-json file://json/alarm_config.json
    printf "Created new billing alarm\n"

    rm json/alarm_config.json
    printf "Removed alarm_config.json file\n"
}

function create-monthly-budget {
    # function code goes here
    local AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

    aws budgets create-budget \
        --account-id $AWS_ACCOUNT_ID \
        --budget file://json/budget.json \
        --notifications-with-subscribers file://json/notifications-with-subscribers.json
}

function create-health-dashboard {
  local TOPIC_ARN=$(aws sns create-topic --name my-health-topic --output text)
  EMAIL_ADDRESS="freskimaliu@gmail.com"

  # Subscribe the email address to the SNS topic
  aws sns subscribe \
    --topic-arn $TOPIC_ARN \
    --protocol email \
    --notification-endpoint $EMAIL_ADDRESS \
    --return-subscription-arn \
    --output text

  # Wait for the subscription to be confirmed
  while true; do
    SUBSCRIPTION_STATUS=$(aws sns list-subscriptions-by-topic \
        --topic-arn $TOPIC_ARN \
        --query 'Subscriptions[0].SubscriptionArn' \
        --output text)
    if [ "$SUBSCRIPTION_STATUS" != "PendingConfirmation" ]; then
        printf "Subscription confirmed\n"
        break
    else
        printf "Subscription status: %s\n" "$SUBSCRIPTION_STATUS"
        sleep 10
    fi
  done
  
  # The subscription is now confirmed, continue with the script
  printf "Subscribed to %s with %s\n" "$TOPIC_ARN" "$EMAIL_ADDRESS"

  # Create an Amazon CloudWatch Events rule to send Health events to the SNS topic 
  aws events put-rule --name health-dashboard-rule --event-pattern '{"source": ["aws.health"]}' --state ENABLED --description "Health events to SNS topic"

  # Add a target to the CloudWatch Events rule 
  aws events put-targets --rule health-dashboard-rule --targets "Id"="1","Arn"="$TOPIC_ARN"
}

# Color variables
green='\e[32m'
blue='\e[34m'
clear='\e[0m'

# Color functions
ColorGreen(){
 echo -ne $green$1$clear
}
ColorBlue(){
 echo -ne $blue$1$clear
}

menu(){
echo -ne "
Monitoring & Cost Menu 
$(ColorGreen '1)') Create billing alarm
$(ColorGreen '2)') Create monthly budget
$(ColorGreen '3)') Create health dashboard
$(ColorGreen '0)') Exit
$(ColorBlue 'Choose an option:') "
 read a
 case $a in
 1) create-billing-alarm ; menu ;;
 2) create-monthly-budget ; menu ;;
 3) create-health-dashboard ; menu ;;
 0) exit 0 ;;
 *) echo -e $red"Wrong option."$clear;
WrongCommand;;
 esac
}
# Call the menu function
menu
