## auto transform to json

```bash
# install
nix profile install github:kwbauson/cfg#atfj
# usage
atfj --help
# configure openai/ollama api details
atfj configure
```

### example run

```
~ $ atfj run docker image ls | jq -r '.[0].REPOSITORY'
Generating script...

import json
import sys

def text_to_json(text):
    lines = text.strip().split('\n')
    headers = lines[0].split()
    data = []

    for line in lines[1:]:
        values = line.split()
        entry = {headers[i]: values[i] for i in range(len(headers))}
        data.append(entry)

    return json.dumps(data, indent=4)

if __name__ == "__main__":
    input_text = sys.stdin.read()
    print(text_to_json(input_text))

Choose an action
(accept, test, details, edit, retry, abort): test

[
    {
        "REPOSITORY": "ubuntu",
        "TAG": "latest",
        "IMAGE": "35a88802559d",
        "ID": "6",
        "CREATED": "months",
        "SIZE": "ago"
    }
]

Choose an action
(accept, test, edit, retry, abort): accept

ubuntu

# remembers previously accepted script
~ $ atfj run docker image ls | jq -r '.[0].REPOSITORY'
ubuntu
```
