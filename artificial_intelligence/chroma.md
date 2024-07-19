- [Links](#links)
- [Docker](#docker)
____


# Links

- [an example with environment
  variables](https://cookbook.chromadb.dev/strategies/cors/)
- [API](https://cookbook.chromadb.dev/core/api/)
  `http://<chroma_server_host>:<chroma_server_port>/docs`
- [amikos-tech/chroma-go](https://github.com/amikos-tech/chroma-go) Go client

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
