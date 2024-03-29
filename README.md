# Secure File Sharing app

# Note
- DB Used: MySQL 8.x
- Backend: Django

- username & password for DB: `root`, db name: `db_test`, host: `mysql_database`
- Mysql takes a while to init, only the first time takes that long.

# How to use:

## For Docker setup

- Install docker desktop (windows) & use WSL2 / docker (linux)
- `git clone` this repo (through gui / cli)
- Make sure cloned file are "LF", not "CRLF" (Windows only) !
- `cd SecureFileSharing`
- `docker compose up`
- To end session, `Ctrl-C`
- To cleanup: `docker compose down -v`, this will clean all docker compose volume & container (not recommended due to slow init)

## For MySQL
### Installations
- For Windows users, please download MySQL Workbench from [here](https://dev.mysql.com/downloads/workbench/)
- For Ubuntu users, please follow this [instructions](https://linuxhint.com/installing_mysql_workbench_ubuntu/) to install `mysql` and MySQL Workbench.
- For other operating systems, please find appropriate instructions to install MySQL Workbench.
### Usage
- Create a user named `file_sharing` and password `file_sharing` with all privileges.  
  Commands on Ubuntu:
```
  sudo mysql -u root -p
  CREATE USER 'file_sharing'@'localhost' IDENTIFIED BY 'file_sharing';
  GRANT ALL PRIVILEGES ON *.* TO 'file_sharing'@'localhost';
  exit
```
  For other operating systems, please find appropriate commands to create a user.
- Create a database named `file_sharing` with configurations as in the image below.
  ![Database Configuration](instruction_images/database_creation.png)

## For Django (directly, not through docker compose)

- `cd Backend`
- For Windows user, please manually copy commands from `.sh` files :((
- For the first time setting up backend, run
  ```
    ./pyenv_run.sh
  ```
  to set up virtual environment

- To run server, use:
    ```
    ./server_run.sh
    ```