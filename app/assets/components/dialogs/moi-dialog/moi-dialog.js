Polymer({
  is: 'moi-dialog',
  properties: {
    title: {
      type: String,
      value: ''
    },
    width: {
      type: Number,
      value: 300
    },
    theme: {
      type: String,
      value: ''
    }
  },
  ready: function() {
    var _this;
    _this = this;
    _this.dialogWidth = "width: " + _this.width + "px";
    $(_this).css({
      position: 'fixed',
      zIndex: '1031',
      left: (($(window).width() - $(_this).outerWidth()) / 2) - (_this.width / 2),
      top: (($(window).height() - $(_this).outerHeight()) / 2) - 200
    });
    if (_this.theme && _this.theme.length > 0) {
      $(_this.$['moi-dialog-content']).addClass(_this.theme);
    }
    return $(_this).hide();
  },
  closeDialog: function() {
    return $(this).hide();
  }
});
