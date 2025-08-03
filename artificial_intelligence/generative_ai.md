- [Paramters](#paramters)
  * [Temperature](#temperature)
  * [Top-K](#top-k)
  * [Top-P](#top-p)
- [Prompt engineering](#prompt-engineering)
  * [Tips](#tips)
- [Existing models](#existing-models)
- [Products](#products)
  * [Vertex AI](#vertex-ai)
____


# Paramters

## Temperature

Temperature `0` implies the process creates deterministic outcomes.

A higher temperature implies the process allows creation of outcomes with lower
probabilities.

## Top-K

If `top-K` is set to `3`, the model picks from the first 3 choices in terms of
probability.

## Top-P

If `Top-P` is set to `0.7`, the model would select words with probability of
`0.3` and higher.

# Prompt engineering

In prompt engineering, ask the model to indicate if it is not sure about the
answer (where the probability is low). Such as "Answer 'I am not sure' if you
are not sure about answer)

In prompt engineering, role playing is a way to give context to the model.

## Tips

- mathematical problems
  * break it down for the model by asking the questions in smaller pieces
- give example
- take advantage of chat history (hence, giving more context)
- currently, models understand programming language better than human languages
- for a conversation requires more than the maximum number of tokens of a model,
  a trick can be used is that to ask the model to summarise the conversation so
  far and store the summary to database storage and replay it later.

# Existing models

- LLaVA-1.5
  * a significantly smaller model than GPT4 but the accuracy is very close

# Products

## Vertex AI

It does not involve training of models. The models has been trained.

