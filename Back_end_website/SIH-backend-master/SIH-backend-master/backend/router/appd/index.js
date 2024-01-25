const express=require('express');
const jwt=require('jsonwebtoken');
const User=require('../../database/mongodb/Schema/users');
const Query=require('../../database/mongodb/Schema/queries');
const Dumper=require('../../database/mongodb/Schema/dumster');
const Shovel=require('../../database/mongodb/Schema/shovel');
const Annoucement = require('../../database/mongodb/Schema/annoucements');
const appd=express.Router();


module.exports=appd;