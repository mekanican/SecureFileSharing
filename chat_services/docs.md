Notify service documentation
============================

Generally, django doesn't have any support for websocket, so this is a workaround for that purpose

# How to run
Install dependencies:
```bash
sudo npm install -g pnpm
pnpm i
```
Run the server
```bash
node index.js
```

# How to use
Suppose there are 3 parts: Client, Notification Service and Django.

First, Client will connect with Notification at websocket port 3400. Then
client will listen for "Reload X" message, with X is id of Client.

If there's any update that Django wants Client to update, Django will create a
GET request to port 23432, for example: `http://localhost:23432/8`, then
Notification service will craft message based on id and broadcast those messages to
clients.