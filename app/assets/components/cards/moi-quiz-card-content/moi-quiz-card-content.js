Polymer({
  is: 'moi-quiz-card-content',
  behaviors: [TranslateBehavior, StudentBehavior],
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
  reload: function() {
    this.init();
  },
  init: function () {
    var levelsAjax, studentsAjax, _this;
    this.levels = [];
    this.students = [];
    this.questions = [];
    this.loading = true;
    this.btnText = I18n.t('views.tutor.common.send');
    this.btnSendText = this.btnText;
    this.btnSendingText = I18n.t('views.submitting');
    this.levelsApi = '/tutor/dashboard/get_level_quizzes';
    this.studentsApi = '/tutor/dashboard/students';
    this.questionsApi = '/tutor/dashboard/get_questions';
    this.quizzesApi = '/tutor/dashboard/create_quiz';
    $(this.$.btnsend).addClass('disabled');
    this.apiParams = {
      level_quiz_id: '',
      client_id: ''
    };
    _this = this;
    levelsAjax = $.ajax({
      url: _this.levelsApi,
      type: 'GET'
    });
    studentsAjax = $.ajax({
      url: _this.studentsApi,
      type: 'GET'
    });
    $.when(levelsAjax, studentsAjax).then(function (res1, res2) {
      if (res1[0].data) {
        _this.levels = _this.formatData(res1[0].data);
      }
      if (res2[0].data) {
        _this.students = _this.formatStudentData(res2[0].data);
      }
      _this.loading = false;
    });
  },
  onLevelSelected: function (e, val) {
    var content_ids, item, _this;
    item = this.levels.find(function (item) {
      return item.id === parseInt(val);
    });
    this.apiParams.level_quiz_id = val;
    content_ids = item.content_ids;
    this.enableSendButton();
    _this = this;
    $.ajax({
      url: _this.questionsApi,
      type: 'GET',
      data: {
        content_ids: content_ids
      },
      success: function (res) {
        _this.questions = res.data;
      }
    });
  },
  onStudentSelected: function (e, val) {
    this.apiParams.client_id = val;
    this.enableSendButton();
  },
  formatData: function (items) {
    return $.map(items, function (item) {
      return {
        id: item.id,
        text: item.name,
        content_ids: item.content_ids
      };
    });
  },
  sendQuiz: function () {
    var _this;
    _this = this;
    $(_this.$.btnsend).addClass('disabled');
    _this.btnSendText = _this.btnSendingText;
    $.ajax({
      url: _this.quizzesApi,
      type: 'POST',
      data: {
        quiz: _this.apiParams
      }
    });
  },
  enableSendButton: function () {
    if ((this.apiParams.level_quiz_id === '') || (this.apiParams.client_id === '')) {
      return $(this.$.btnsend).addClass('disabled');
    } else {
      return $(this.$.btnsend).removeClass('disabled');
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
  }
});
