import React from 'react'
import classnames from 'classnames'
import { setGame } from '../actions'
import { cellKey } from '../../utils'
import { Cell } from '../components'

export default class Board extends React.Component {
  renderRows(data) {
    const { grid } = data

    // const rows = [this.buildRowHeader()]
    const rows = []
    let cells, value, key;

    for (let y = 0; y < 10; y++) {
      // cells = [<div key={`header-${y}`} className="header cell">{y + 1}</div>]
      cells = []

      for (let x = 0; x < 10; x++) {
        key = cellKey(x, y)
        value = grid[key]
        cells.push(<Cell {...{ key, x, y, value }} />)
      }

      rows.push(<div className="row" key={y}>{cells}</div>)
    }

    return rows
  }

  buildRowHeader() {
    const values = [<div key="empty" className="header cell"></div>]

    for (let i = 0; i < 10; ++i) {
      values.push(<div key={i} className="header cell">{String.fromCharCode(i+65)}</div>)
    }

    return (
      <div key="col-headers" className="row">
        {values}
      </div>
    )
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
