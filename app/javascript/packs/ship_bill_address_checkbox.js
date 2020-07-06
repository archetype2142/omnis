import React, { Component } from 'react';
import ReactDOM from 'react-dom';

class AddressGenerator extends Component {
  constructor() {
    super()
    this.state = {
      same_as_billing: true
    };
  }
  
  componentDidMount() {
    const self = this;
    let form = document.querySelector('#shipping_address_form');
    let checkbox = document.querySelector('#same_as_billing');
    let send_value = document.querySelector('#user_use_billing');

    if(checkbox.checked) {
      self.setState({same_as_billing: true})
      form.classList.add("hide");   
      send_value.value = true
    }

    checkbox.addEventListener('change', function(event) {
      event.preventDefault();
      if(this.checked) {
        self.setState({same_as_billing: true})
        form.classList.add("hide");
        send_value.value = true
      } else {
        self.setState({same_as_billing: false})
        form.classList.remove("hide");
        send_value.value = false
      }
    });
  }
  render() {
    
    return(
      <>
      </>
    )
  }
}

ReactDOM.render(
  <AddressGenerator/>,
  document.getElementById('shipping_address_mount')
);
