- [Links](#links)
- [HTTP](#http)
- [Collectors](#collectors)
  * [Receivers](#receivers)
  * [Processors](#processors)
  * [Exporters](#exporters)
- [Public cloud support](#public-cloud-support)
- [Languages](#languages)
  * [Go](#go)
  * [Node.js](#node.js)
  * [.NET](#.net)
____

# Links

- [Troubleshooting
  collector](https://github.com/open-telemetry/opentelemetry-collector/blob/main/docs/troubleshooting.md)
- [exporters of
  collectors](https://github.com/open-telemetry/opentelemetry-collector/tree/main/exporter)

# HTTP

Reference: [Traceparent
Header](https://www.w3.org/TR/trace-context/#traceparent-header)

- header `traceparent`
  * contains
    + `version`
    + `trace-id`
    + `parent-id` (this can be undersood as `span-id`)
    + `trace-flags`
  * [examples](https://www.w3.org/TR/trace-context/#traceparent-header)

# Collectors

## Receivers

- feature gate
  * `component.UseLocalHostAsDefaultHost`
    + to use `localhost` instead of `0.0.0.0`
    + or using `127.0.0.1` for IPv4 or `::1` for IPv6

```yaml
receivers:
  otlp:
    protocols:
      grpc:
        endpoint: 127.0.0.1:4317
```

## Processors

- it sits between receivers and exporters
- responsible for processing telemetry before it is analysed
  * examples
    + `redaction` processor to to obfuscate or scrub sensitive data before
      exporting it to a backend
      + it deletes span, log, and metric datapoint attributes that do not match
        a list of allowed attributes
      + it masks attribute values that match a blocked value list

```yaml
processors:
  redaction:
    allow_all_keys: false
    allowed_keys:
      - description
      - group
      - id
      - name
    ignored_keys:
      - safe_attribute
    blocked_values: # Regular expressions for blocking values of allowed span attributes
      - '4[0-9]{12}(?:[0-9]{3})?' # Visa credit card number
      - '(5[1-5][0-9]{14})' # MasterCard number
    summary: debug
```

- filters can be applied

```yaml
processors:
  filter:
    error_mode: ignore
    traces:
      span:
        - attributes["http.request.method"] == nil
```

## Exporters

- batching telemetry and limiting the memory available to a collector can
  prevent out-of-memory errors and usage spikes
  * traffic spikes can be handled by adjusting queue sizes to manage memory
    usage while avoiding data loss

```yaml
exporters:
  otlp:
    endpoint: <ENDPOINT>
    sending_queue:
      queue_size: 800
```

- compression can be applied at exporters to reduce the send size of data and
  conserve network and CPU resources
  * by default, the `otlp` exporter uses `gzip` compression

# Public cloud support

- [Google Cloud](https://cloud.google.com/trace/docs/trace-context#gc-context-propagation)

# Languages

## Go

- [Generate traces and metrics with
  Go](https://cloud.google.com/stackdriver/docs/instrumentation/setup/go)
- [OpenTelemetry: A Guide to Observability with
  Go](https://www.lucavall.in/blog/opentelemetry-a-guide-to-observability-with-go)
- standard library of `context.Context` is used as the implementation of
  OpenTelemetry Context in Go.

## Node.js

- [Generate traces and metrics with
  Node.js](https://cloud.google.com/stackdriver/docs/instrumentation/setup/nodejs)

## .NET

- Span is represented by `System.Diagnoistics.Activity`
