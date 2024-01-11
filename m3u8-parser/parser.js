const axios = require('axios');
const m3u8Parser = require('m3u8-parser');

// Create a new instance of the m3u8 parser
const parser = new m3u8Parser.Parser();

// Replace the remote URL with the URL of the M3U8 file you want to parse
const remoteM3U8URL = 'https://ersatile-wildsidetv-1-fr.samsung.wurl.tv/playlist.m3u8';

// Make an HTTP GET request to fetch the remote M3U8 file
axios.get(remoteM3U8URL)
    .then(response => {
        const m3u8Content = response.data;

        // Parse the M3U8 content
        try {
            parser.push(m3u8Content);
            parser.end();
            const parsedData = parser.manifest;
            console.log(parsedData);
            // Continue processing the parsed data
        } catch (error) {
            console.error('Parsing failed:', error);
            // Handle the error and provide feedback or log it for debugging
        }
    })
    .catch(error => {
        console.error('Error fetching remote M3U8 file:', error);
        // Handle the error when fetching the file
    });
