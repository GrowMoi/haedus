Polymer({
  is: 'moi-tutor-notifications-card-content',
  behaviors: [TranslateBehavior, AssetBehavior, NotificationBehavior, UtilsBehavior],
  properties: {
    tutorId: String,
  },
  ready: function () {
    this.notifications = [];
    this.startPusher();
    var notificationsApi = '/tutor/notifications/info';
    this.rowImage = this.assetPath('bell.svg');
    this.titleMapping = {
      'client_got_item': this.t('views.tutor.dashboard.card_tutor_notifications.client_got_item'),
      'client_test_completed': this.t('views.tutor.dashboard.card_tutor_notifications.client_test_completed'),
      'client_message_opened': this.t('views.tutor.dashboard.card_tutor_notifications.client_message_opened'),
      'client_recommended_contents_completed': this.t('views.tutor.dashboard.card_tutor_notifications.client_recommended_contents_completed'),
      'client_got_diploma': this.t('views.tutor.dashboard.card_tutor_notifications.client_got_diploma')
    };
    this.loading = true;
    this.loadingDialogData = false;

    $.ajax({
      url: notificationsApi,
      type: 'GET',
      success: this.onGetNotificationsApiSuccess.bind(this)
      //error:  this.onGetNotificationsApiError.bind(this)
    });
  },
  onNotificationReceived: function(notification) {
    this.addTitleToNotification(notification);
    this.push('notifications', notification);
  },
  onGetNotificationsApiSuccess: function(res) {
    this.loading = false;
    this.notifications = res.data || [];
    this.formatNotifications(this.notifications);
  },
  formatNotifications: function(data) {
    for(var i = 0; i < data.length; i ++) {
      this.addTitleToNotification(data[i]);
    }
  },
  addTitleToNotification: function(notification) {
    notification.title = this.titleMapping[notification.data_type] || '';
  },
  startPusher: function() {
    if (!NotificationBehavior.pusherClient) {
      NotificationBehavior.createNewPusherClient(ENV.pusherAppKey, function() {
        console.log('Pusher: connection successful!');
        this.startPusherNotificationChannel();
      }.bind(this));
    } else {
      this.startPusherNotificationChannel();
    }
  },
  startPusherNotificationChannel: function() {
    var channel = 'tutornotifications.' + this.tutorId;
    NotificationBehavior.listenChannel(
      channel,
      'client-test-completed',
      this.onNotificationReceived.bind(this)
    );
  },
  openDialogDetails: function(ev) {
    var id = ev.model.item.id,
        username = ev.model.item.client.username;
    this.loadingDialogData = true;
    this.notificationData = {};
    $(this.$['dialog-notification-info']).show();
    $.ajax({
      url: '/tutor/notifications/' + id + '/details',
      type: 'GET',
      success: function(res) {
        this.loadingDialogData = false;
        var totalQuestions = res.questions.questions.length,
          successAnswers = this.rigthAnswers(res.answers),
          description = 'Respondió ' + successAnswers + ' de ' + totalQuestions + ' preguntas correctamente';
          timeMessage = 'Tiempo usado: ' + res.time_quiz;
          answersWithResults =  this.mapQuizResults(res.answers, res.questions.questions)
        this.notificationData =  {
          playerName: res.player_name,
          username: username,
          description: description,
          timeMessage: timeMessage,
          answers: answersWithResults
        };

      }.bind(this),
      error: function(res) {
        this.loadingDialogData = false;
        var message = res.responseJSON && res.responseJSON.message ? res.responseJSON.message : '';
        this.toastMessage = message;
        this.$['toast-message'].show();
      }.bind(this)
    });
  },
  rigthAnswers: function (results) {
    var count = 0;
    results.forEach(function(result){
      if (result.correct) {
        count += 1;
      }
    });
    return count;
  },
  mapQuizResults: function(answers, questions) {
    var results = [];
    for (var i = 0; i < questions.length; i ++) {
      var questionResult = questions[i].title + ' ' + (answers[i].correct ? '✓' : 'x');
      results.push(questionResult);
    }
    return results;
  }
});
