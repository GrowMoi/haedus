Polymer({
  is: 'moi-client-view',
  behaviors: [TranslateBehavior, AssetBehavior, StudentBehavior, UtilsBehavior, NotificationBehavior],
  ready: function () {
    var _this = this;
    NotificationBehavior.getNotifications(function(counter) {
      this.notificationCounter = counter;
    }.bind(this));
    var studentsApi = '/tutor/dashboard/students';
    _this.statisticsApi = '/tutor/client/get_client_statistics';
    var params = _this.getCurrentUrlParams();
    _this.activityPath = '/tutor/analysis';
    _this.activityHref = '';
    _this.userIdSelected = null;
    _this.clientTreeSrc = '';
    _this.loading = true;
    _this.data = {};
    var studentsAjax = $.ajax({
      url: studentsApi,
      type: 'GET'
    });
    if (params && params.client_id) {
      _this.userIdSelected = params.client_id;
      var statisticsAjax = _this.buildStatisticsAjax(_this.userIdSelected);
      _this.getClientStatistics(studentsAjax, statisticsAjax).done(function () {
        _this.loading = false;
      });
    } else {
      _this.getStudents(studentsAjax).done(function () {
        _this.loading = false;
      });
    }
  },
  onStudentSelected: function (e, val) {
    var _this = this;
    _this.userIdSelected = val;
    _this.loading = true;
    var statisticsAjax = _this.buildStatisticsAjax(_this.userIdSelected);
    $.when(statisticsAjax).then(function (res) {
      _this.prepareAndFormatAnalysisData(res);
      _this.addParamToUrl('client', 'client_id', _this.userIdSelected);
    }).done(function (x) {
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
  getStudents: function (studentsAjax) {
    var _this = this;
    return $.when(studentsAjax).then(function (res) {
      if (res.data) {
        _this.students = _this.formatStudentData(res.data);
      }
    });
  },
  getClientStatistics: function (studentsAjax, statisticsAjax) {
    var _this = this;
    return $.when(studentsAjax, statisticsAjax).then(function (res1, res2) {
      if (res1[0].data) {
        _this.students = _this.formatStudentData(res1[0].data);
      }
      if (res2[0].data) {
        _this.prepareAndFormatAnalysisData(res2[0]);
      }
    });
  },
  buildStatisticsAjax: function (userIdSelected) {
    var _this = this;
    return $.ajax({
      url: _this.statisticsApi,
      type: 'GET',
      data: {
        client_id: userIdSelected
      }
    });
  },
  prepareAndFormatAnalysisData: function (res) {
    var _this = this;
    _this.data = res.data;
    _this.data.client = res.meta.client;
    _this.activityHref = _this.activityPath + '?client_id=' + _this.userIdSelected;
  }

});
