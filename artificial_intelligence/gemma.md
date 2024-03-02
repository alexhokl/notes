
____

- it is a model from Google
- it is available for download and run offline (via kaggle)
- it is a LLM
- it is text only
  * unlike Gemini where it can process image and more input mediums
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
