- [CLI](#cli)
  * [GraphQL API](#graphql-api)
____
## CLI

### GraphQL API

To pull issues tied to a project and retrieve one of the project fields of type
`Date`. This also includes usage of parameter (see `project_id` and
`field_name`).

```sh
gh api graphql -f query='
	query($project_id:ID!, $field_name:String!) {
		node(id: $project_id) {
			... on ProjectV2 {
				items(first: 100) {
					nodes {
						id
						content {
							... on Issue {
								number
								title
							}
						}
						fieldValueByName(name: $field_name) {
							... on ProjectV2ItemFieldDateValue {
								date
							}
						}
					}
					pageInfo {
						hasNextPage
						endCursor
					}
				}
			}
		}
	}' -f project_id="PVT_xxxxxxxxxxxx" -f field_name="Your field name"
```

