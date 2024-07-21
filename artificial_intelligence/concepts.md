- [General concepts](#general-concepts)
- [Retrieval augmented generation (RAG)](#retrieval-augmented-generation-rag)
____

# General concepts

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

# Retrieval augmented generation (RAG)

- advanced features
  * a search step to retrieve documents from vector database or a web search
    + put the documents into the prompt with the question
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
