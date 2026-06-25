- [Large Language Models (LLMs)](#large-language-models-llms)
  * [Links](#links)
  * [Ollama](#ollama)
    + [Characteristics](#characteristics)
    + [Commands](#commands)
  * [MLX](#mlx)
    + [Local Agentic AI Stack](#local-agentic-ai-stack)
    + [MLX community](#mlx-community)
    + [Libraries and servers](#libraries-and-servers)
  * [Paramters](#paramters)
    + [Temperature](#temperature)
    + [Top-K](#top-k)
    + [Top-P](#top-p)
  * [Prompt engineering](#prompt-engineering)
    + [Tips](#tips)
____

# Large Language Models (LLMs)

## Links

- [ollama/ollama](https://github.com/ollama/ollama)
- [models](https://ollama.com/library)
- [infiniflow/ragflow](https://github.com/infiniflow/ragflow) - a
  Retrieval-Augmented Generation engine
- [parakeet-nest/parakeet](https://github.com/parakeet-nest/parakeet) - a GoLang
  library, made to simplify the development of small generative AI applications
  with Ollama; [documentation](https://parakeet-nest.github.io/parakeet/)
- [open-webui/open-webui](https://github.com/open-webui/open-webui) - a web
  interface for Ollama
- [alexhokl/ollama-rag](https://github.com/alexhokl/ollama-rag)
- [alexhokl/ollama-image](https://github.com/alexhokl/ollama-image)
- [llm-ollama](https://github.com/taketwo/llm-ollama) - a plugin for Python
  program `llm` to interact with Ollama

## Ollama

### Characteristics

- `gemma3`
  * although the context window is large, bias towards beginning of the context
    is noticeable and it leads to wrong answer in case of question asked on
    a specific part of context
  * prompts written in Japanese but response is return in English
  * translation from Japanese Kenji to Kana is not very accurate
  * vision
    + the orientation and resolution of an image matters
      + examples
        + words in a rotated image cannot be recognised correctly
        + words may not be recognised correctly if the resolution is too high
          but the words are relative small in the image
    + some Japanese words are not recognised correctly such as Kana
    + it could not read Japanese written vertically

### Commands

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

##### To allow other machines accessing the server

```sh
OLLAMA_HOST=0.0.0.0:11434 ollama serve
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

## MLX

### Local Agentic AI Stack

- Local agent
  * Xcode, Opencode, Pi
-	MLX-LM Server
  * Ollama, LM Studio, [vLLM](https://vllm.ai/)
-	MLX-LM
-	MLX

### MLX community

- [mlx-community on Hugging Face](https://huggingface.co/mlx-community)
- [models from mlx-community](https://huggingface.co/mlx-community/models?sort=downloads)

### Libraries and servers

- [ml-explore/mlx-lm](https://github.com/ml-explore/mlx-lm) - text only
- [Blaizzy/mlx-vlm](https://github.com/Blaizzy/mlx-vlm) - vision (VLM) and audio
  and video (Omni models)
- [Blaizzy/mlx-audio](https://github.com/Blaizzy/mlx-audio) - audio only
  * not all models available from `mlx-community` on Hugging Face are supported

#### Commands

##### To transscribe an audio

```sh
mlx_audio.stt.generate --model mlx-community/whisper-large-v3-turbo-asr-fp16 --audio audio.wav --output-path script.txt
```

##### To generate speech from text

```sh
mlx_audio.tts.generate --model mlx-community/Qwen3-TTS-12Hz-0.6B-Base-bf16 --text "$(cat text)" --output_path .
```

Note that option `--output_path` is a specification of a directory.

Note that most of the options highly depending on the model used. For instance,
`gender` or `voice` may not be available for some models and will be silently
ignored.

## Paramters

### Temperature

Temperature `0` implies the process creates deterministic outcomes.

A higher temperature implies the process allows creation of outcomes with lower
probabilities.

### Top-K

If `top-K` is set to `3`, the model picks from the first 3 choices in terms of
probability.

### Top-P

If `Top-P` is set to `0.7`, the model would select words with probability of
`0.3` and higher.

## Prompt engineering

In prompt engineering, ask the model to indicate if it is not sure about the
answer (where the probability is low). Such as "Answer 'I am not sure' if you
are not sure about answer)

In prompt engineering, role playing is a way to give context to the model.

### Tips

- mathematical problems
  * break it down for the model by asking the questions in smaller pieces
- give example
- take advantage of chat history (hence, giving more context)
- currently, models understand programming language better than human languages
- for a conversation requires more than the maximum number of tokens of a model,
  a trick can be used is that to ask the model to summarise the conversation so
  far and store the summary to database storage and replay it later.


