require('dotenv').config();
const express=require('express');
const path=require('path');


const connect=require('../database/mongodb/mongodb_connect.js')
const hardware=require("./hardware/index.js")
const frontend=require("./frontend/index.js")
const appd=require("./appd/index.js")
const User=require('../database/mongodb/Schema/users');
// const hyperledger=require("./hyperledger/index.js")


const app=express();


connect();
const http = require('http');
const socketIo = require('socket.io');
const cors = require('cors');
app.use(cors());

app.use(express.json());
app.use(express.urlencoded({extended:true}));
app.use('/hardware',hardware)
app.use('/frontend',frontend)
// app.use('/hyperledger',hyperledger)
app.use('/appd',appd)
app.use(express.static(path.join(__dirname, "../static/build")));

const server = http.createServer(app);
const io = socketIo(server, {
    cors: {
        origin: "*", // Allow all origins
        methods: ["GET", "POST"], // Allow these HTTP methods
        allowedHeaders: ["my-custom-header"], // Allow these headers
        credentials: true
    }});

io.on("connection",(Socket) => {
    Socket.on("location", async ({userId, latitude, longitude, reached, dist, time}) => {
        try {
            console.log({userId, latitude, longitude})
            const user=await User.findById(userId)
            if(user){
                user.latitude=latitude
                user.longitude=longitude
                user.reached=reached
                user.total=user.total+dist
                await user.save()
            }
            Socket.emit("location_web", {userId, latitude, longitude, reached, dist, time})
        } catch (error) {
            console.log(error)
        }
    })
    Socket.on("loading", async ({filled}) => {
        try {
            Socket.emit("fromDumper", {filled});
        } catch (error) {
            console.log(error)
        }
    })
})

server.listen(process.env.PORT, () => {
    console.log("server is running")
})

