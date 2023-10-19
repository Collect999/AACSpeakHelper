const fs = require("fs");
const sqlite3 = require("sqlite3");
const path = require("path");

const LANGUAGE = "yi";

const dbPath = path.join(__dirname, "../Echo/dictionary.sqlite");
console.log(dbPath);

const db = new sqlite3.Database(dbPath);

let uniqueCharacters = new Set();

db.each(
  `SELECT * FROM words WHERE language = '${LANGUAGE}'`,
  (err, row) => {
    let letters = row.word.split("");
    letters.forEach((x) => uniqueCharacters.add(x.toLowerCase()));
  },
  () => {
    let allLetters = Array.from(uniqueCharacters).sort((a, b) => {
      return a.localeCompare(b);
    });

    console.log(allLetters);
    console.log(allLetters.join(","));
  }
);
