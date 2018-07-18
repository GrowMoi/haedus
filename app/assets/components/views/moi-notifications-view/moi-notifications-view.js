Polymer({
  is: 'moi-notifications-view',
  behaviors: [TranslateBehavior, NotificationBehavior],
  properties: {
    tutorId: String,
  },
  ready: function() {
    NotificationBehavior.getNotifications(function(counter) {
      this.notificationCounter = counter;
    }.bind(this));

    this.notificationCardOptions = {
      onRegisterApi: this.onRegisterNotificationCardApi.bind(this)
    }

  },
  onRegisterNotificationCardApi: function(api) {
    this.notificationCardApi = api;
    this.notificationCardApi.onNotificationOpen(function(item) {
      this.notificationCounter--;
    }.bind(this));
    this.notificationCardApi.onNotificationRemoved(function(item) {
      if (!item.opened) {
        this.notificationCounter--;
      }
    }.bind(this));
  }
});
