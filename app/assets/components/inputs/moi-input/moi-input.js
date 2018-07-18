Polymer({
  is: 'moi-input',
  properties: {
    iconImage: String,
    textValue: {
      type: String,
      value: '',
      notify: true
    }
  },
  checkForEnter: function(e) {
    if (e.keyCode === 13) {
      return this.fire('press-enter', this.textValue);
    }
  }
});
