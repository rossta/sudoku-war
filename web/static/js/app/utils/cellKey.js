const rows = "ABCDEFGHI".split("")
const cols = "123456789".split("")

export function cellKey(rowNumber, colNumber) {
  assertInBounds(colNumber)

  return rowLetter(rowNumber) + colNumber
}

export function rowLetter(rowNumber) {
  assertInBounds(rowNumber)

  return rows[rowNumber - 1]
}

function assertInBounds(type, number) {
  if (number < 1 || number > 9) {
    console.warn(`${type} index out of bounds`, number);
  }

  return number
}
