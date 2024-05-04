- [Links](#links)
- [Commands](#commands)
____

# Links

- [ollama/ollama](https://github.com/ollama/ollama)
- [models](https://ollama.com/library)
- [infiniflow/ragflow](https://github.com/infiniflow/ragflow) - a
  Retrieval-Augmented Generation engine

# Commands

##### To pull Docker image

```sh
docker pull docker.io/ollama/ollama:latest
```

##### To run ollama server

```sh
docker run -d -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama
```

- by default, it runs command `ollama serve`
- it creates a docker volume named `ollama` to store the model files

##### To pull a model

```sh
docker exec -it ollama ollama pull llama3
```

```sh
docker exec -it ollama ollama pull llama3:70b
docker exec -it ollama ollama pull gemma:2b
docker exec -it ollama ollama pull gemma:7b
```

##### To list models available locally

```sh
docker exec -it ollama ollama list
```

##### To start a chat bot

```sh
docker exec -it ollama ollama run llama3
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
docker exec -it ollama ollama run llama3 "Summarise $(cat /Users/someone/main.go)"
```

