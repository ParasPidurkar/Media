const express = require('express');
const os = require('os');
const app = express();
const port = 3000;

// Function to get the server IP address
function getServerIP() {
    const ifaces = os.networkInterfaces();
    for (const dev in ifaces) {
        for (const details of ifaces[dev]) {
            if (details.family === 'IPv4' && !details.internal) {
                return details.address;
            }
        }
    }
    return '127.0.0.1';
}

const serverIP = getServerIP();

// Serve static files from the 'public' directory
app.use(express.static('public'));

app.listen(port, () => {
    console.log(`Media server running at http://${serverIP}:${port}`);
});
