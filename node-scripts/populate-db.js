const fs = require("fs");
const sqlite3 = require("sqlite3");
const path = require("path");

const LANGUAGE = "pl";
const FREQUENCY_FILE = "./pl.json";

const freqList = JSON.parse(
  fs.readFileSync(FREQUENCY_FILE).toLocaleString()
).words;

const dbPath = path.join(__dirname, "../Echo/dictionary.sqlite");
console.log(dbPath);

const db = new sqlite3.Database(dbPath);

for (const item of freqList) {
  console.log(item);
  db.run(
    `INSERT INTO words (word, score, language) VALUES ($word, $score, $language)`,
    {
      $word: item.v,
      $score: item.w,
      $language: LANGUAGE,
    }
  );
}
