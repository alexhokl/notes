- [General concepts](#general-concepts)
____

# General concepts

- [Embedding models](https://ollama.com/blog/embedding-models)
  * embedding models, making it possible to build retrieval augmented generation
    (RAG) applications that combine text prompts with existing documents or
    other data
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
