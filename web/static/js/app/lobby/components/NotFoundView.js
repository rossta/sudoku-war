import React from 'react'
import { Link } from 'react-router'
import { connect } from 'react-redux'
import NewGameButton from './NewGameButton'
import { setDocumentTitle } from '../../utils'

class NotFoundView extends React.Component {
  componentDidMount() {
    setDocumentTitle('Oops! Game not found!');
  }

  render() {
    const { lobbyChannel, dispatch } = this.props;

    return (
      <div id="not_found" className="view-container">
        <h1>Oops! Game not found!</h1>
        <NewGameButton {...{lobbyChannel, dispatch}}>
          Start new game
        </NewGameButton>&nbsp;
        <Link className="button" to="/play">Back to home</Link>
      </div>
    );
  }
}

const mapStateToProps = (state) => (
  { ...state.lobby }
);

export default connect(mapStateToProps)(NotFoundView);
