Polymer({
  is: 'moi-select',
  properties: {
    items: {
      type: Array,
      value: function() {
        return [];
      },
      observer: 'itemsLoaded'
    },
    placeholder: String,
    name: {
      type: String,
      value: ''
    }
  },
  ready: function() {
    var _this;
    _this = this;
    $(_this.$.selector).on('change', function(e) {
      var val;
      val = $(e.target).val();
      _this.fire('item-selected', val);
    });
  },
  itemsLoaded: function(newVal, oldVal) {
    var _this = this;
    if ((oldVal !== undefined) && (newVal !== oldVal) ) {
      _this.async(function() {
        _this.fire('items-loaded', _this);
      });

    }
  }
});
