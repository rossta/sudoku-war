import React from 'react'
import classnames from 'classnames'

import { cellKey } from '../../utils'

export default class Cell extends React.Component {
  handleClick(row, col, value) {
    return e => {
      return console.log('cell click', row, col, value, e)
    }
  }

  handleMouseOver(row, col) {
    return this.toggleClasses(row, col)
  }

  handleMouseOut(row, col) {
    return this.toggleClasses(row, col)
  }

  toggleClasses(row, col) {
    return e => {
      e.preventDefault()
    }
  }

  render() {
    const { col, row, value } = this.props
    const id = cellKey(col, row)
    const classes = classnames("cell", `col-${col}`, `row-${row}`)

    return (
      <div
        id={id}
        className={classes}
        onClick={::this.handleClick(row, col, value)}
        onDoubleClick={(e) => e.preventDefault()}
        onMouseOver={::this.handleMouseOver(row, col)}
        onMouseOut={::this.handleMouseOut(row, col)}>{value}</div>
    );
  }
}
