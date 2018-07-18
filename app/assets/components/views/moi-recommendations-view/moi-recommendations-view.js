Polymer({
  is: 'moi-recommendations-view',
  behaviors: [TranslateBehavior, AssetBehavior, StudentBehavior, UtilsBehavior, NotificationBehavior],
  ready: function() {
    NotificationBehavior.getNotifications(function(counter) {
      this.notificationCounter = counter;
    }.bind(this));
  }
});
