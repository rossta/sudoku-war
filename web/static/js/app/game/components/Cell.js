import React from 'react'
import classnames from 'classnames'

import { cellKey } from '../../utils'
import CellInput from './CellInput'

export default class Cell extends React.Component {
  handleClick(row, col) {
    return e => {
      e.preventDefault()
      if (!this.isEditable()) { return false }

      return this.props.onSelectCell(row, col)
    }
  }

  handleMouseOver(row, col) {
    return this.toggleClasses(row, col)
  }

  handleMouseOut(row, col) {
    return this.toggleClasses(row, col)
  }

  handleEnterValue(row, col, value) {
    return this.props.onEnterValue(row, col, value)
  }

  toggleClasses(row, col) {
    return e => {
      e.preventDefault()
    }
  }

  getNumber() {
    const { value } = this.props
    return value === "0" ? "" : value
  }

  isEditable() {
    return this.getNumber().length < 1;
  }

  inputName() {
    const { col, row } = this.props
    return `number-input-${row}-${col}`
  }

  renderContent(row, col, number) {
    if (!this.isEditable()) { return number }
    const name = this.inputName()
    const ref = (input) => this.numberInput = input
    const onSubmit = ::this.handleEnterValue

    return <CellInput {...{name, ref, row, col, onSubmit}} />
  }

  render() {
    const { col, row, value, color } = this.props
    const id = cellKey(col, row)
    const number = this.getNumber()
    const classes = classnames("cell", `col-${col}`, `row-${row}`, {
      editable: this.isEditable()
    })

    return (
      <div
        id={id}
        className={classes}
        style={{color: color}}
        onClick={::this.handleClick(row, col)}
        onDoubleClick={(e) => e.preventDefault()}
        onMouseOver={::this.handleMouseOver(row, col)}
        onMouseOut={::this.handleMouseOut(row, col)}>
        {::this.renderContent(row, col, number)}
      </div>
    );
  }
}
