- [Links](#links)
  * [People](#people)
  * [Courses](#courses)
  * [Services](#services)
  * [Tools](#tools)
- [Concepts](#concepts)
  * [General concepts](#general-concepts)
  * [Retrieval augmented generation (RAG)](#retrieval-augmented-generation-rag)
  * [Tricks with LLM](#tricks-with-llm)
- [Machine Learning](#machine-learning)
  * [Links](#links-1)
- [Tools](#tools-1)
  * [GitHub Copilot](#github-copilot)
  * [Continue](#continue)
  * [yt-dlp](#yt-dlp)
  * [whisper](#whisper)
    + [Links](#links-2)
    + [Commands](#commands)
  * [tts](#tts)
    + [Links](#links-3)
    + [Commands](#commands-1)
  * [easyocr](#easyocr)
    + [Links](#links-4)
    + [Commands](#commands-2)
  * [pdftotext](#pdftotext)
____

# Links

## People

- [Sam Witteveen](https://www.youtube.com/@samwitteveenai)
- [Matt Williams](https://www.youtube.com/@technovangelist)

## Courses

- [MIT Computer Science Class 6.S184: Generative AI with Stochastic Differential
  Equations](https://www.youtube.com/watch?v=GCoP2w-Cqtg&list=PL57nT7tSGAAUDnli1LhTOoCxlEPGS19vH)
- [Stanford CS229: Machine
  Learning](https://www.youtube.com/watch?v=jGwO_UgTS7I&list=PLoROMvodv4rMiGQp3WXShtMGgzqpfVfbU)

## Services

- [Ai2 Playground](https://playground.allenai.org/)
- [Ai2 OpenScholar](https://openscholar.allen.ai/)
- [Julius AI](https://juliusai.com/) - analysing structured data and answering
  questions using generative AI
- [bolt](https://bolt.new/) - generate apps using generative AI
- [n8n](https://n8n.io/) - workflow automation tool
- [weaviate](https://weaviate.io/) - vector search engine
- [Common Voice](https://commonvoice.mozilla.org/en) - a service for sharing,
  creating and curating text and speech datasets
  * it is a source of data set

## Tools

- [mergestat/scribe](https://github.com/mergestat/scribe) - a CLI tool for
  translating natural language prompts into SQL queries using the OpenAI API
- [LLM Visualization](https://bbycroft.net/llm)

# Concepts

## Generative AI

### Tools

- [ollama](./ollama.md)
- [langchain](./langchain.md)
- [stable-diffusion](./stable-diffusion.md)

### General concepts

- [Embedding models](https://ollama.com/blog/embedding-models)
  * embedding models, making it possible to build RAG applications that combine
    text prompts with existing documents or other data
  * embedding models are models that are trained specifically to generate vector
    embeddings: long arrays of numbers that represent semantic meaning for
    a given sequence of text
    + the resulting vector embedding arrays can then be stored in a database,
      which will compare them as a way to search for data that is similar in
      meaning.
  * examples
    * [alexhokl/ollama-rag](https://github.com/alexhokl/ollama-rag)
    * [Local RAG agent with llama3 using
      LangChain](https://github.com/langchain-ai/langgraph/blob/main/examples/rag/langgraph_rag_agent_llama3_local.ipynb)

### Retrieval augmented generation (RAG)

- advanced features
  * a search step to retrieve documents from vector database or a web search
    + put the documents into the prompt with the question
    + vector database can be something like Chroma or PostgreSQL with
      extension [pgvector](https://github.com/pgvector/pgvector) or
      extension [pgai](https://github.com/timescale/pgai)
  * re-ranking the sourced documents
  * query re-writing
    + re-writing the question using a generative language model to find the
      query to be used
    + example
      + re-writing "We have an essay due tomorrow. We have to write about some animal.
        I love penguins. I could write about them. I could also write about
        dolphins. Are they animals? Maybe. Let's do dolphins. Where do they live
        for example?" to "Where do dolphins live?"
  * multi-query
    + create seperate sets of results and documents; then pass it to LLM
    + example
      + "Compare the results of NVIDIA in 2020 and 2023" to "What was NVIDIA's
        revenue in 2020?" and "What was NVIDIA's revenue in 2023?"
  * grounded generation
    + citing the source of the information in the generated text

### Tricks with LLM

- instead of asking a direct question of selecting the best option, one can ask
  a model to ask the user with a list of yes/no questions to help narrowing the
  possible criteria
- to avoid hallucination, one can ask a model to give chain-of-thought, or to
  give one step at a time, to help breaking down a complex idea
- to avoid a model giving a too generic answer, one can specify the model a role
  (to be some kind of expert)

# Machine Learning

## Links

- [Learning Machine Learning](https://cloud.google.com/products/ai/ml-comic-1/)
  - explains what is machine learning
- [Hugging Face](https://huggingface.co/)
  - a model hub
- [Standford CS229: Machine Learning by Andrew Ng](https://www.youtube.com/watch?v=jGwO_UgTS7I&list=PLoROMvodv4rMiGQp3WXShtMGgzqpfVfbU)
  - a lecture series on machine learning
- [MediaPipe](https://ai.google.dev/edge/mediapipe/solutions/guide)
  * [MediaPipe Studio](https://mediapipe-studio.webapps.google.com/home)
- [Machine Learning Crash Course from
  Google](https://developers.google.com/machine-learning/crash-course/)

# Tools

## GitHub Copilot

- the opened tabs will be sent as context to the model

## Continue

- [site](https://www.continue.dev/)
- [supported models](https://docs.continue.dev/chat/model-setup) and it supports
  Ollama; it supports Visual Studio Code and JetBrains IDEs
- [config.json](https://docs.continue.dev/reference/)

## yt-dlp

##### To download a soundtrack of a video

```sh
yt-dlp --extract-audio --audio-format mp3 https://www.youtube.com/watch?v=wq9p6Y8RPEs
```

## whisper

### Links

- [Whisper](https://github.com/openai/whisper)

### Commands

##### To install

```sh
pip install git+https://github.com/openai/whisper.git
pip install setuptools-rust
```

##### To transcribe an audio

```sh
whisper --model medium test_voice.mp3
```

##### To transcribe and translate with a specified model

```sh
whisper --model medium --task translate test_voice.m4a
```

## tts

### Links

- [TTS](https://github.com/coqui-ai/TTS)

### Commands

##### To generate speech with the default model

```sh
tts --text "This is a test" --out_path test.wav
```

##### To list available models

```sh
tts --list_models
```

## easyocr

### Links

- [EasyOCR](https://github.com/JaidedAI/EasyOCR)
- [documentation](https://www.jaided.ai/easyocr/)

### Commands

##### To perform OCR with English

```sh
easyocr -l en -f image.jpg --detail=0 --gpu=True
```

or with detail of coordinates of text locations

```sh
easyocr -l en -f image.jpg --detail=1 --gpu=True
```

## pdftotext

- [poppler](https://poppler.freedesktop.org/)
- [pdftotext-go](https://github.com/heussd/pdftotext-go)
