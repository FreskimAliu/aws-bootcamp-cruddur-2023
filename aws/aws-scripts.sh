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

# Define the menu options
options=("Create Billing Alarm" "Create Monthly Budget")

# Prompt the user to select an option
PS3="Select a function: "
select option in "${options[@]}"
do
  case $option in
    "Create Billing Alarm")
      create-billing-alarm
      ;;
    "Create Monthly Budget")
      create-monthly-budget
      ;;
    *)
      echo "Invalid option. Please select a valid option."
      ;;
  esac
done
