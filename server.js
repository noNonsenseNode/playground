var express = require('express');
var mysql = require('mysql');
var app = express();

var pool = mysql.createPool({
    connectionLimit: 10,
    host: 'dbserver',
    user: 'root',
    password: 'root',
    database: 'playground'
});

app.get('/', function(req, res) {
    res.send('Hello World!');
});

app.get('/db', function(req, res, next) {
    pool.query('SELECT * FROM test', function(err, rows, fields) {
        if (err) {
            return next(err);
        }
        res.send('Number of rows:' + rows.length);
    });
});

app.listen(80);
