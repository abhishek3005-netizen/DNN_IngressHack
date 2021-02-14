const express = require('express');
const path = require('path');
const routes = require('./routes');

const app = express();
// Set the default views directory to views folder
app.set('views', path.join(__dirname, 'views'));

// Set the folder for css & java scripts
app.use(express.static(path.join(__dirname,'css')));
app.use(express.static(path.join(__dirname,'image')));
app.use(express.static(path.join(__dirname, 'node_modules')));

// Set the view engine to ejs
app.set('view engine', 'ejs');

app.use('/', routes);

app.listen(3000, () => {
  console.log('Server is running at localhost:3000');
});