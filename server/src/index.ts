import {WebSocketServer} from 'ws';
import {customAlphabet} from 'nanoid'

const generateCode = customAlphabet('123456789abcdefghijklmnpqrstuvzxyw', 4)

const PORT = 8080

const wss = new WebSocketServer({port: PORT});

wss.on('connection', function connection(ws) {
    // Register handler
    ws.on('message', function message(data) {
        console.log('received: %s', data);
    });

    // Generate random code, use it as pseudo JWT and at the same time user ID
    const code = generateCode()
    ws.emit('id', code)
});

console.info("Server running at port %d", PORT)