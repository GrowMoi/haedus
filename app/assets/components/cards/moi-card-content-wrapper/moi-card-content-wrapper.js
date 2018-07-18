Polymer({
  is: 'moi-card-content-wrapper',
  properties: {
    authToken: String,
    options: {
      type: Object,
      observer: 'bindOptions'
    }
  },
  ready: function() {
    this.init();
  },
  init: function() {
    this.recommendationCardContentApi = {};
    this.recommendationCardContentOptions = {
      onRegisterApi: this.onRegisterrecommendationCardContentApi.bind(this)
    };

  },
  reload: function() {
   if (this.recommendationCardContentApi.reload) {
    this.recommendationCardContentApi.reload();
   }
  },
  bindOptions: function() {
    this.registerLocalApi();
  },
  registerLocalApi: function() {
    if (this.options && this.options.onRegisterApi) {
      var api = this.createPublicApi();
      this.options.onRegisterApi(api);
    }
  },
  createPublicApi: function() {
    return {
      reload: this.reload.bind(this)
    };
  },
  onRegisterrecommendationCardContentApi: function(api) {
    this.recommendationCardContentApi = api;
  }
});
