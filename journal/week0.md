# Week 0 — Billing and Architecture

## Creating Billing Alarm & Budgets

For this I created a Bash script that provides a simple menu-driven interface for creating various resources related to monitoring and cost control in AWS.
The script defines three functions: create-billing-alarm, create-monthly-budget & create-health-dashboard-notification.
![Monitoring and Cost Menu](../_docs/assets/monitoring-cost-menu.png)

### Create Billing Alarm
This function creates a CloudWatch alarm for billing-related metrics and sends notifications to an SNS topic subscribed by the email address specified in the function. It updates a JSON file (json/alarm_config.json) with the SNS topic ARN and creates the CloudWatch alarm based on the updated file. After creating the alarm, it removes the JSON file.
![Billing Alarm](../_docs/assets/billing-alarm.png)

### Create Monthly Budget
This function creates a budget for AWS account and subscribes an SNS topic to the budget. It takes the account ID from the user's AWS credentials and uses two JSON files (json/budget.json and json/notifications-with-subscribers.json) to create the budget and add the SNS topic subscription.
![Monthly Budget](../_docs/assets/monthly-budget.png)

### Create Health Dashboard Notification
This function creates an SNS topic and subscribes an email address to the topic. It then creates an Amazon CloudWatch Events rule to send Health events to the SNS topic. After creating the rule, it adds the SNS topic as a target to the rule.
![Health Dashboard Notification](../_docs/assets/health-dashboard-rule.png)
