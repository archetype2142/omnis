import React, { Component } from 'react';
import ReactDOM from 'react-dom';

class OrderSummary extends Component {
  constructor() {
    super()
    this.state = {
      orderIds: [],
      productIds: [],
      selectedOrderSummary: [],
      shouldHide: false
    };
    this.updatePrice = this.updatePrice.bind(this);
  }

  updatePrice = (event, index) => {
    event.preventDefault();
    let selectedOrderSummary = this.props.selectedOrderSummary;

    selectedOrderSummary[index].display_amount = 
    (selectedOrderSummary[index].price * event.target.value).toFixed(2) + 'zl';

    this.setState({selectedOrderSummary: selectedOrderSummary}, () => {
      console.log(this.state.selectedOrderSummary);
    });
  }

  componentWillReceiveProps(nextProps) {
    this.setState({selectedOrderSummary: nextProps.selectedOrderSummary})
  }

  render() {    
    let summary = this.state.selectedOrderSummary.length > 0 ? 
      this.state.selectedOrderSummary.map((value, index)=>(
        <tr key={index}>
          <th>{value['variant']['name']}</th>
          <td>{value.price}</td>
          <td>
            <input
              onChange={(e) => e.target.value < 0 ? e.preventDefault() : this.updatePrice(e, index)} 
              className="input" 
              min="0"
              style={{width: '33%'}} 
              type="number"
              defaultValue={value.quantity}
             />
          </td>
          <td>{value.display_amount}</td>
        </tr>
      ))
      :
      <tr><th>Empty order...</th></tr>
    return(
      <div className="box">
        <h1 className="title has-text-centered">Order Summary</h1>
        <table className="table">
          <thead>
            <tr>
              <th><abbr title="Name">Name</abbr></th>
              <th><abbr title="Price">Price</abbr></th>
              <th><abbr title="Quantity">Quantity</abbr></th>
              <th><abbr title="Total">Total</abbr></th>
            </tr>
          </thead>
          <tbody>
            {summary}
          </tbody>
        </table>
      </div>
    )
  }
}

export default OrderSummary