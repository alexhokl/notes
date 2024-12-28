- [Links](#links)
- [SLI](#sli)
- [SLO](#slo)
- [Alerting](#alerting)
___

## Links

- [Google SRE book](https://sre.google/sre-book/table-of-contents/)
- [Google SRE workbook](https://sre.google/workbook/table-of-contents/)

## SLI

## SLO

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
