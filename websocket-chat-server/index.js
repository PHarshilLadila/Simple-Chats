const WebSocket = require('ws');
const { parse } = require('url');

const wss = new WebSocket.Server({ port: 3000 });

const clients = new Map(); // userId => socket

wss.on('connection', (ws, req) => {
  const parameters = parse(req.url, true);
  const userId = parameters.query.userId;

  if (!userId) {
    ws.close(1008, 'Missing userId');
    return;
  }

  clients.set(userId, ws);
  console.log(`User connected: ${userId}`);

  ws.on('message', (message) => {
    try {
      const data = JSON.parse(message);
      const receiverId = data.receiver;

      const receiverSocket = clients.get(receiverId);
      if (receiverSocket && receiverSocket.readyState === WebSocket.OPEN) {
        receiverSocket.send(JSON.stringify(data));
      }

    } catch (error) {
      console.error('Invalid message format:', error.message);
    }
  });

  ws.on('close', () => {
    clients.delete(userId);
    console.log(`User disconnected: ${userId}`);
  });

  ws.on('error', (err) => {
    console.error(`WebSocket error for user ${userId}:`, err);
  });
});

console.log('WebSocket server running on ws://localhost:3000');
