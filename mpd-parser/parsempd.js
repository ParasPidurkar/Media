const axios = require('axios');
const mpdParser = require('mpd-parser');

// Replace the remote URL with the URL of the MPD file you want to parse
const remoteMPDURL = 'https://example.com/your-remote-file.mpd';

// Make an HTTP GET request to fetch the remote MPD file
axios.get(remoteMPDURL)
    .then(response => {
        const mpdContent = response.data;

        // Parse the MPD content
        try {
            const mpd = mpdParser.parse(mpdContent);
            console.log(mpd);
            // Continue processing the parsed MPD data
        } catch (error) {
            console.error('Parsing failed:', error);
            // Handle the error and provide feedback or log it for debugging
        }
    })
    .catch(error => {
        console.error('Error fetching remote MPD file:', error);
        // Handle the error when fetching the file
    });