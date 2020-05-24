import React, { Component } from 'react';
import ReactDOM from 'react-dom';

class AddProduct extends Component {
  constructor() {
    super()
    this.state = {
      new_order: [],
      old_orders: [],
      old_items: [],
      isFetched: false,
      orderExists: false
    };

    this.handleChange = this.handleChange.bind(this);
    this.sendOrderId = this.sendOrderId.bind(this);
  }

  componentDidMount() { }
  
  handleChange(event) {
    event.preventDefault();
  }
  sendOrderId = order => event => {
    var _this = this;
    event.preventDefault();

    fetch('http://' + window.location.host + '/api/v1/orders/' + order['number'], {
      headers: {
        'X-Spree-Token': this.props.apiKey['key']
      }
    })
      .then(data => data.json())
      .then(function(res) {
        let current_ids = _this.state.new_order.map(p => p.product_id);
        let unique_products = [];
       
        for(let i = 0; i < res['line_items'].length; i++){
          if (!current_ids.includes(res['line_items'][i]['variant_id'])) {
            unique_products.push(res['line_items'][i]);
          }
        }

        _this.setState({new_order: _this.state.new_order.concat(unique_products) }, () => {
          _this.props.items(_this.state.new_order);
        });
    });

    var new_orders = this.state.old_orders;

    Object.keys(new_orders).forEach(function (key) { 
      var value = new_orders[key]
      if(value['id'] === order['id']) {
        delete new_orders[key]
      }
    })

    this.setState({old_orders: new_orders});
  }

  
  set_items_to_order() {}

  fetch_old_orders(address_id) {
    var _this = this;
    var old_orders = '';
    let name = [];

    if (this.props.client[1]) {
      name = this.props.client[1].split(/[ ,]+/)
    }

    if(address_id) {
      const url = 'http://' + window.location.host + '/api/v1/orders/?bill_address_firstname_cont=' + name[0] + '&bill_address_lastname_cont=' + name[1]
      let products = [];

      fetch(url,  {
        headers: {
          'X-Spree-Token': this.props.apiKey['key']
        }
      })
      .then(data => data.json())
      .then(function(res) {
        for(let i = 0; i < res['orders'].length; i++){
          if(res['orders'][i]['total_quantity']) {
            products.push(res['orders'][i]);
          }
        }
        _this.setState({isFetched: true, old_orders: products});
      });
    }

    return old_orders;
  }
  

  render() {
    let old_orders = undefined;
    let old_o = <p className="has-text-centered"> No previous orders </p>;

    let old_items = [];
    let new_items = [];

    if(this.state.isFetched) {
      old_orders = this.state.old_orders;

      if(Object.keys(old_orders).length != 0) {
        old_o = Object.values(old_orders).map((order, index) => 
          <div key={index} onClick={this.sendOrderId(order)} className="column">
            <div className="old-order-box">
              <b>order</b>: {order['number']}<br></br>
              <b>items</b>: {order['total_quantity']}<br></br>
              <b>total</b>: {order['total']} <span>{order['currency']}</span><br></br>
            </div>
          </div> 
        );
      }
    } else {
      this.fetch_old_orders(this.props.client[0]);
    }

    let everything = ''
    if(this.state.isFetched) {
      everything = 
      <div className="columns">
        <div className="column">
          <div className="box">
            <h2>Old Orders</h2>
            <div className="columns">
              { old_o }
            </div>
          </div>

        </div>
        <div className="column">
          <div className="box">
            <h2>Add Items</h2>
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
              <ul className='search-results' 
                style={{ /*
                  position: 'relative', 
                  zIndex: 55, 
                  height: '200px', 
                  backgroundColor: 'green',
                  marginTop: '0px',
                  borderRadius: '0px'
              */}}> 
              </ul>
            </div>
          </div>
        </div>
      </div>
     }
    return(
      <div>
      { everything }
      </div>
    )
  }
}

export default AddProduct