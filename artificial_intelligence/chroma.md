- [Links](#links)
- [Concepts](#concepts)
- [Docker](#docker)
____

# Links

- [an example with environment
  variables](https://cookbook.chromadb.dev/strategies/cors/)
- [API](https://cookbook.chromadb.dev/core/api/)
  `http://<chroma_server_host>:<chroma_server_port>/docs`
- [amikos-tech/chroma-go](https://github.com/amikos-tech/chroma-go) Go client
  [documentation](https://go-client.chromadb.dev/)

# Concepts

- embedding model is defined at the database creation time
  * by default, Chroma uses the Sentence Transformers `all-MiniLM-L6-v2` model
    to create embeddings (download of the model happens automatically)
    ([reference](https://docs.trychroma.com/guides/embeddings#default:-all-minilm-l6-v2))
  * when documents are added to the database, the embedding model (in form of
    embedding function) is used to convert the text to a vector
  * embedding model is also defined in query process as the query string
    will be converted to a vector by the model (in form of embedding function)
    before it is used to search for the closest vectors in the database; thus,
    it is not directly used by the database but transforming the query string
    beforehand
    + `xh -b http://localhost:11434/api/embeddings model=nomic-embed-text prompt="your query" | jq -c .embedding`

# Docker

##### To run chroma using Docker

```yaml
services:

  vector-database:
    image: chromadb/chroma:0.5.4
    ports:
      - 8000:8000
    environment:
      - IS_PERSISTENT=TRUE
    volumes:
      - chroma_data:/chroma/chroma

volumes:
  chroma_data:
```
