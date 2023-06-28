const io = require("socket.io-client").io;


const socket = io("wss://chat.hcmusproject.live")

socket.on("connect", () => {
    console.log("Connect successfully")
})

socket.on("connect_error", (err) => {
    console.log(`connect_error due to ${err.message}`);
  });

socket.on("handshake", msg => {
    console.log("Connected")
})

// Reload + current id
socket.on("Reload 8", msg => {
    console.log("Receive reload signal from server");
})
