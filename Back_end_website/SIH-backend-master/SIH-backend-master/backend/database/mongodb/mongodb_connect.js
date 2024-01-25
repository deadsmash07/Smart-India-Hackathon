require('dotenv').config();
const mongoose = require('mongoose');
const url = process.env.MONGODB_URL;
async function connect() {
  await mongoose.connect(url)
  .then(() => console.log('Connected to MongoDB'))
  .catch(err => console.error('Could not connect to MongoDB...', err));
}
module.exports = connect;