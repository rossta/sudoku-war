import React from 'react'

import { cellKey } from '../../utils'

export default class Cell extends React.Component {
  handleClick(x, y, value) {
    return e => {
      return console.log('cell click', x, y, value, e)
    }
  }

  handleMouseOver(x, y) {
    return this.toggleClasses(x, y)
  }

  handleMouseOut(x, y) {
    return this.toggleClasses(x, y)
  }

  toggleClasses(x, y) {
    return e => {
      e.preventDefault()
    }
  }

  render() {
    const { x, y, value } = this.props
    const id = cellKey(x, y)
    const classes = "cell"

    return (
      <div
        id={id}
        className={classes}
        onClick={::this.handleClick(x, y, value)}
        onDoubleClick={(e) => e.preventDefault()}
        onMouseOver={::this.handleMouseOver(x, y)}
        onMouseOut={::this.handleMouseOut(x, y)}>{value}</div>
    );
  }
}
