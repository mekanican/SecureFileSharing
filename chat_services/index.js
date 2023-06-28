const fastify = require('fastify')({ logger: true })
const Server = require("socket.io").Server;

const http = require('http');
const server = http.createServer();

// const io = new Server(3400, {logger: true}); // Socket port for Flutter, GLOBAL
const io = new Server(server); // Socket port for Flutter, GLOBAL
io.on("connection", socket => {
    console.log("init connection")
    socket.emit("handshake", "OK");
})


// Declare a route
// TODO: getting Django to call to this service on message send
fastify.get('/:id', async (request, reply) => {
    console.log(request.params.id);

    const signal = `Reload ${request.params.id}`;
    io.emit(signal, "");

    return {}
})

// Run the server!
const start = async () => {
    try {
        console.log("A");
        server.listen(3400, "0.0.0.0");
        console.log("A");
        await fastify.listen({ host:"0.0.0.0", port: 23432 }) // Web PORT for Django, LOCAL
        console.log("A");
    } catch (err) {
        fastify.log.error(err)
        process.exit(1)
    }
}
start()

// Example: localhost:23432/1, localhost:23432/2
// localhost:23432/8 -> trigger 8 to reload
