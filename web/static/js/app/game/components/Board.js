import React from 'react'
import classnames from 'classnames'
import { setGame } from '../actions'
import { cellKey } from '../../utils'
import { Cell } from '../components'

export default class Board extends React.Component {
  renderRows(data) {
    const { grid } = data

    const rows = []
    let cells, value, key, rowClasses;

    for (let row = 1; row <= 9; row++) {
      cells = []

      for (let col = 1; col <= 9; col++) {
        key = cellKey(row, col)
        value = grid[key]
        cells.push(<Cell {...{ key, row, col, value }} />)
      }

      rowClasses = classnames('row', `row-${row}`)

      rows.push(<div className={rowClasses} key={row}>{cells}</div>)
    }

    return rows
  }

  render() {
    const { data } = this.props

    if (!data) { return false }

    const classes = 'board'

    return (
      <div className={classes}>
        {this.renderRows(data)}
      </div>
    )
  }
}
