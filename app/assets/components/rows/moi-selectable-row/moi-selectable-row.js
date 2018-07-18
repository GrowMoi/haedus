Polymer({
  is: 'moi-selectable-row',
  properties: {
    name: String,
    username: String,
    imgSelector: String,
    imgAvatarActive: String,
    imgAvatarInactive: String,
    options: Object,
    disableSelection: {
      type: Boolean,
      value: false
    },
    selected: {
      type: Boolean,
      value: false
    },
    studentId: String
  },
  ready: function() {
    this.imgAvatar = this.imgAvatarInactive;
    this.className = this.disableSelection ? 'disabled' : '';
    if (this.options && this.options.onRegisterApi) {
      var api = this.createPublicApi();
      this.options.onRegisterApi(api);
    }

  },
  selectRow: function() {
    if (this.disableSelection) {
      return;
    }
    this.selected = !this.selected;
    if (this.selected) {
      this.imgAvatar = this.imgAvatarActive;
    } else {
      this.imgAvatar = this.imgAvatarInactive;
    }
    this.fire('row-selected', this.studentId);
  },
  createPublicApi: function() {
    return {
      reset: this.reset.bind(this)
    };
  },
  reset: function () {
    this.selected = false;
    this.imgAvatar = this.imgAvatarInactive;
  }
});
