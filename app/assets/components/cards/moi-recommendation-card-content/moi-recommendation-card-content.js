Polymer({
  is: 'moi-recommendation-card-content',
  behaviors: [TranslateBehavior, StudentBehavior],
  properties: {
    authToken: String,
    type: {
      type: String,
      default: 'card'
    },
    options: {
      type: Object,
      observer: 'bindOptions'
    }
  },
  ready: function() {
    this.init();
  },
  reload: function() {
    this.init();
  },
  init: function () {
    var achievementsAjax, studentsAjax, _this;
    var achievementsApi = '/tutor/dashboard/achievements';
    var studentsApi = '/tutor/dashboard/students';
    this.contentsApi = '/tutor/dashboard/get_contents';
    this.isCardType = this.type == 'card';
    this.achievements = [];
    this.contents = [];
    this.btnText = this.t('views.tutor.dashboard.card_recommendations.btn_send');
    this.btnSendText = this.btnText;
    this.btnSendingText = this.t('views.submitting');
    this.createRecomendationsApi = '/tutor/recommendations';
    this.loadingContents = false;
    this.apiParams = {
      tutor_achievement: '',
      content_tutor_recommendations: [],
      students: []
    };
    this.loading = true;
    this.disableSendButton = true;
    _this = this;
    achievementsAjax = $.ajax({
      url: achievementsApi,
      type: 'GET'
    });

    studentsAjax = $.ajax({
      url: studentsApi,
      type: 'GET'
    });
    $.when(achievementsAjax, studentsAjax).then(function (res1, res2) {
      if (res1[0].data) {
        _this.achievements = _this.formatData(res1[0].data, 'name');
      }
      if (res2[0].data) {
        _this.students = _this.formatStudentData(res2[0].data);
      }
      _this.loading = false;
      _this.async(function() {
        _this.disableContentSelector();
      });

    });
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
  onAchievementSelected: function (e, val) {
    this.apiParams.tutor_achievement = val;
    this.updateSendButtonState();
  },
  onChoosenContentSelected: function (e, val) {
    this.apiParams.content_tutor_recommendations.push(val);
    this.updateSendButtonState();
  },
  onChoosenContentDeselected: function (e, val) {
    var index = this.apiParams.content_tutor_recommendations.indexOf(val);
    if (index !== -1) {
      this.apiParams.content_tutor_recommendations.splice(index, 1);
    }
    this.updateSendButtonState();
  },
  sendRecommendation: function () {
    this.disableSendButton = true;
    this.btnSendText = _this.btnSendingText;
    $.ajax({
      url: this.createRecomendationsApi,
      type: 'POST',
      data: {
        tutor_recommendation: this.apiParams
      }
    });
  },
  formatData: function (items, textParamName) {
    return $.map(items, function (item) {
      return {
        id: item.id,
        text: item[textParamName]
      };
    });
  },
  updateSendButtonState: function () {
    if ((this.apiParams.tutor_achievement === '') ||
       (this.apiParams.content_tutor_recommendations.length === 0) ||
       (this.apiParams.students.length === 0)) {

      this.disableSendButton = true;
    } else {
      this.disableSendButton = false;
    }
  },
  openDialog: function () {
    var dialog = this.$.dialog;
    if ($(dialog).is(':hidden')) {
      this.$.form.reset();
      $(this.$.fileselect).val('');
      $(this.$.imagecontent).children().remove();
      return $(dialog).show();
    }
  },
  onStudentSelected: function (e, val) {
    this.apiParams.students = [val];
    _this = this;
    _this.disableContentSelector();
    _this.loadingContents = true;
    $.ajax({
      url: _this.contentsApi,
      type: 'GET',
      data: {
        user_id: val
      },
      success: function (res) {
        if (res.data) {
          _this.loadingContents = false;
          _this.contents = _this.formatData(res.data, 'title');
          _this.enableContentSelector();
          _this.updateSendButtonState();
        }
      }
    });
  },
  disableContentSelector: function() {
    $(this.$$('#moi-choosen-container')).addClass('disabled');
  },
  enableContentSelector: function() {
    $(this.$$('#moi-choosen-container')).removeClass('disabled');
  }
});
