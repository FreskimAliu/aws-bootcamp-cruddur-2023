# Week 0 — Billing and Architecture

## Destroy your root account credentials & Set MFA
<div style="text-align:center">
  <img src="../_docs/assets/root-user.png" width="75%">
</div>

## Creating Billing Alarm & Budgets

For this I created a Bash script that provides a simple menu-driven interface for creating various resources related to monitoring and cost control in AWS.
The script defines three functions: create-billing-alarm, create-monthly-budget & create-health-dashboard-notification.

<div style="text-align:center">
  <img src="../_docs/assets/monitoring-cost-menu.png" width="75%">
</div>

### Create Billing Alarm
This function creates a CloudWatch alarm for billing-related metrics and sends notifications to an SNS topic subscribed by the email address specified in the function. It updates a JSON file (json/alarm_config.json) with the SNS topic ARN and creates the CloudWatch alarm based on the updated file. After creating the alarm, it removes the JSON file.

<div style="text-align:center">
  <img src="../_docs/assets/billing-alarm.png" width="75%">
</div>

### Create Monthly Budget
This function creates a budget for AWS account and subscribes an SNS topic to the budget. It takes the account ID from the user's AWS credentials and uses two JSON files (json/budget.json and json/notifications-with-subscribers.json) to create the budget and add the SNS topic subscription.

<div style="text-align:center">
  <img src="../_docs/assets/monthly-budget.png" width="75%">
</div>

I included three thresholds for this monthy budget:
* When Actual Cost > 85%
* When Actual Cost > 100%
* When Forecasted Cost > 100%

<div style="text-align:center">
  <img src="../_docs/assets/budget-thresholds.png" width="75%">
</div>

### Create Health Dashboard Notification
This function creates an SNS topic and subscribes an email address to the topic. It then creates an Amazon CloudWatch Events rule to send Health events to the SNS topic. After creating the rule, it adds the SNS topic as a target to the rule.

<div style="text-align:center">
  <img src="../_docs/assets/health-dashboard-rule.png" width="75%">
</div>

## Support ticket and service limit
### Service Quotas
I requested a service quotas increase for S3 buckets. Currently I have 100 buckets service limit and I requested to increase it to 200.
<div style="text-align:center">
  <img src="../_docs/assets/request-quota-increase.png" width="75%">
</div>

### Support ticket
Automatically it opened a support ticket:
<div style="text-align:center">
  <img src="../_docs/assets/support-case.png" width="75%">
</div>
