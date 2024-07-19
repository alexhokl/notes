- [Links](#links)
- [Basic concepts](#basic-concepts)
- [Ollama](#ollama)
  * [API examples](#api-examples)
____

# Links

- [google-gemini/gemme-cookbook](https://github.com/google-gemini/gemma-cookbook)

# Basic concepts

- a model from Google
- available via Ollama or Kaggle
- a text-only LLM
  * unlike Gemini where it can process images and more input mediums
- access examples
  * via [KerasNLP](https://keras.io/keras_nlp/)
    + [generate text](https://ai.google.dev/gemma/docs/get_started)
      + `gemma_lm_generate("what is the NTP?", max_length=64)`
  * via [Keras using
    LoRA](https://colab.research.google.com/github/google/generative-ai-docs/blob/main/site/en/gemma/docs/lora_tuning.ipynb)
    + for fine tuning purpose
    + in the example, the response was too difficult for a child to understand
      initially; the model was later tuned to fit this use case
- it can be used to generate data for training

# Ollama

## API examples

```sh
xh http://localhost:11434/api/generate \
  model=gemma2:9b \
  prompt="What is the capital of Portugal?"
```

```sh
curl http://localhost:11434/api/chat -d '{ \
  "model": "gemma:7b", \
  "messages": [ \
    { "role": "user", "content": "what is the capital of Portugal?" } \
  ] \
}'
```


