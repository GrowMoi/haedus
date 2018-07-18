Polymer({
  is: 'moi-flash-message',
  ready: function () {
    this.defaultProperties = {
      type: 'success',
      text: ''
    };
    this.MESSAGE_TYPES = {
      success: 'success',
      error: 'error'
    };
    this.mainContainer = this.$$('.message-container');
    this.text = '';
  },
  show: function (properties) {
    var selectedProperties = Object.assign({},
      this.defaultProperties,
      properties
    );
    this.cleanPreviousSelectedClasses();
    $(this.mainContainer).addClass(selectedProperties.type);
    this.text = selectedProperties.text;
    $(this).addClass('visible');
  },
  hide: function () {
    $(this).removeClass('visible');
  },
  closeMessage: function () {
    this.hide();
  },
  success: function(text) {
    this.show({
      text: text,
      type: this.MESSAGE_TYPES.success
    });
  },
  error: function(text) {
    this.show({
      text: text,
      type: this.MESSAGE_TYPES.error
    });
  },
  cleanPreviousSelectedClasses: function() {
    $(this.mainContainer).removeClass(this.MESSAGE_TYPES.success);
    $(this.mainContainer).removeClass(this.MESSAGE_TYPES.error);
  }
});
