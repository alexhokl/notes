#### Week of year

```sh
date +%V
```

#### RFC-3339

##### Date only

```sh
date --rfc-3339=date
```

returns `2019-10-06`

##### Date and time to seconds

```sh
date --rfc-3339=seconds
```

returns `2019-10-06 14:11:50+08:00`


##### Date and time to nano seconds

```sh
date --rfc-3339=ns
```

returns `2019-10-06 14:12:09.755158129+08:00`

#### ISO-8601

##### Date

```sh
date -I
```

returns `2019-10-06`

##### Date and time

```sh
date +%FT%T
```

returns `2019-10-06T12:34:56`

##### Date, time and timezone

```sh
date -Is
```

returns `2019-10-06T14:43:47+08:00`

##### Date time in UTC

```sh
date -u +%FT%TZ
```

returns `2019-10-06T06:48:05Z`
