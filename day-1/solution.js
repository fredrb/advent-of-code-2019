const fs = require('fs');

const requiredFuel = (mass) => Math.floor(mass/3) - 2;
const orZero = (num, expr) => num > 0 ? num + expr(num) : 0;
const totalFuel = (mass) => orZero(requiredFuel(mass), totalFuel);
fs.readFile('./input', (_, data) => {
  console.log(data.toString().split('\n').reduce((total, line) => total += totalFuel(parseInt(line)), 0))
})

module.exports = { requiredFuel, totalFuel }