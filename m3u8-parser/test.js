const m3u8Parser = require('m3u8-parser');
const parser = new m3u8Parser.Parser();

// Replace 'someM3U8Data' with your actual M3U8 content
const m3u8Content = `
  #EXTM3U
  #EXT-X-VERSION:3
  #EXT-X-TARGETDURATION:10
  #EXTINF:9.009,
  http://example.com/video1.ts
  #EXTINF:10.010,
  http://example.com/video2.ts
  `;

try {
    parser.push(m3u8Content);
    parser.end();
    const parsedData = parser.manifest;
    console.log(parsedData);
    // Continue processing the parsed data
} catch (error) {
    if (error instanceof m3u8Parser.SyntaxError) {
        console.error('M3U8 syntax error:', error.message);
        // Handle the M3U8 syntax error separately
    } else {
        console.error('Other error occurred:', error);
        // Handle other types of errors
    }
}
