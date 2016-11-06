import React from 'react'
import classnames from 'classnames'
import { setGame, selectCell, enterValue } from '../actions'

import { cellKey } from '../../utils'
import { Cell } from '../components'

export default class Board extends React.Component {
  renderRows(data) {
    const { grid } = data
    const { dispatch, selectedCell, gameChannel } = this.props

    const rows = []
    const onSelectCell = (row, col) => dispatch(selectCell(row, value))
    const onEnterValue = (row, col, value) => dispatch(enterValue(gameChannel, row, col, value))

    let cells, value, key, rowClasses, hsb, color;

    hsb = 0

    for (let row = 1; row <= 9; row++) {
      cells = []

      for (let col = 1; col <= 9; col++) {
        key = cellKey(row, col)
        value = grid[key]
        hsb += 0.01
        color = "hsb(" + hsb + ", 1, 1)"

        const cellProps = {
          key,
          row,
          col,
          value,
          color,
          selectedCell,
          onSelectCell,
          onEnterValue,
        }

        cells.push(<Cell {...cellProps} />)
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
