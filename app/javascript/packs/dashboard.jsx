import React from 'react';
import ReactDOM from 'react-dom';
import MainView from '../dashboard/MainView'
// import { BrowserRoute as Router, Route } from 'react-router-dom'

ReactDOM.render(
  // <Router>
    // <Route path="/" comoponent={} />
  // </Router>,
  <MainView/>,
  document.getElementById('root')
);

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
// serviceWorker.unregister();
