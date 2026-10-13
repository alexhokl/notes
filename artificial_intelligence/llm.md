- [Large Language Models (LLMs)](#large-language-models-llms)
  * [Links](#links)
  * [Skills](#skills)
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
  * [Google AI Edge Gallery](#google-ai-edge-gallery)
    + [Agent Skills](#agent-skills)
  * [Inferencing](#inferencing)
  * [Basic theory](#basic-theory)
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

## Skills

- [The Agent Skills Directory](https://skills.sh/)
- [Agent Skills Marketplace - Claude, Codex & ChatGPT Skills | SkillsMP](https://skillsmp.com/)
- [google/skills: Agent Skills for Google products](https://github.com/google/skills/tree/main)
- [flutter/skills](https://github.com/flutter/skills)
- [dart-lang/skills](https://github.com/dart-lang/skills)
- [google-ai-edge gallery skills README](https://github.com/google-ai-edge/gallery/blob/main/skills%2FREADME.md)

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
mlx_audio.stt.generate --model mlx-community/whisper-large-v3-turbo-asr-fp16 --language zh-yue --audio audio.wav --output-path script
```

and option `langauge` is only needed when there are multiple languages involved
in the audio. Otherwise, the model will automatically detect the language.

Extension `.txt` is automatically added to the output file name.

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

## Google AI Edge Gallery

### Agent Skills

- `SKILL.md` inside a kebab-case folder (`some-skill-name`)
- skill types
  * text-only
  * [JavaScript](https://github.com/google-ai-edge/gallery/blob/main/skills/README.md#javascript-js-skills)
    + logic runs in a hidden webview via `window['ai_edge_gallery_get_result']`
      in `scripts/index.html`; can return text, base64 image or inline webview
  * native
    + uses `run_intent` tool (e.g. `send_email`, `send_text_message`);
      new intents require app source code changes

#### Installation

##### Transfer from a local machine

```sh
adb push my-js-skill/ /sdcard/Download/
```

In Google AI Edge Gallery app,

Agent Skills use case
-> `Skills` chip
-> `(+)` button
-> `Import local skill`
-> pick the folder containing `SKILL.md`

##### Pull from web

- host the skill folder on a URL and use `Load skill from URL`

## Inferencing

- parallisms
  * data parallelism
  * pipeline parallelism
  * tensor parallelism
  * expert parallelism
    + for MoE (Mixture of Experts) models, only a subset of experts are used for
      each input, hence the model is more efficient and faster
- prefill/decode disaggregation
  * prefill
    + process input prompt in parallel using a fixed set of model weights to
      compute the KV cache for the decoder
    + compute-bound
  * decode
    + to build a response using the whole KV cache
    + memory-bound
  * KV cache
    + buffer between prefill and decode

## Basic theory

Reference: [Language Model Builder](https://languagemodelbuilder.com/)

- ngram
  * unigram has no context
    + it only asks which words are common anywhere in the text
  * bigram uses one previous word, such as `little -> cat`
  * trigram uses two, such as `the little -> cat`
- the model only ever has odds
  * temperature controls how adventurously it picks, with low values
    concentrating probability around the likeliest word
  * temperature changes the sampling distribution after those probabilities
    exist
    + `adjusted_weight(word) = P(word)^(1/T)`
- older models either see only a small fixed window or squeeze the past through
  a sequential running state
  * the transformer addressed both limitations
    + attention created direct paths to earlier tokens, and
    + its training computations could run in parallel across positions
- attention
  * each token is first turned into a list of numbers called a vector.
  * the model then makes three small projections of that vector,
    + query
      + what this token is looking for
    + key
      + what this other token offers
    + value
      + the information this other token can contribute
  * for every permitted pair of positions, the model compares the query from one
    token with the key from another
    + if they line up, the attention score is high
    + if they do not, the score is low
    + those scores are turned into weights, and the model uses them to blend
      together the value vectors from relevant earlier tokens
    + after attention runs, each token’s vector has been updated with a weighted
      mixture of information from the context it was allowed to see
- tokenization
  * before attention can compare vectors, the raw text has to be chopped into
    pieces and assigned identifiers, and models don’t chop at word boundaries;
    their unit of meaning is the token: maybe a whole word, maybe part of one,
    maybe a punctuation mark or a bit of whitespace
  * tokenization is the bridge between human text and model math
  * common words can become one token, while rare words can be split into
    familiar pieces
  * byte-pair encoding (BPE) tokenizer works by running merges over enormous
    amounts of text and it could start with character-level tokens
    + count adjacent pairs, merge the most frequent one, repeat
- each token maps to a vector
- a LLM model embeds vectors
  * through training, vector of tokens such as "cat" and "dog" will drift closer
    together and further away from "Paris" or "Rome"
  * vectors can be used for computation
    + `king` - `man` + `woman` = `queen` (approximately)
      + besides `queen` the resultant vector should be close to `daughter` and
        `princess`
  * whether two vectors are close or far away can be measured by cosine of the
    angle between them
  * besides token embedding, there are also positional embedding to help model
    to understand the order of tokens in a sequence (or the order of words in a
    sentence)
    + in modern LLMs, rotary positional embeddings (RoPE) are used instead of
      absolute positional embeddings
      + it rotates the vectors used when tokens compare themselves with one
        another (such as "three tokens back" instead of "slot 7")
    + the position (be it asolute or relative) determines the angle of rotation
      to the token embedding vector
- transformer
  * reading vectors and computes predictions for the next token
  * it is a pipeline
    + tokenise and embed
    + run the blocks
      + a block is one repeating unit of the machine
        + also known as a transformer block, or a layer
        + a fixed bundle of arithmetic that takes in the sequence of vectors and
          hands back the same sequence, slightly improved
        + it lets the tokens exchange information with each other, then does a
          bit of processing on each token alone
    + normalise and score
      + after the last block, one final normalisation tidies up the numbers, and
        then a final procjection called the output head gives every token in the
        vocabulary a score for how likely it is to be the next token
    + turn scores into odds
      + squashes the scores into probabilities that sum to 1
  * attention
    + each token asks a question (its query), each token advertises what it has
      to offer (its key), and where a question and an offer line up, information
      (the value) flows
    + it all happens as a handful of big matrix multiplications
    + causal attention
      + the model is only allowed to look backward
    + runs as several parallel conversations at once
      + each conversation is called an attention head
      + each head gets its own learned slices of the queries, keys, and values,
        so each is free to detect different relationships
        + it allows parallelism
      + after all the heads have done their looking, their results are stitched
        back together into one vector per token
    + it is the only place in the entire model where tokens interact with each
      other
  * components of neural network
    + weight matrix
      + a linear layer mixes a a vector’s entries using a grid of learned
        numbers
    + activation function
      + a non-linear function which is a fixed rule applied to each number
        between two linear layers
        + something like "if it’s negative, squash it"
  * multi-layer perceptron (MLP)
    + also known as feedforward network
    + a stack of linear layers and activation functions
    + while attention moves information (vectors) between positions, MLP
      transforms information at each position
    + optimisations to allow multiple layers
      + residual connections
        + the model adds the sublayer’s output onto the vector it already had
      + normalisation
        + each sublayer gets a small operation right before its input that takes
          a vector and rescales it to a consistent, well-behaved range
          + it earns its place because numbers flowing through a deep stack of
            multiplications like to drift, some exploding and some collapsing
            toward zero, and once they drift far enough, training falls apart
    + for each block
      + normalisation -> attention -> normalisation -> MLP
  * hyperparameters
    + number of layers (or blocks) to stack
      + more blocks means more rounds of refinement and more capacity for
        complicated patterns
    + width
      + how many numbers are in each vector
    + number of attention heads
      + how many parallel attention conversations run in each block, splitting
        the width between them
    + context length
      + how many tokens the model can look back over
    + vocabulary size
      + how many distinct tokens and it determines the size of the embedding
        table and output head
- in the context of mixture of experts (MoE) models, active parameters can be
  interpreted as how many parameters take part for each token
- checkpoint
  * a snapshot of every model parameter
  * it is written to disk
  * it also carries the running state of optimizer and a little metadata such as
    the training step, model shape, tokenizer, and data source
  * it allows training to be paused and resumed
- loss
  * a measure of how well the model is doing
  * training is about minimising loss
  * compute using the probability of the correct next token
  * cross-entropy from Claude Shannon’s information theory
  * gradient descent is an algorithm to minimise loss
    + learning rate determines how far it moves downhill in each step
      + too low it will take forever to reach the bottom
      + too high it will overshoot and bounce around
  * the more training completed, the lower the loss in general
    + when validation loss starts to rise, the model is overfitting
- behaviour learning
  * post-training processes
    + supervised finetuning (SFT)
      + gives the model example after example
      + for example, if the model sees that shape often enough, it’ll start
        treating it as the natural thing to do — so that later, when you prompt
        it with a `<|user|>` turn, answering as a helpful `<|assistant|>` is
        simply what it expects to come next
      + the model is shown the whole exchange instead of just part of a text
        + loss is only measured on the answer part (not the question part)
      + suitable for teaching shapes such as formats, styles, and routines
        + it cannot fill the gaps in board knowledge or reasoning abilities in
          the base model
    + direct preference optimization (DPO)
      + show two answers and human pointing to the better one
      + it is an alternative to reinforcement learning from human feedback
        (RLHF)
      + two models involved
        + one is a freezed base model
        + the other is a diverged model (from the freezed base model)
      + iterate with the following questions to find the loss
        + How much more likely is the chosen answer now than under the frozen
          copy?
        + How much more likely is the rejected answer now than under the frozen
          copy?
      + the frozen copy is used to act as an anchor to prevent the diverged
        model from drifting into some strange text
