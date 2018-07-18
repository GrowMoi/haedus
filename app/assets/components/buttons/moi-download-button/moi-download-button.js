Polymer({
  is: 'moi-download-button',
  properties: {
    href: String,
    text: String,
    loadingText: String,
    filename: String,
    mimeType: String,
    ids: {
      type: Array,
      value: function() {
        return [];
      }
    }
  },
  onClick: function() {
    var _this;
    this.prevText = this.text;
    this.text = this.loadingText;
    this.button = this.$['download-button'];
    $(this.button).addClass('disabled');
    _this = this;
    $.ajax({
      url: _this.href,
      type: 'GET',
      data: {
        ids: _this.ids
      },
      success: function(res) {
        _this.download.call(_this, res);
      }
    });
  },
  download: function(res) {
    var downloadLink, file, _this;
    _this = this;
    file = new Blob([res], {
      type: _this.mimeType
    });
    downloadLink = document.createElement('a');
    downloadLink.download = _this.filename;
    downloadLink.href = window.URL.createObjectURL(file);
    downloadLink.style.display = 'none';
    downloadLink.click();
    _this.text = _this.prevText;
    $(_this.button).removeClass('disabled');
  }
});
