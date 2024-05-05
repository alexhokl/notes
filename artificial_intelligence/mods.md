- [Configuration](#configuration)
- [Commands](#commands)
____

# Configuration

Additional configuration required for ollama

```yaml
default-model: codegemma
apis:
  ollama:
    base-url: http://localhost:11434/v1
    api-key-env: NA
    models:
      llama3:
        max-input-chars: 4000
      gemma:
        max-input-chars: 4000
      codegemma:
        max-input-chars: 8000
      mistral:
        max-input-chars: 4000
```

# Commands

##### To edit settings

```sh
mods --settings
```

##### To select a model and start a prompt

```sh
mods -M
```

##### To prompt with a model

```sh
mods -m codellama -f "What is TCP/IP? Be very succint."
```

##### To prompt with JSON data

```sh
cat data.json | mods -f "Summarise this."
```

or

```sh
curl "https://api.tomorrow.io/v4/weather/forecast?location=34.6775912,135.4448383&apikey=${TOMORROW_API_KEY}" 2>/dev/null | mods -f "What is the average temperature? Explain the reasonsing."
```

##### To prompt with a code file

```sh
mods -f "Summarise this." < main.go
```

