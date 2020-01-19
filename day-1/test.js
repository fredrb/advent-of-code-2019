const expect = require('chai').expect;
const calculator = require('./solution');

describe("[PART ONE] calculate fuel", () => {
  it("fuel for mass [12] to be [2]", () => {
    expect(calculator.requiredFuel(12)).to.be.equal(2);
  })

  it("fuel for mass [14] to be [2]", () => {
    expect(calculator.requiredFuel(14)).to.be.equal(2);
  })

  it("fuel for mass [1969] to be [654]", () => {
    expect(calculator.requiredFuel(1969)).to.be.equal(654);
  })

  it("fuel for mass [100756] to be [33583]", () => {
    expect(calculator.requiredFuel(100756)).to.be.equal(33583);
  })
})

describe("[PART TWO] calculate fuel recursievly", () => {
  it("fuel for mass [12] to be [2]", () => {
    expect(calculator.totalFuel(12)).to.be.equal(2);
  })

  it("fuel for mass [1969] to be [966]", () => {
    expect(calculator.totalFuel(1969)).to.be.equal(966);
  })

  it("fuel for mass [100756] to be [33583]", () => {
    expect(calculator.totalFuel(100756)).to.be.equal(50346);
  })
})