import React from 'react'
import { connect } from 'react-redux'

import { setDocumentTitle } from '../../utils'

class GameView extends React.Component {
  componentDidMount() {
    const { dispatch } = this.props

    setDocumentTitle('Game Room')

    // dispatch(fetchGames(lobbyChannel))
  }

  render() {
    const { dispatch } = this.props

    return (
      <div>
        <h3>Instructions</h3>
        <h3>Set up board</h3>
      </div>
    )
  }
}

const mapStateToProps = (state) => {
  return {...state.game}
}

export default connect(mapStateToProps)(GameView)
