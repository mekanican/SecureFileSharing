Add ons API documentation
============================

# How to run
To run the add-on server, simply run this command:
```bash
python3 run.py
```

# How to use
By default, server will run on [localhost:9087](localhost:9087).
## Malware detection
Sample data (malware files) are stored in `malware_detection/samples` folder.
### Request
```bash
POST /api/malware
```

### Request body
```json
{
  "hash":"36828b9c630a86bfd5babd2bdef106fc"
}
```

### Example response
```json
{
    "result": "malware"
}
```
```json
{
    "result": "benign"
}
```
