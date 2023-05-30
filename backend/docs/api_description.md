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

> **Warning**
> This api for testing upload file, Haven't handle token authen

`POST /api/fileSharing/upload`

## Request Header

`HTTP/1.1`
`Content-Type: application/json`

## Request Body

| Field    | Type   | Description                   |
| -------- | ------ | ----------------------------- |
| to       | int    | Receiver's id                 |
| token    | string | Sender's token                |
| filename | string | File name with extend path    |
| myfile   | string | file content in base64 string |
| ttl      | int    | Time to live in days [1; 365] |

## Response

If the request is successful, the API will return the following response:

```json
{
    "messages": "success" ,
    "url": <url for downloading file>
}
```

with the status code `200 OK`.  
If the request is unsuccessful, the API will a `400 Bad request` with a JSON describing the error.

```json
{
    "messages":<error detail> ,

}
```

## Example

### Successful request

#### Request

```json
{
  "username": "kang",
  "filename": "test.txt",
  "myfile": "DQpsw6BtIHJlcG9ydDoNCglEYXRhc2V0OiAoMTJoIHRyxrBhIDI4LzQgLSB2ZXIgMS4wIC0+IDEvNSB2ZXIgMi4wKQ0KCS0gdXJsLCBuZ3Xhu5NuIGfhu5FjIOG7nyDEkcOidSwgZG8gYWkgdOG6oW8gcmEgDQoJLSBkb3dubG9hZCB24buBIHbDoCBt4bufIHJhIHhlbSDEkcaw4bujYyBoYXkgY2jGsGENCgktIGThu68gbGnhu4d1IGPDsyBu4buZaSBkdW5nIGfDrAkNCgkJKyBrw61jaCB0aMaw4bubYyBi4buZIGThu68gbGnhu4d1ICh24buBIGR1bmcgbMaw4bujbmcsIHPhu5EgbMaw4bujbmcuLi4pDQoJCSsgY8OzIGxhYmVsL2Fubm90YXRpb24ga2jDtG5nDQoJCSsgdMOtbmggY2jhuqV0IHbhu4EgbuG7mWkgZHVuZzogZGF0YXNldCBiYW8gbmhpw6p1IGNsYXNzLCBt4buXaSBjbGFzcyBiYW8gbmhpw6p1IGRhdGEsIGNo4bqldCBsxrDhu6NuZyBkYXRhIG50bi4uLg0KCS0gdXkgdMOtbiBj4bunYSBkYXRhc2V0Pw0KCQkrIGPDsyBuaGnhu4F1IG5nxrDhu51pIHPhu60gZOG7pW5nIMSR4buDIG5naGnDqm4gY+G7qXUga2jDtG5nLCBoYXkgbuG6v3UgY8OzIGNvbXBldGl0aW9uIHbhu4EgZGF0YXNldCBuw6B5IHRow6wgY8OzIG5oaeG7gXUgbmfGsOG7nWkgdGhhbSBnaWEgaGF5IGtow7RuZw0KCS0gbGVhZGVyYm9hcmQgKGvhur90IHF14bqjKTogeOG6v3AgaOG6oW5nIHbhu4EgbeG7qWMgxJHhu5kgdGjDoG5oIGPDtG5nIG3DoCBt4buNaSBuZ8aw4budaSDEkcOjIHRo4buxYyBoaeG7h24gdHLDqm4gZGF0YXNldCBuw6B5LiBUaOG6p3kga8OqdSBjw6FpIG7DoHkgdGjhuqd5IHPhur0gaMaw4bubbmcgZOG6q24gdGjDqm0="
}
```

#### Response

```json
{
  "messages": "success",
  "url": "http://localhost:9000/django-minio/11-05-2023_00-29-18___test.txt?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=admin%2F20230510%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20230510T172939Z&X-Amz-Expires=604800&X-Amz-SignedHeaders=host&X-Amz-Signature=8751eb59511d3a87019dbdb58f463b6cc51e6d017949fbfb18bf091e5883d07b"
}
```

### Fail request

#### Request

```json
{
  "username": "kang",
  "filename": "test.txt",
  "myfile": "data:image/png;"
}
```

#### Response

```json
{
  "messages": "File content must be base64"
}
```

<!-- # Delete API (Deprecated) -->

## API Endpoint

> **Warning**
> This api for testing upload file, haven't handle token authen

`POST /api/fileSharing/remove`

## Request Header

`HTTP/1.1`
`Content-Type: application/json`

## Request Body

| Field    | Type   | Description                |
| -------- | ------ | -------------------------- |
| filename | string | File name with extend path |

## Response

If the request is successful, the API will return the following response:

```json
{
  "messages": "success"
}
```

with the status code `200 OK`.  
If the request is unsuccessful, the API will a `400 Bad request` with a JSON describing the error.

```json
{
    "messages":<error detail> ,

}
```

## Example

### Successful request

#### Request

```json
{
  "filename": "11-05-2023_00-12-45___test"
}
```

#### Response

```json
{
  "messages": "success",
  "url": "http://localhost:9000/django-minio/11-05-2023_00-29-18___test.txt?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=admin%2F20230510%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20230510T172939Z&X-Amz-Expires=604800&X-Amz-SignedHeaders=host&X-Amz-Signature=8751eb59511d3a87019dbdb58f463b6cc51e6d017949fbfb18bf091e5883d07b"
}
```

### Fail request

#### Request

```json
{
  "filename": "11-05-2023_00-12-45___test" || (
    <filename not contain in minio>
  )
}
```

#### Response

```
{
  "messages": "file not exist"
}
```

# Get Friend

## API Endpoint

`POST /api/fileSharing/friend`

## Request Header

`HTTP/1.1`
`Content-Type: application/json`

## Request Body

| Field    | Type   | Description                |
| -------- | ------ | -------------------------- |
| token | string | the token |

## Response

If the request is successful, the API will return the following response:

```json
[
	{
		"id": 2,
		"from_user_id": 1,
		"to_user_id": 2,
		"url": "https://example.com",
		"uploaded_at": "2023-05-30T14:43:46Z",
		"friend_id": 1
	}
]
```


# Get Chat

## API Endpoint

`POST /api/fileSharing/chat`

## Request Header

`HTTP/1.1`
`Content-Type: application/json`

## Request Body

| Field    | Type   | Description                |
| -------- | ------ | -------------------------- |
| token | string | the token |
| to_id | int | receiver user id |

## Response

If the request is successful, the API will return the following response:

```json
[
	{
		"id": 2,
		"from_user_id": 1,
		"to_user_id": 2,
		"url": "https://example.com",
		"uploaded_at": "2023-05-30T14:43:46Z"
	}
]
```