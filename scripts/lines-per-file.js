// Check all files inside a given directory and output the line and character count for each file
const fs = require('fs');
const path = require('path');

const outputFile = 'logs/lines-per-file.json';
const ignoreWhitespace = true;
const ignoreComments = true;

const args = process.argv.slice(2);
const dir = args[0] ?? 'lib';
const analisisResult = [];
const meta = { files: 0, maxLines: -1, maxChars: -1 };

function analizeDir(dir) {
    const dirs = fs.readdirSync(dir);

    for (let entry of dirs) {
        const joinedPath = path.join(dir, entry);
        const isDir = fs.lstatSync(joinedPath).isDirectory();
        if (isDir) {
            analizeDir(joinedPath);
        } else {
            analizeFile(joinedPath);
        }
    }
}

function analizeFile(file) {
    const content = fs.readFileSync(file).toString();
    const chars = content.length;
    const lines = content.split('\n')
        // filter whitespace
        .filter(line => (ignoreWhitespace && line != ''))
        // filter comments
        .filter(line => (ignoreComments && !line.startsWith('//')))
        .length;

    if (meta.maxLines < lines) {
        meta.maxLines = lines;
    }
    if (meta.maxChars < chars) {
        meta.maxChars = chars;
    }
    meta.files += 1;
    analisisResult.push({ lines, chars, file });
}

analizeDir(dir);
analisisResult.sort((a, b) => b.lines - a.lines);
console.log('Written result to: ' + outputFile);
fs.writeFileSync(outputFile, JSON.stringify({ meta, analisisResult, }, null, 4));