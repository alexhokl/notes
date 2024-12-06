- [Links](#links)
- [Commands](#commands)
____

# Links

- [ollama/ollama](https://github.com/ollama/ollama)
- [models](https://ollama.com/library)
- [infiniflow/ragflow](https://github.com/infiniflow/ragflow) - a
  Retrieval-Augmented Generation engine
- [alexhokl/ollama-rag](https://github.com/alexhokl/ollama-rag)
- [alexhokl/ollama-image](https://github.com/alexhokl/ollama-image)

# Commands

##### To pull Docker image

```sh
docker pull docker.io/ollama/ollama:latest
```

##### To run ollama server on Docker

```sh
docker run -d -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama
```

- by default, it runs command `ollama serve`
- it creates a docker volume named `ollama` to store the model files

##### To run ollama server on Mac

```sh
brew services start ollama
```

##### To use a remote instance

```sh
OLLAMA_HOST=https://example.com/ollama ollama run gemma:2b
```

assuming port `11434` is used

##### To pull a model

```sh
ollama pull llama3
ollama pull llama3:70b
ollama pull gemma:2b
ollama pull gemma:7b
```

##### To list models available locally

```sh
ollama list
```

##### To show context length

```sh
ollama show llama3.1:8b
```

##### To start a chat bot

```sh
ollama run llama3
```

##### API usage

```sh
curl http://localhost:11434/api/generate -d '{
  "model": "llama3",
  "prompt":"What is TCP/IP?"
}'
```

```sh
xh post http://localhost:11434/api/generate model=llama3 prompt="What is TCP/IP?"
```

##### Summarise a code file

```sh
ollama run llama3 "Summarise $(cat /Users/someone/main.go)"
```

##### To create a modelfile from a model

```sh
ollama show llama3 --modelfile > llama3.modelfile
```

##### To creata a model with a modelfile

```sh
ollama create custom_model --modelfile llama3.modelfile
```

