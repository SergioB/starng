
/*
  The jsx is used instead of cjsx because of elusive bug (probable compile) which resulted in errors deep inside React.
*/

var ButtonComponent = React.createClass ({

  onClick: function (e) {
    e.preventDefault();
    this.props.handleClick(this.props.name);
  },

  render: function() {
    var classes = "btn btn-xs btn-default";
    return <button className={classes} onClick={this.onClick}>{this.props.name}</button>;
  }

});

Typeahead = React.createClass ({
  getInitialState : function() {
    return {input: ""};
  },

  handleChange: function() {
    this.setState({input: this.refs.field.value});
  },

  handleClick: function(variant) {
    this.setState({input: variant});
  },

  matches: function(input) {
    var regex = new RegExp(input, "i");
    return _.select (this.props.options, function(variant) {
      return variant.match(regex) && variant != input && input != '';
    });
  },

  renderButtons: function() {
    var self = this;
    return this.matches(this.state.input).map( function(variant) {
      return <ButtonComponent handleClick={self.handleClick} name={variant} key={variant} />;
    });
  },

  render: function() {
    return <div>
        <input ref='field' onChange={this.handleChange} value={this.state.input} />
        <br />
        {this.renderButtons()}
      </div>;
  }

});