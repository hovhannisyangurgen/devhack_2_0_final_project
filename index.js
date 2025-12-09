require('dotenv').config();

const express = require('express');
const cors = require('cors');

const router = require('./src/router');


const app = express();
const port = process.env.APP_PORT;

app.use(cors());
app.use(express.json());
app.use('/api', router);

app.listen(port, () => {
  console.log(`Server is running on port http://localhost:${port}`);
});