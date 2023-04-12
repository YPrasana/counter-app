
const mysql = require('mysql');
const ejs = require('ejs');
const path = require("path");


const connection = mysql.createConnection({
  host: '127.0.0.1',
  user: 'admin', // Your MySQL username
  password: 'admin123', // Your MySQL password
  database: 'test' // Your MySQL database name
});
const mysql = require('mysql');

const connection = mysql.createConnection({
  host: process.env.MYSQL_HOST,
  user: process.env.MYSQL_USER,
  password: process.env.MYSQL_PASSWORD,
  database: process.env.MYSQL_DATABASE
});

connection.connect((err) => {
  if (err) {
    console.error('Error connecting to database:', err.message);
    return;
  }

  console.log('Connected to database');
});

let data = 0;
connection.connect((err) => {
    if (err) {
      console.error('Error connecting to database:', err);
      return;
    }
  
    console.log('Connected to database');
  
    connection.query('SELECT count FROM counter', (err, results) => {
      if (err) {
        console.error('Error retrieving count from database:', err);
        return;
      }
  
      data = results[0].count;
      counting.innerText = data;
    });
  
    server.listen(3000, () => {
      console.log('Server running on port 3000');
    });
  });
  
(error));
  
 

function increment() {
  data++;
  counting.innerText = data;

  connection.query(`UPDATE counter SET count = ${data}`, (err, results) => {
    if (err) {
      console.error('Error updating count in database:', err);
      return;
    }

    console.log('Count updated in database');
  });

  fetch('/increment')
    .then(response => response.json())
    .then(result => {
      console.log(result);
    })
    .catch(error => console.error(error));
}

function decrement() {
  data--;
  counting.innerText = data;

  connection.query(`UPDATE counter SET count = ${data}`, (err, results) => {
    if (err) {
      console.error('Error updating count in database:', err);
      return;
    }

    console.log('Count updated in database');
  });

  fetch('/decrement')
    .then(response => response.json())
    .then(result => {
      console.log(result);
    })
    .catch(error => console.error(error));
}
