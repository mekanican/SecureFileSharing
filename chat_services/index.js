const fastify = require('fastify')({ logger: true })
const Server = require("socket.io").Server;

const io = new Server(3400, {logger: true}); // Socket port for Flutter, GLOBAL

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
        await fastify.listen({ port: 23432 }) // Web PORT for Django, LOCAL
    } catch (err) {
        fastify.log.error(err)
        process.exit(1)
    }
}
start()

// Example: localhost:23432/1, localhost:23432/2
// localhost:23432/8 -> trigger 8 to reload
