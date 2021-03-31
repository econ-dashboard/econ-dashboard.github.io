import json

def read_json(path):
    with open(path) as fh:
        return json.load(fh)

def write_json(path, data):
    with open(path, 'w') as fh:
        return json.dump(data, fh, indent=4)
