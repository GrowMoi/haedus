Polymer({
  is: 'moi-tutor-notifications-card-content',
  behaviors: [TranslateBehavior, AssetBehavior, NotificationBehavior, UtilsBehavior],
  properties: {
    tutorId: String,
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
    this.notifications = [];
    this.startPusher();
    var notificationsApi = '/tutor/notifications/info';
    this.rowImage = this.assetPath('bell.svg');
    this.emptyNotifications = true;
    this.pusherEvents = [
      'client_test_completed',
      'client_message_open',
      'client_got_item',
      'client_recommended_contents_completed'
    ];

    this.titleMapping = {
      'client_test_completed': this.t('views.tutor.dashboard.card_tutor_notifications.client_test_completed'),
      'client_message_open': this.t('views.tutor.dashboard.card_tutor_notifications.client_message_open'),
      'client_got_item': this.t('views.tutor.dashboard.card_tutor_notifications.client_got_item'),
      'client_recommended_contents_completed': this.t('views.tutor.dashboard.card_tutor_notifications.client_recommended_contents_completed'),
      'client_got_diploma': this.t('views.tutor.dashboard.card_tutor_notifications.client_got_diploma')
    };

    this.actionsMapping = {
      'client_test_completed': this.buildClientTestCompleted.bind(this),
      'client_message_open': this.buildClientMessageOpen.bind(this),
      'client_got_item': this.buildClientGotItem.bind(this),
      'client_recommended_contents_completed': this.buildClientRecommendedContentsCompleted.bind(this)
    };

    this.loading = true;
    this.loadingDialogData = false;
    this.itemToRemove = null;
    this.emitters = {
      onNotificationOpen: null
    };
    this.resetDialogFlags();
    $.ajax({
      url: notificationsApi,
      type: 'GET',
      success: this.onGetNotificationsApiSuccess.bind(this)
      //error:  this.onGetNotificationsApiError.bind(this)
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
      onNotificationOpen: this.onNotificationOpen.bind(this),
      onNotificationRemoved: this.onNotificationRemoved.bind(this),
      reload: this.reload.bind(this)
    };
  },
  onNotificationOpen: function(callback) {
    this.emitters.onNotificationOpen = callback;
  },
  onNotificationRemoved: function(callback) {
    this.emitters.onNotificationRemoved = callback;
  },
  onNotificationReceived: function(notification) {
    this.addTitleToNotification(notification);
    this.push('notifications', notification);
  },
  onGetNotificationsApiSuccess: function(res) {
    this.loading = false;
    this.notifications = res.data || [];
    this.emptyNotifications = this.notifications.length === 0;
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
    this.pusherEvents.forEach(function(eventName) {
      NotificationBehavior.listenChannel(
        channel,
        eventName,
        this.onNotificationReceived.bind(this)
      );
    }.bind(this));
  },
  openDialogDetails: function(ev) {
    this.loadingDialogData = true;
    this.notificationData = {};
    this.resetDialogFlags();
    var model = ev.model;
    var notificationSelected = model.item;
    $(this.$['dialog-notification-info']).show();
    $.ajax({
      url: '/tutor/notifications/' + notificationSelected.id + '/details',
      type: 'GET',
      success: function(res) {
        this.loadingDialogData = false;
        model.set('item.opened', true);
        if (this.emitters.onNotificationOpen) {
          this.emitters.onNotificationOpen(notificationSelected);
        }
        this.validateAndBuildDialogData(res, notificationSelected);
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
  },
  validateAndBuildDialogData: function(res, notificationSelected) {
    var action = this.actionsMapping[notificationSelected.data_type];
    if (action) {
      action(res, notificationSelected);
    }
  },
  openDialogConfirm: function (ev) {
    ev.stopPropagation();
    this.itemToRemove = null;
    var notificationSelected = ev.model.item;
    this.itemToRemove = notificationSelected;
    $(this.$['dialog-confirm']).show();
  },
  closeDialogConfirm: function(ev){
    $(this.$['dialog-confirm']).hide();
  },
  removeNotification: function() {
    var notificationSelected = this.itemToRemove;
    var index = this.notifications.indexOf(notificationSelected);
    if (index !== -1) {
      $.ajax({
        url: '/tutor/notifications/' + notificationSelected.id + '/remove',
        type: 'DELETE',
        success: function(res) {
          this.splice('notifications', index, 1);
          $(this.$['dialog-confirm']).hide();
          if (this.emitters.onNotificationRemoved) {
            this.emitters.onNotificationRemoved(notificationSelected);
          }
          this.async(function() {
            this.emptyNotifications = this.notifications.length === 0;
          }.bind(this));

        }.bind(this),
        error: function(res) {
          $(this.$['dialog-confirm']).hide();
          var message = res.responseJSON && res.responseJSON.message ? res.responseJSON.message : '';
          this.toastMessage = message;
          this.$['toast-message'].show();
        }.bind(this)
      });
    }
  },
  buildClientTestCompleted: function(res, notificationSelected) {
    this.clientTestCompleted = true;
    var totalQuestions = res.questions.questions.length,
        successAnswers = this.rigthAnswers(res.answers),
        description = 'Respondió ' + successAnswers + ' de ' + totalQuestions + ' preguntas correctamente',
        timeMessage = 'Tiempo usado: ' + res.time_quiz,
        answersWithResults =  this.mapQuizResults(res.answers, res.questions.questions),
        username = notificationSelected.client.username;

        this.notificationData =  {
          playerName: res.player_name,
          username: username,
          description: description,
          timeMessage: timeMessage,
          answers: answersWithResults
        };
  },
  buildClientMessageOpen: function(res, notificationSelected) {
    this.clientMessageOpen = true;
    var username = notificationSelected.client.username;
    this.notificationData =  {
      username: username,
      title: res.title,
      description: res.description,
      seenAt: res.seen_at
    };
  },
  buildClientGotItem: function(res, notificationSelected) {
    this.clientGotItem = true;
    var username = notificationSelected.client.username;
    this.notificationData =  {
      username: username,
      name: res.name,
      description: res.description
    };
  },
  buildClientRecommendedContentsCompleted: function(res, notificationSelected) {
    this.clientRecommendedContentsCompleted = true;
    var username = notificationSelected.client.username;
    this.notificationData =  {
      username: username,
      contents: res.contents || []
    };
  },
  resetDialogFlags: function() {
    this.clientTestCompleted = false;
    this.clientMessageOpen = false;
    this.clientGotItem = false;
    this.clientRecommendedContentsCompleted =  false;
  }
});
