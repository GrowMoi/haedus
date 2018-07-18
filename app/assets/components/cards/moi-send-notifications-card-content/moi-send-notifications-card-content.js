Polymer({
  is: 'moi-send-notifications-card-content',
  behaviors: [TranslateBehavior, StudentBehavior],
  properties: {
    authToken: String,
    currentTime: {
      type: Number,
      value: Date.now()
    },
    notificationTitle: {
      type: String,
      value: '',
      observer: 'enterTitle'
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
    this.loading = true;
    this.btnsendId = '#btnsend';
    this.formId = '#form';
    this.studentsApi = '/tutor/dashboard/students';
    this.sendNotificationApi = '/tutor/dashboard/send_notification';
    this.userIdSelect = '';
    this.title = '';

    var studentsAjax = $.ajax({
      url: this.studentsApi,
      type: 'GET'
    });
    return $.when(studentsAjax).then(function (res1) {
      var currentTime;
      this.loading = false;
      currentTime = Date.now();
      if (res1.data) {
        this.students = this.formatStudentData(res1.data);
      }
      return this.async(function () {
        this.disableBtn(this.btnsendId);
        return this.buildInputFileName(currentTime);
      }.bind(this));
    }.bind(this));
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
  onSelectFile: function (e, val) {
    var currentTime = Date.now();
    return this.updateInputFileName(currentTime);
  },
  buildInputFileName: function (currentTime) {
    var paramName = 'notification_medium_attributes';
    this.mediaInputName = "notification[" + paramName + "][" + currentTime + "][media]";
    this.cacheName = "notification[" + paramName + "][" + currentTime + "][media_cache]";
  },
  updateInputFileName: function (currentTime) {
    this.buildInputFileName(currentTime);
  },
  enableSendButton: function () {
    if (this.title.length > 0 && this.userIdSelect.length > 0) {
      return this.enableBtn(this.btnsendId);
    } else {
      return this.disableBtn(this.btnsendId);
    }
  },
  onStudentSelected: function (e, val) {
    this.userIdSelect = val;
    return this.enableSendButton();
  },
  enableBtn: function (id) {
    var btnSend = this.$$(id);
    return $(btnSend).removeClass('disabled');
  },
  disableBtn: function (id) {
    var btnSend = this.$$(id);
    return $(btnSend).addClass('disabled');
  },
  enterTitle: function (newVal) {
    this.title = newVal;
    return this.enableSendButton();
  }
});
