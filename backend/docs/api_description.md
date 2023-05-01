# User Register API

This API allows user to register using their `username`, `password`, and `email`.

## API Endpoint

`POST /api/user/register/`

## Request Header

`HTTP/1.1`  
`Content-Type: application/json`

## Request Body

| Field    | Type   | Description          |
| -------- | ------ | -------------------- |
| username | string | Username of the user |
| password | string | Password of the user |
| email    | string | Email of the user    |

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
  "password": ["This password is too common."]
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
  "username": ["A user with that username already exists."]
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
  "email": ["User with this email already exists."]
}
```

# User Login API

This API allows user to login using their `username` and `password`.

## API Endpoint

`POST /api/user/login/`

## Request Header

`HTTP/1.1`
`Content-Type: application/json`

## Request Body

| Field    | Type   | Description          |
| -------- | ------ | -------------------- |
| username | string | Username of the user |
| password | string | Password of the user |

## Response

If the request is successful, the API will return the following response:

```json
{
    "token": <auth-token>
}
```

with the status code `200 OK`.  
If the request is unsuccessful, the API will a `400 Bad request` with a JSON describing the error.

## Example

### Successful request

#### Request

```json
{
  "username": "johndoe1",
  "password": "passwordaaaaa"
}
```

#### Response

```json
{
  "token": "207b9f098a3a77e7be0c383bb932fccd47dc291c"
}
```

### Failed request

#### Request

```json
{
  "username": "johndoe1",
  "password": "passwordaaaaa"
}
```

#### Response

```json
{
  "error": "Invalid credentials"
}
```

# User Logout API

This API allows user to logout.

## API Endpoint

`GET /api/user/logout?token=<auth-token>`

## Request Header

`HTTP/1.1`
`Content-Type: application/json`

## Response

If the request is successful, the API will return a `200 OK` response.  
If the request is unsuccessful, the API will a `400 Bad request` with a JSON describing the error.

## Example

`/api/user/logout?token=207b9f098a3a77e7be0c383bb932fccd47dc291c`

# Key Generating API

## API Endpoint

`GET /api/keys/generate/?token=<token>`

## Example

`/api/keys/generate/?token=6ef59d81bd7c499658ec25b9f030077e352bb235`

# Upload file API

## API Endpoint

`GET /api/fileSharing/upload`

### Successful request

#### Request

```json
{
    "myfile": <File_upload>,

}
```

#### Response

```json
{
 {
    "messages": "success",
    "url": "http://localhost:9000/django-minio/01-05-2023_22-55-32___241397803_601326841030855_5571972979464034506_n.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=admin%2F20230501%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20230501T155532Z&X-Amz-Expires=604800&X-Amz-SignedHeaders=host&X-Amz-Signature=de2e575288ea46f17664c2e36869bab454a2624b22dc799b5ff19dcbc00e1dc8"
}
}
```

### Fail request

#### Request

```json
{
    "myfile":<empty_content>,

}
```

#### Response

```json
{
 {
    "messages": "failed",
    "url": ""
}
}
```
