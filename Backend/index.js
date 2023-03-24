// get the client
const mysql = require('mysql2');

// create the connection to database
const connection = mysql.createConnection({
  host: 'mysql_database',
  user: 'root',
  password: 'root',
  database: 'db_test',
});

console.log("To be continued...")