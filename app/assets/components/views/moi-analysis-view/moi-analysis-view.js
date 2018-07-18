Polymer({
  is: 'moi-analysis-view',
  behaviors: [TranslateBehavior, AssetBehavior, StudentBehavior, UtilsBehavior, NotificationBehavior],
  ready: function () {
    var _this = this;
    NotificationBehavior.getNotifications(function(counter) {
      this.notificationCounter = counter;
    }.bind(this));
    var studentsApi = '/tutor/dashboard/students';
    var studentsAjax = $.ajax({
      url: studentsApi,
      type: 'GET'
    });
    _this.students = [];
    _this.loading = true;
    _this.userIdSelected = null;
    _this.hasContentReadingTime = false;
    _this.analysisApi = '/tutor/analysis/get_user_analysis';
    _this.data = {};
    var params = _this.getCurrentUrlParams();
    if (params && params.client_id) {
      _this.userIdSelected = params.client_id;
      var analysisAjax = _this.buildAnalysisAjax(_this.userIdSelected);
      _this.getClientAnalysis(studentsAjax, analysisAjax).done(function () {
        _this.loading = false;
      });
    } else {
      _this.getStudents(studentsAjax).done(function () {
        _this.loading = false;
      });
    }
  },
  getStudents: function (studentsAjax) {
    var _this = this;
    return $.when(studentsAjax).then(function (res) {
      if (res.data) {
        _this.students = _this.formatStudentData(res.data);
      }
    });
  },
  onStudentSelected: function (e, val) {
    var _this = this;
    _this.userIdSelected = val;
    _this.loading = true;
    var analysisAjax = _this.buildAnalysisAjax(_this.userIdSelected);
    $.when(analysisAjax).then(function (res) {
      _this.prepareAndFormatAnalysisData(res);
      _this.addParamToUrl('analysis', 'client_id', _this.userIdSelected);
    }).done(function () {
      _this.loading = false;
    });
  },
  onSelectItemsLoaded: function (e, elem) {
    var _this = this;
    var params = _this.getCurrentUrlParams();
    if (params && params.client_id) {
      $(elem).find('select').val(params.client_id);
    }
  },
  getClientAnalysis: function (studentsAjax, analysisAjax) {
    var _this = this;
    return $.when(studentsAjax, analysisAjax).then(function (res1, res2) {
      if (res1[0].data) {
        _this.students = _this.formatStudentData(res1[0].data);
      }
      if (res2[0].data) {
        _this.prepareAndFormatAnalysisData(res2[0]);
      }
    });
  },
  prepareAndFormatAnalysisData: function (res) {
    var _this = this;
    _this.data = res.data;
    _this.data.username = res.meta.client.username;
    var contentReadings = _this.data.statistics.content_readings_by_branch.value;
    var timeItems = _this.convertObjectToArrayItems(contentReadings);
    _this.data.statistics.content_readings_by_branch.value = timeItems;
    _this.hasContentReadingTime = (_this.data.grouped_reading_time &&
      _this.data.grouped_reading_time.length > 0);
  },
  buildAnalysisAjax: function (userIdSelected) {
    var _this = this;
    return $.ajax({
      url: _this.analysisApi,
      type: 'GET',
      data: {
        client_id: userIdSelected
      }
    });
  }

});
