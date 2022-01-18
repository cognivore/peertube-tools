# Synopsis

Dependencies are in `flake.nix`.
Example of launching script:

```
peertube_upload \
  ~/Videos/Co-Driver\ Championship\ Prep.mp4 \
  "RBR Co-Driver Championship Prep (Testing CLI Uploads to Peertube)" \
  a_bee_company \
  1
```

Arguments are explained right below, and more information about secrets are in the "About these scripts" section. If you're confused about what the heck `passveil` is, check out my instructions over at [doma.dev repositories](https://github.com/doma-engineering/passveil#passveil-in-doma).

## Arguments

* Video to upload
* Description of the video
* Name of the channel to upload to
* _optional_: How many destinations (obtained by running `passveil show peertube/multipart.json`) are skipped before starting to upload stuff (default: 0)
* _optional_: What is the number of destination we should stop uploading at (default: 256)

# About these scripts

    Problem: no easy way to use peertube from CLI

    Solution:
     - Start writing peertube_upload script, inspired by Andy Balaam[1].
     - See that it's a bit lacking in terms of secret management.
     - Start using jq with multiple peertube servers listed in a JSON, managed by passveil[2].
        - The JSON secret has to be stored in your passveil repository with the exact name of "peertube/multiupload.json".
     - Write peertube_aup script, which takes a service ID (just a number in your multiupload.json array) and transforms its contents into a three line output:
        - a line containing just address;
        - a line containing just username;
        - a line containing just password.
     - Note that peertube_aup also can take already decrypted single-line JSON that contains a. u. and p. and convert it into three lines as well.
     - Write peertube_auth script, which takes the a. u. and p. from STDIN and signs in, returning oauth token.
     - Implement peertube_upload script which defers to cURL, because raw cURL is still more fitting to do some fine-grained stuff and has richer verbose / debug facilities for development.

    References:

    [1]: https://www.artificialworlds.net/blog/2021/04/30/uploading-to-peertube-from-the-command-line/
    [2]: """
    [

      {
        "address": "peertube.co.uk",
        "username": "a_bee_tester",
        "password": "redacted"
      },

      {
        "address": "videos.trom.tf",
        "username": "a_bee_tester",
        "password": "redacted"
      },

      {
        "address": "tubedu.org",
        "username": "a_bee_tester",
        "password": "redacted"
      }

    ]
    """

# Important constraints

 - Don't use `"` and `\` in your passwords, usernames and channel names.
