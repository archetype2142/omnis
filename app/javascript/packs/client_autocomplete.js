import React, { Component } from 'react';
import ReactDOM from 'react-dom';
import ClientSearch from '../orders/ClientSearch';
import AddProduct from '../orders/AddProduct';
import OrderSummary from '../orders/OrderSummary';

class ClientAutocomplete extends Component {
  constructor() {
    super()
    this.state = {
      client: [],
      orderId: [],
      products: [],
      key: ''
    };

    this.getClient = this.getClient.bind(this);
    this.getOrderId = this.getOrderId.bind(this);
    this.getProductId = this.getProductId.bind(this);
  }
  
  componentDidMount() {    
    fetch('http://' + window.location.host + '/admin_api_keys')
      .then(data => data.json())
      .then((res) => {
        this.setState({key: res});
        console.log(this.state.key);
      });
  }

  getClient = (clientData) => {
    this.setState({client: clientData});
  }

  getOrderId = (order_id) => {
    this.setState({orderId: this.state.orderId.concat(order_id)});
  }

  getProductId = (new_products) => {
    this.setState({products: new_products})
  }

  render() { 
    return(
      <>
        <ClientSearch callbackClient={this.getClient} apiKey={this.state.key}/>
        <AddProduct client={this.state.client} orderId={this.getOrderId} items={this.getProductId} apiKey={this.state.key}/>
        <OrderSummary selectedOrderSummary={this.state.products} apiKey={this.state.key}/>
      </>
    )
  }
}

ReactDOM.render(
  <ClientAutocomplete/>,
  document.getElementById('client_autocomplete')
);
