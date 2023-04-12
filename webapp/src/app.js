const express = require('express');
const app = express();
const mysql = require('mysql');
const ejs = require('ejs');
const path = require("path");


const connection = mysql.createConnection({
  host: '10.102.173.52',
  user: 'admin', // Your MySQL username
  password: 'admin123', // Your MySQL password
  database: 'test' // Your MySQL database name
});

let count = 0;


// Create counter table if not exists
connection.query(
  "CREATE TABLE IF NOT EXISTS counter (count INT(11) NOT NULL)",
  (error, results, fields) => {
    if (error) throw error;
  }
);

app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(express.static(path.join(__dirname, "public")));

app.get("/", (req, res) => {
  connection.query(
    "SELECT count FROM counter",
    (error, results, fields) => {
      if (error) throw error;
      const count = results.length > 0 ? results[0].count : 0;
      res.render("index", { count });
    }
  );
});

app.get("/increment", (req, res) => {
  connection.query(
    "UPDATE counter SET count = count + 1",
    (error, results, fields) => {
      if (error) throw error;
      res.redirect("/");
    }
  );
});

app.get("/decrement", (req, res) => {
  connection.query(
    "UPDATE counter SET count = count - 1",
    (error, results, fields) => {
      if (error) throw error;
      res.redirect("/");
    }
  );
});

app.set("views", path.join(__dirname, "views"));
app.set("view engine", "ejs");

app.listen(3000, () => {
  console.log("Server started on port 3000");
});
