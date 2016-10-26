import React                    from 'react'
import ReactDOM                 from 'react-dom'
import { browserHistory }       from 'react-router'
import { syncHistoryWithStore } from 'react-router-redux'
import { Provider }             from 'react-redux'

import { Router, configureStore } from './base'

const store  = configureStore(browserHistory);
const history = syncHistoryWithStore(browserHistory, store);

const target = document.getElementById('app-container');
const node = <Provider store={store}>
              <Router history={history} />
             </Provider>

document.addEventListener('DOMContentLoaded', () => ReactDOM.render(node, target))
