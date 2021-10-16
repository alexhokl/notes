- [Actions SDK](#actions-sdk)
____

## Actions SDK

### Links

- [settings.yaml](https://developers.google.com/assistant/actionssdk/reference/rest/Shared.Types/Settings)

### CLI

##### Login

```sh
gactions login
```

##### To pull (instantiate) project code

```sh
gactions pull --project-id your_project
```

where project ID can be found by `gcloud projects list`.

Note that you will be asked to create an action project (via a browser) if there
is no actions setup previously.

##### To upload code onto simulator

```sh
gactions deploy preview
```

