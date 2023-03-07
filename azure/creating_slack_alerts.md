Prerequisite: the user needs to have the following permissions

- `Microsoft.AlertsManagement/alerts/*`
- `Microsoft.AlertsManagement/alertsSummary/*`
- `Microsoft.Insights/actiongroups/*`
- `Microsoft.Insights/activityLogAlerts/*`
- `Microsoft.Insights/AlertRules/*`
- `Microsoft.Insights/components/*`
- `Microsoft.Insights/dataCollectionEndpoints/*`
- `Microsoft.Insights/dataCollectionRules/*`
- `Microsoft.Insights/dataCollectionRuleAssociations/*`
- `Microsoft.Insights/eventtypes/*`
- `Microsoft.Insights/LogDefinitions/*`
- `Microsoft.Insights/metricalerts/*`
- `Microsoft.Insights/MetricDefinitions/*`
- `Microsoft.Insights/Metrics/*`
- `Microsoft.Insights/Register/Action`
- `Microsoft.Insights/scheduledqueryrules/*`
- `Microsoft.Insights/webtests/*`
- `Microsoft.Insights/workbooks/*`
- `Microsoft.Insights/workbooktemplates/*`
- `Microsoft.Insights/privateLinkScopes/*`
- `Microsoft.Insights/privateLinkScopeOperationStatuses/*`
- `Microsoft.OperationalInsights/workspaces/write`
- `Microsoft.OperationalInsights/workspaces/intelligencepacks/*`
- `Microsoft.OperationalInsights/workspaces/savedSearches/*`
- `Microsoft.OperationalInsights/workspaces/search/action`
- `Microsoft.OperationalInsights/workspaces/sharedKeys/action`
- `Microsoft.OperationalInsights/workspaces/storageinsightconfigs/*`
- `Microsoft.Support/*`
- `Microsoft.WorkloadMonitor/monitors/*`
- `Microsoft.AlertsManagement/smartDetectorAlertRules/*`
- `Microsoft.AlertsManagement/actionRules/*`
- `Microsoft.AlertsManagement/smartGroups/*`
- `Microsoft.Web/serverfarms/Write`
- `Microsoft.Storage/storageAccounts/write`
- `Microsoft.Web/sites/Write`
- `Microsoft.Resources/deployments/validate/action`
- `Microsoft.Logic/workflows/write`
- `Microsoft.Resources/deployments/write`
- `Microsoft.Web/connections/Join/Action`
- `Microsoft.Logic/workflows/triggers/listCallbackUrl/action`
- `Microsoft.Logic/workflows/enable/action`
- `Microsoft.Logic/workflows/disable/action`
- `Microsoft.Web/connections/Write`
- `microsoft.web/connections/listconsentlinks/action`
- `Microsoft.Logic/workflows/triggers/run/action`

To send a message on Slack for something happened on Azure, the following
components has to be created.

- Azure Logic App
  * It is responsible to create a web hook to receive calls from Azure Alerts
    and calling Slack API to send a message.
- Azure Alerts
  * It monitors the metrics configured. If the metric reaches the configured
    threshold, it will send alert and invoke all web hooks it is configured.

Although the sequence of the following steps does not matter, it is easier to
start with Logic App first.

Log onto Azure Portal and search for Logic App.

It is easier to create a Logic App by cloning the existing one sending a similar
Slack message. Thus, click on the Logic App you want to clone and select `Clone`
from the top menu.

Enter a name for the newly cloned Logic App.

Once a Logic App has been created (it might take a minute or two), click on the
app and select Logic App Designer. Expand `Post Message` by clicking on it.

Edit the message. Once you are done, press `Save` to complete the setup.

Click the `Change connection` link at the bottom of `Post message` to register
your own slack connection for the slack notification.

Click `Change connection`.

Click `Add` new to set your own slack connection or choose the existing one.

Since the Logic App has been setup, we are ready to create an alert. The
following assumes we will be sending an alert when there is a particular event
/ log line occurs.

We can start by writing a Kusto query in Azure Log Analytics Workspaces. Once we
are happy with the query, we can click on `New Alert Rule` to start creating an
alert.

Enter the conditions required for the rule to send an alert. Once you done,
click on `Action.`

Click on `Create action group`.

Select logging as resource group and fill in action group name and display name.
Click on `Actions` tab.

Select `Logic App` as action type, fill in the name of action, select the
resource group of the newly created Logic App and select the Logic App itself.
Once you are done, click on `OK` to close the prompt on the right and click on
tab `Details`.

Select a severity. Usually it is either `Error` or `Warning`. Fill in the name
of alert rule. And click on `Review+Create`.

Follow on-screen instructions to complete the creation. This also completes all
the steps required and the alert should be activated by now.
