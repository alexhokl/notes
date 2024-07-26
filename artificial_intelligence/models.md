____

# gemini

- API access only
  * training is not available
- support of longer context is better
- Mixture of Experts (MoE) as model architecture
  * a gating network to select the expert to use for each input
- examples
  * find a frame is a video according to a description or a picture (where it
    can be hand-drawn)
- a character is a token (unlike it is a word in GPT-3)
- video processing is separated from audio processing
- with short context and access via API, it can be free

# gemma

## Links

- [google-gemini/gemme-cookbook](https://github.com/google-gemini/gemma-cookbook)

## Basic concepts

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

## Ollama

### API examples

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
