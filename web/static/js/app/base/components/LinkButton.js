import React from 'react'

export default class LinkButton extends React.Component {
  handleClick(e) {
    const { onClick } = this.props

    e.preventDefault()

    onClick(e)
  }

  render() {
    return (
      <a className="button" onClick={::this.handleClick}>
        {this.props.children}
      </a>
    )
  }
}
