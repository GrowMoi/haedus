Polymer({
  is: 'moi-dashboard-view',
  behaviors: [TranslateBehavior, NotificationBehavior],
  properties: {
    authToken: String
  },
  ready: function() {
    this.userCardApi = {};
    this.studentCardApi = {};
    this.sendNotificationCardApi = {};
    this.contentWrapperCardApi = {};
    this.quizContentCardApi = {};

    NotificationBehavior.getNotifications(function(counter) {
      this.notificationCounter = counter;
    }.bind(this));

    this.userCardOptions = {
      onRegisterApi: this.onRegisterUserCardApi.bind(this)
    };
    this.studentCardOptions = {
      onRegisterApi: this.onRegisterStudentCardApi.bind(this)
    };
    this.sendNotificationCardOptions = {
      onRegisterApi: this.onRegisterSendNotificationCardApi.bind(this)
    };
    this.contentWrapperCardOptions = {
      onRegisterApi: this.onRegisterContentWrapperCardApi.bind(this)
    };
    this.quizContentCardOptions = {
      onRegisterApi: this.onRegisterQuizContentCardApi.bind(this)
    };
  },
  onRegisterUserCardApi: function(api) {
    this.userCardApi = api;
    this.userCardApi.onUserRemoved(function(userRemoved) {
      if (this.sendNotificationCardApi.reload) {
        this.sendNotificationCardApi.reload();
      }
      if(this.studentCardApi.reload) {
        this.studentCardApi.reload();
      }
      if(this.contentWrapperCardApi.reload) {
        this.contentWrapperCardApi.reload();
      }
      if(this.quizContentCardApi.reload) {
        this.quizContentCardApi.reload();
      }
    }.bind(this));
  },
  onRegisterStudentCardApi: function(api) {
    this.studentCardApi = api;
    this.studentCardApi.onStudentRemoved(function() {
      if (this.sendNotificationCardApi.reload) {
        this.sendNotificationCardApi.reload();
      }
      if(this.contentWrapperCardApi.reload) {
        this.contentWrapperCardApi.reload();
      }
      if(this.quizContentCardApi.reload) {
        this.quizContentCardApi.reload();
      }
    }.bind(this));
  },
  onRegisterSendNotificationCardApi: function(api) {
    this.sendNotificationCardApi = api;
  },
  onRegisterContentWrapperCardApi: function(api) {
    this.contentWrapperCardApi = api;
  },
  onRegisterQuizContentCardApi: function(api) {
    this.quizContentCardApi = api;
  }
});
