Polymer({
  is: 'moi-send-client-request-button',
  properties: {
    text: String,
    loadingText: String,
    sendRequestApi: String,
    ids: {
      type: Array,
      value: function() {
        return [];
      }
    }
  },
  onClick: function() {
    this.prevText = this.text;
    this.text = this.loadingText;
    $(this.$.btnsend).addClass('disabled');
    $.ajax({
      url: this.sendRequestApi,
      type: 'POST',
      data: {
        user_ids: this.ids
      },
      success: function(res) {
        this.text = this.prevText;
        $(this.$.btnsend).removeClass('disabled');
        this.fire('success', res);
      }.bind(this),
      error: function(res) {
        this.text = this.prevText;
        $(this.$.btnsend).removeClass('disabled');
        this.fire('error', res);
      }.bind(this)
    });
  }
});
