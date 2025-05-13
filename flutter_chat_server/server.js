const express = require("express");
const http = require("http");
const { Server } = require("socket.io");

const app = express();
const server = http.createServer(app);

const io = new Server(server, {
    cors: {
        origin: "*",
        methods: ["GET", "POST"]
    }
});

console.log("Starting Socket.IO server...");

io.on("connection", (socket) => {
    console.log("New client connected:", socket.id);

    socket.on("join_room", (userId) => {
        socket.join(userId);
        console.log(`User joined room: ${userId}`);
    });

    socket.on("send_message", (data) => {
        try {
            console.log("Send Message: ", data);

            const { senderId, receiverId, message } = data;

            io.to(receiverId).emit("receive_message", { senderId, message });

        } catch (e) {
            console.error('Failed to send message:', e);
        }
    });

    socket.on("disconnect", () => {
        console.log("Client disconnected:", socket.id);
    });
});

const PORT = process.env.PORT || 3000;
server.listen(PORT, "0.0.0.0", () => {
    console.log(`Server running on port ${PORT}`);
});
