import React, { Component } from 'react';
import ReactDOM from 'react-dom';

class ClientSearch extends Component {
  constructor() {
    super()
    this.state = {
      results: [],
      shouldHide: false,
      client: []
    };

    this.ul = React.createRef;
    this.handleChange = this.handleChange.bind(this);
    this.handleClick = this.handleClick.bind(this);
  }

  handleChange(event) {
    event.preventDefault();
    self = this;
    
    if(!this.state.shouldHide) {
      fetch('http://' + window.location.host + '/api/v1/clients' + '?q=' + event.target.value)
        .then(res => res.json())
        .then(function(json) {
          self.setState({results: json});
      });
    }

    if(event.target.value == "") {
      this.setState({shouldHide: false});
    }
  }

  handleClick = item => event => {
    event.preventDefault();

    this.setState({results: [], shouldHide: true, client: item});
    this.props.callbackClient(item);
  }

  render() { 
    let list;
    let items = this.state.results;
    let client_search = '';

    if(Object.values(items).length == 0 && !this.state.shouldHide) {
      list = <li> No Results Found </li>;
    } else {
      list = Object.values(items).map(item => <li 
        onClick={this.handleClick(item)}
        key={item[0]} 
        label={item[1]} 
        value={item[1]}>{item[1]}</li>
      );
    }

    if(this.state.shouldHide === false)
      client_search = 
        <div className="control has-icons-left">
          <input 
            className='input'
            name="clients" 
            id="clients" 
            type="text" 
            placeholder="Search" 
            onChange={this.handleChange}
          />
          <span className="icon is-left">
            <i className="fas fa-search" aria-hidden="true"></i>
          </span>
          <ul className='search-results'> 
            {list}
          </ul>
        </div>;
    else { client_search = <h1 className="title">{this.state.client[1]}</h1>; }

    return(
      <div className="field box">
        <label className="label">Client</label>
        { client_search }
      </div>
    )
  }
}

export default ClientSearch;
