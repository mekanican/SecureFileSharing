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
	"token": "ec4a3da295ca4030582f544062a56203ace7bf5c",
	"to": 2,
	"filename": "abc345.txt",
	"myfile": "YWJjYWJjCg==",
	"ttl": 3
}
```

#### Response

```json
{
	"messages": "success",
	"url": "http://localhost:9000/django-minio/01-06-2023_01-46-42___abc345.txt?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=admin%2F20230601%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20230601T014642Z&X-Amz-Expires=259200&X-Amz-SignedHeaders=host&X-Amz-Signature=d2319b640b0f56ce0067d00f0c0a101ba6a65b71e389bd43d0ff029c3520861d"
}
```

### Fail request
# Get Friend

## API Endpoint

`POST /api/fileSharing/friend/`

## Request Header

`HTTP/1.1`
`Content-Type: application/json`

## Request Body

| Field    | Type   | Description                |
| -------- | ------ | -------------------------- |
| token | string | the token |

```json
  "token": "ec4a3da295ca4030582f544062a56203ace7bf5c"
```

## Response

```json
[
	{
		"friend_id": 2,
		"uploaded_at": "2023-05-31T03:56:14",
		"username": "nghia1"
	}
]
```


# Get Chat

## API Endpoint

`POST /api/fileSharing/chat/`

## Request Header

`HTTP/1.1`
`Content-Type: application/json`

## Request Body

| Field    | Type   | Description                |
| -------- | ------ | -------------------------- |
| token | string | the token |
| to_id | int | receiver user id |

```json
{
	"token": "ec4a3da295ca4030582f544062a56203ace7bf5c",
	"to_id": 2
}
```

## Response

If the request is successful, the API will return the following response:

```json
[
	{
		"id": 2,
		"from_user_id": 1,
		"to_user_id": 2,
		"url": "https://example.com",
		"uploaded_at": "2023-05-30T14:43:46"
	}
]
```