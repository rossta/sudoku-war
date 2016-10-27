import React from 'react'

import { newGame } from '../actions'

export default class NewGameButton extends React.Component {
  handleClick(e) {
    const { dispatch, lobbyChannel } = this.props

    e.preventDefault()

    dispatch(newGame(lobbyChannel))
  }

  render() {
    return (
      <a className="button" onClick={::this.handleClick}>
        {this.props.children}
      </a>
    )
  }
}
