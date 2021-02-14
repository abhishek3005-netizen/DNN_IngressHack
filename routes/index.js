const express = require('express');
const router = express.Router();

router.get('/', (req, res) => {
  console.log('Request for home recieved');
  res.render('index');
});

//login modal
router.get('/login', (req, res) => {
  console.log('Request for login recieved');
  res.render('login');
});

router.get('/cardComments', (req, res) => {
  console.log('Request for login recieved');
  res.render('cardComments');
});

module.exports = router;