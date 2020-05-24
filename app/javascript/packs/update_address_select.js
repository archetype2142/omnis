import React, { Component } from 'react';
import ReactDOM from 'react-dom';

class AddressGenerator extends Component {
  constructor() {
    super()
    this.state = {
      company: false
    };
  }
  
  componentDidMount() {
    const self = this;
    document.querySelector('#client_type_type_id').addEventListener('change', function(event) {
      event.preventDefault();
      if(this.value === '2') {
        self.setState({company: true});
      } else if (this.value === '1') {
        self.setState({company: false});
      }
    });
  }

  render() {
    const company = this.state.company;
    let field; 
    if (company) {
      field = <>
      <div className="field">
        <label className="label">Company Name</label>
        <div className="control">
          <input className="input" type="text" name="client[company]" id="client_company" placeholder="company name" />
        </div>
      </div>

      <div className="field">
        <label className="label">NIP</label>
        <div className="control">
          <input className="input" type="text" name="client[nip]" id="client_nip" placeholder="NIP" />
        </div>
      </div>
      </>;
    } else {
      field = <div className="field">
        <label className="label">Pesel</label>
        <div className="control">
          <input className="input" type="text" name="client[pesel]" id="client_pesel" placeholder="Pesel" />
        </div>
      </div>;
    }

    return(
      <>
        {field} {/* render pesel or nip based on select tag */}
      </>
    )
  }
}

ReactDOM.render(
  <AddressGenerator/>,
  document.getElementById('address_generator')
);
