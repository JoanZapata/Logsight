#  Logsight

**Logsight** is a macOS application for visualizing **one or multiple structured log files** encoded in **JSON**.

## Rationale 

On most applications, especially on the server side, logging in plain text quickly becomes limited, and we tend to generate structured logs instead, usually using **JSON** as a format. Structured logging is very powerful for debugging but it makes log files not so human-readable:

```json
{"@timestamp":"2019-01-01T15:13:12.762+01:00","@version":"1","message":"Starting WebApplication","logger_name":"com.joanzapata.logger","thread_name":"main","level":"INFO","level_value":20000}
{"@timestamp":"2019-01-01T15:13:12.784+01:00","@version":"1","message":"No active profile set, falling back to default profiles: default","logger_name":"com.joanzapata.logger","thread_name":"main","level":"INFO","level_value":20000}
…
```

Logsight is being developed to aggregate multiple files like that in real time and make them browsable and readable.

## Current state

Logsight is currently in a very early version:
* Handles drag-and-drop of one or multiple files into it;
* Parses JSON content and displays the filename, date, log level and message for each log;
* Adds new logs as soon as they are written in the source files;
* Allows filtering the logs by file and log level.

![Logsight screenshot](/Medias/screenshot.png)

## License

```
Copyright 2019 Joan Zapata

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
