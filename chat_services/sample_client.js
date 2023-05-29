const io = require("socket.io-client").io;


const socket = io("ws://localhost:3400")

socket.on("handshake", msg => {
    console.log("Connected")
})

// Reload + current id
socket.on("Reload 8", msg => {
    console.log("Receive reload signal from server");
})