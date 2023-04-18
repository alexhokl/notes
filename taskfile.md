- [Special variables](#special-variables)
- [References](#references)
____

## Special variables

- `USER_WORKING_DIR`
  * directory of current (or a parent) directory containing
    `Taskfile.yml`containing `Taskfile.yml`
- `CLI_ARGS`
- all arguments comes after `--`
  * `{{ splitargs .CLI_ARGS | first }}` can be used to retrieve the first
    argument
  * `{{ args := splitargs .CLI_ARGS }}{{ index $args 1 }}` can be used to
    retrieve the second argument

## References

- [Learn Go Template
  Syntax](https://developer.hashicorp.com/nomad/tutorials/templates/go-template-syntax)
