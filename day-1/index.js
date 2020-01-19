const fs = require('fs');
const calculator = require('./solution')

fs.readFile('./input', (err, data) => {
  if (err) {
    console.error(err)
  } else {
    const lines = data.toString().split('\n');
    console.log(lines.reduce((total, line) => total += calculator.totalFuel(parseInt(line)), 0))
  }
})