const fs = require("fs");
const sqlite3 = require("sqlite3");
const path = require("path");

const LANGUAGE = "yi";
const ALPHABET = "א,ב,ג,ד,ה,ו,װ,ז,ח,ט,י,ײ,כ,ך,ל,מ,ם,נ,ן,ס,ע,פ,ף,צ,ץ,ק,ר,ש,ת";

let countMap = new Map();

const dbPath = path.join(__dirname, "../Echo/dictionary.sqlite");
console.log(dbPath);

const db = new sqlite3.Database(dbPath);

db.each(
  `SELECT * FROM words WHERE language = '${LANGUAGE}'`,
  (err, row) => {
    let letters = row.word.split("");
    letters.forEach((x) => {
      let lowerX = x.toLowerCase();
      let current = countMap[lowerX] || 0;
      countMap[lowerX] = current + 1;
    });
  },
  () => {
    console.log(countMap);

    let frequencyAlphabet = ALPHABET.split(",").sort((a, b) => {
      return countMap[b] - countMap[a];
    });

    console.log(frequencyAlphabet);
    console.log(frequencyAlphabet.join(","));
  }
);
