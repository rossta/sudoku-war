import React from 'react'
import classnames from 'classnames'

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

  renderContent(coord, row, col, number) {
    if (!this.isEditable()) { return number }
    const name = this.inputName()
    const ref = (input) => this.numberInput = input
    const onSubmit = ::this.handleEnterValue

    return <CellInput {...{name, coord, ref, row, col, onSubmit}} />
  }

  render() {
    const { coord, row, col, value, color, classes } = this.props
    const number = this.getNumber()
    const classNames = classnames(classes, {
      editable: this.isEditable()
    })

    return (
      <div
        id={coord}
        className={classes}
        style={{color: color}}
        onClick={::this.handleClick(coord)}
        onDoubleClick={(e) => e.preventDefault()}
        onMouseOver={::this.handleMouseOver(row, col)}
        onMouseOut={::this.handleMouseOut(row, col)}>
        {::this.renderContent(coord, row, col, number)}
      </div>
    );
  }
}
