# User Register API
This API allows user to register using their `username`, `password`, and `email`.  
## API Endpoint
`POST /user/register/`
## Request Header
`HTTP/1.1`  
`Content-Type: application/json`
## Request Body
| Field | Type | Description |
| ----- | ---- | ----------- |
| username | string | Username of the user |
| password | string | Password of the user |
| email | string | Email of the user |
## Response
If the request is successful, the API will return the following response:
```json
{
   "user_id": <id of the created user>
}
```
with the status code `201 Created`.  
If the request is unsuccessful, the API will a `400 Bad request` with a JSON describing the error.
## Example
### Successful request
#### Request
```json
{
    "username": "johndoe",
    "password": "p4ssword123",
    "email": "johndoe@example.com"
}
```
#### Response
```json
{
    "user_id": 7
}
```
### Failed request 1 (password does not match the password validation criteria)
#### Request
```json
{
    "username": "johndoe",
    "password": "password",
    "email": "johndoe@example.com"
}
```
#### Response
```json
{
    "password": [
        "This password is too common."
    ]
}
```
### Failed request 2 (Duplicated username)
#### Request
```json
{
    "username": "johndoe",
    "password": "passwordaaaaa",
    "email": "johndoe@example.com"
}
```
#### Response
```json
{
    "username": [
        "A user with that username already exists."
    ]
}
```
### Failed request 3 (Duplicated email)
#### Request
```json
{
    "username": "johndoe1",
    "password": "passwordaaaaa",
    "email": "johndoe@example.com"
}
```
#### Response
```json
{
    "email": [
        "User with this email already exists."
    ]
}
```
