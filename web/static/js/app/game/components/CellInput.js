import React from 'react'

const ENTER = 13

export default class CellInput extends React.Component {
  handleKeyUp(e) {
    e.preventDefault()

    if (e.keyCode === ENTER){
      const { row, col, onSubmit } = this.props
      const value = e.target.value

      onSubmit(row, col, value)
    }
  }

  render() {
    const { name } = this.props
    return <input
      onKeyUp={::this.handleKeyUp}
      maxLength="1"
      name={name}
      />
  }
}

