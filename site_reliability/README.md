- [Links](#links)
- [SLO](#slo)
- [Alerting](#alerting)
___

## Links

- [Google SRE book](https://sre.google/sre-book/table-of-contents/)
- [Google SRE workbook](https://sre.google/workbook/table-of-contents/)

## SLO

- Service Level Objective
- striking the right balance between investing in functionality that will win
  new customers or retain current ones, versus investing in the reliability and
  scalability that will keep those customers happy, is difficult
  * a well-thought-out and adopted SLO is key to making data-informed decisions
    about the opportunity cost of reliability work, and to determining how to
    appropriately prioritize that work
- adoption of error budget-based SRE
  * SLOs that all stakeholders in the organization have approved as being fit
    for the product
  * the people responsible for ensuring that the service meets its SLO have
    agreed that it is possible to meet this SLO under normal circumstances
  * the organization has committed to using the error budget for decision making
    and prioritizing; this commitment is formalized in an error budget policy
  * a process in place for refining the SLO
- an SLO sets a target level of reliability for the service’s customers; above
  this threshold, almost all users should be happy with your service
- ownership of SLOs
  *  CTO for a small organization
  *  product owner or product manager in larger organizations
- Service Level Indicator (SLI)
  * recommended to treat the SLI as the ratio of two numbers
    + the number of good events divided by the total number of events
- request-driven service
  * availability
    + the proportion of requests that resulted in a successful response
    + prometheus example
      + `sum(rate(http_requests_total{host="api", status!~"5.."}[7d])) / sum(rate(http_requests_total{host="api"}[7d]))`
    + error budget example
      + 97% availability with a 4-week total API requests of 1M
        + 1M * 0.03 = 30K errors in 4 weeks
  * latency
    + the proportion of requests that were faster than some threshold
    + prometheus example
      + `histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[7d]))`
    + error budget example
      + 95th percentile latency of 100ms with a 4-week total API requests of 1M
        + 1M * 0.05 = 50K requests slower than 100ms in 4 weeks
- SLO window
  * rolling window
    + closely aligned with user experience
    + recommendation
      + integral number of weeks so that it always contains the same number of
        weekends
      + 4 weeks
  * calendar-aligned window
    + closely aligned with business planning and project work
    + NOT RECOMMENDED
  * shorter window
  * allow decisions to be made more quickly
    + if you missed your SLO for the previous week, then small course
      corrections can help avoid SLO violations in future weeks
- agreement
  * product managers have to agree that this threshold is good enough for
    users—performance below this value is unacceptably low and worth spending
    engineering time to fix
  * getting the error budget policy approved by all key stakeholders, including
    the product manager, the development team, and the SREs, is a good test for
    whether the SLOs are fit for purpose
- error budget
  * it can be derived from SLO
  * policy can be made and outlining what to do when a service run out of budget
    + to make enforcement decisions
      + the specific actions that must be taken and who will take them
  * it helps determine the scale of an incident according to the proportion of
    the error budget consumed
- review
  * how often you review an SLO document depends on the maturity of your SLO
    culture
    + when starting out, you should probably review the SLO frequently, perhaps
      every month
    + once the appropriateness of the SLO becomes more established, you can
      likely reduce reviews to happen quarterly or even less frequently
- improving SLO (not the service quality)
  * count the manually detected outages; count support tickets too.
    + check these periods correlate with steep drops in error budget.
  * look at times when SLIs indicate an issue, or a service fell out of SLO
    + check if these time periods correlate with known outages or an increase in support tickets
  * plot a graph of the error budget consumption of per day over tickets per day
    + using [Spearman’s rank correlation
      coefficient](https://en.wikipedia.org/wiki/Spearman%27s_rank_correlation_coefficient)
      can be a useful way to quantify these relationship
    + outliers should be investigated as well
- critical user journeys should have it SLOs defined first

## Alerting

- measures
  * precision
    + the proportion of events detected that were significant
    + if precision is less than 100%, the alerting system is generating
      false positives
  * recall
    + the proportion of significant events detected
    + if recall is less than 100%, the alerting system is missing some
      significant events
  * detection time
  * reset time

- error budget
  * number of allowed bad events
- error rate
  * ratio of bad events to total events

- strategies
  * Target Error Rate ≥ SLO Threshold
    + Prometheus expression
      + `sum(rate(slo_errors[10m])) by (job) / sum(rate(slo_requests[10m])) by (job) >= 0.001`
    + detection time
      + alerting windows size / reporting period
    + pros
      + good detection time in case of total outage
      + fires on any event that threatens the SLO, which implies a good recall
    + cons
      + precision is low
        + fires at any event that threatens the SLO during the window period,
          but it may not threaten daily or monthly SLO at all
  * Increased Alert Window
    + Prometheus expression
      + `sum(rate(slo_errors[36h])) by (job) / sum(rate(slo_requests[36h])) by (job) >= 0.001`
    + detection time
      + ((1 - SLO) / error ratio) * alerting windows size
    + pros
      + acceptable detection time in case of total outage
      + better precision
    + cons
      + very poor reset time
      + expensive as a lot of data has to be aggregated
  * Incrementing Alert Duration
    + Prometheus expression
      + `sum(rate(slo_errors[1m])) by (job) / sum(rate(slo_requests[1m])) by (job) >= 0.001` for `1h`
    + pros
      + higher precision
    + cons
      + poor reacll time in case of high error rate but not sustained long
        enough to trigger an alert and spent a lot of error budget
      + poor detection time in case of total outage
    + NOT RECOMMENDED
  * Alert on Burn Rate
    + burn rate of 1 means error budget is consumed at a rate that it would be
      exactly zero at the end of the SLO time window
      + with an SLO of 99.9% over a time window of 30 days, a constant 0.1%
        error rate uses exactly all of the error budget: a burn rate of 1
    + detection time
      + ((1 - SLO) / error ratio) * alerting windows size * burn rate
    + Prometheus expression
      + `sum(rate(slo_errors[1h])) by (job) / sum(rate(slo_requests[1h])) by (job) >= 36 * 0.001` pros
      + good precision
      + cleaper as the window is relatively small
      + good detection time in case of total outage
    + cons
      + low recall time
      + reset time is still long
  * Multiple Burn Rate Alerts
    + not every event needs paging someone; thus, for event of rate of budget
      consumption provides adequate time to address (such as the day after), it
      is better to create a ticket instead
    + recommendation
      + paging
        + 2% budget consumption in 1 hour
        + 5% budget consumption in 6 hours
      + ticket
        + 10% budget consumption in 3 days
    + pros
      + ability to adapt the monitoring configuration to many situations
        according to criticality
      + good precision
      + good recall (3-day window for tickets)
      + ability to choose the most appropriate alert type
    + cons
      + long reset time
  * Multiwindow, Multi-Burn-Rate Alerts
    + add a shorter window to check if the error budget is still being consumed
      at the time tiggerring an alert
    + recommendation
      + 1/12 of the duration of the long window
    + pros
      + a flexible alerting framework that allows you to control the type of
        alert according to the severity of the incident and the requirements of the
        organization.
      + good precision
      + good recall
    + Prometheus expression
```promql
sum(rate(slo_errors[1h])) by (job) / sum(rate(slo_requests[1h])) by (job) >= 14 * 0.001)
and
sum(rate(slo_errors[5m])) by (job) / sum(rate(slo_requests[5m])) by (job) >= 14 * 0.001)
```

- low-traffic services and error budget alerting
  * generating artificial traffic
  * combining services
  * lowing the SLO or increasing the window

- scaling alerting
  * it is advised against specifying the alert window and burn rate parameters
    independently for each service, because doing so quickly becomes
    overwhelming; once alerting parameters has been decided, apply them to
    all services
