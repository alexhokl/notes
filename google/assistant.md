- [Actions SDK](#actions-sdk)
  * [Links](#links)
  * [CLI](#cli)
____

## Actions SDK

### Links

- [settings.yaml](https://developers.google.com/assistant/actionssdk/reference/rest/Shared.Types/Settings)
- [Account linking](https://developers.google.com/assistant/identity)
  - Actions Builder must be used to build an Action that implements account
    linking
  - [Account linking with Google
    Sign-In](https://developers.google.com/assistant/identity/google-sign-in)
    - After the user authorizes your action to access their Google profile, you
      will receive a Google ID token that contains the user's Google profile
      information in every subsequent request to your action.
      - The ID token is just a normal JWT token. Thus, the normal verification
        and decoding applies.
  - [Account linking with OAuth-based Google Sign-in "Streamlined"
    linking](https://developers.google.com/assistant/identity/google-sign-in-oauth)
    - enabling account linking for users who registered to your service with
      a non-Google identity
      - example: Spotify
    - supported grant types
      - implicit (not recommended)
        - long-live access token which will be saved at Google
      - authorization code
        - authorization endpoint
        - token exchange endpoint

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

