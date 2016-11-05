const rows = "ABCDEFGHI".split("")
const cols = "123456789".split("")

export default function(rowNumber, colNumber) {
  const rowIndex = rowNumber - 1
  const colIndex = colNumber - 1
  if (rowIndex < 0 || rows.length <= rowIndex) {
    console.warn("Row index out of bounds", rowIndex);
  }
  if (colIndex < 0 || cols.length <= colIndex) {
    console.warn("Col index out of bounds", colIndex);
  }
  return rows[rowIndex] + cols[colIndex]
}
