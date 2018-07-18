Polymer({
  is: 'moi-chosen',
  properties: {
    items: {
      type: Array,
      value: function() {
        return [];
      }
    },
    placeholder: String
  },
  observers: ['updateChosen(items.*)'],
  updateChosen: function(items) {
    var _this;
    _this = this;
    if (items.value.length > 0) {
      this.async(function() {
        return $(_this.$.chosenselector).chosen({
          no_results_text: I18n.t('views.tutor.common.nothing_found'),
          width: '100%'
        }).change(function(e, val) {
          var key;
          key = Object.keys(val)[0];
          if (key === 'selected') {
            _this.fire('item-selected', val[key]);
          }
          if (key === 'deselected') {
            return _this.fire('item-deselected', val[key]);
          }
        });
      });
    }
  }
});
