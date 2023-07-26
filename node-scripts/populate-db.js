const fs = require("fs");
const sqlite3 = require("sqlite3");
const path = require("path");

const freqList = JSON.parse(
  fs.readFileSync("./bncfrequency.json").toLocaleString()
).words;

const dbPath = path.join(__dirname, "../Pasco/dictionary.sqlite");
console.log(dbPath);

const db = new sqlite3.Database(dbPath);

for (const item of freqList) {
  console.log(item);
  db.run(`INSERT INTO words (word, score) VALUES ($word, $score)`, {
    $word: item.v,
    $score: item.w,
  });
}
