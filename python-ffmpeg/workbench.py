import json

with open('metadata.json') as f:
  data = json.load(f)

print(data)