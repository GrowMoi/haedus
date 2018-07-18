Polymer({
  is: 'moi-profile-view',
  behaviors: [TranslateBehavior, UtilsBehavior, NotificationBehavior],
  ready: function () {
    var profileApi = '/tutor/profile/info';
    NotificationBehavior.getNotifications(function(counter) {
      this.notificationCounter = counter;
    }.bind(this));
    this.userInfo = {
      name: '',
      username: '',
      email: ''
    };
    this.passwordData = {
      currentPassword: '',
      password: ''
    };
    this.passwordConfirmation = '';
    $.ajax({
      url: profileApi,
      type: 'GET',
      success: this.onGetProfileApiSuccess.bind(this),
      error:  this.onGetProfileApiError.bind(this)
    });
    this.btnSendProfile = $(this.$['btn-send-profile']);
    this.btnSendPassword = $(this.$['btn-send-password']);
    this.$['profile-form'].addEventListener('submit', this.onSubmitUserForm.bind(this));
    this.$['password-form'].addEventListener('submit', this.onSubmitPasswordForm.bind(this));
  },
  onGetProfileApiSuccess: function(res) {
    this.userInfo = this.mergeObjectsWithSpecificProps(this.userInfo, res);
  },
  onGetProfileApiError: function(res) {
    this.$['flash-message'].error(res.message);
  },
  onSubmitUserForm: function(event) {
    event.preventDefault();
    var updatePasswordApi = '/tutor/profile';
    this.btnSendProfile.addClass('disabled');
    $.ajax({
      url: updatePasswordApi,
      data: {
        tutor: this.userInfo
      },
      type: 'PUT',
      success: this.onSubmitSuccess.bind(this),
      error:  this.onSubmitError.bind(this)
    });

  },
  onSubmitPasswordForm: function(event) {
    event.preventDefault();
    var passwordFormatOk = true;
    var hasWhiteSpaces = /^\s|\s$/.test(this.passwordData.password);
    if (hasWhiteSpaces) {
      var text = this.t('views.tutor.profile.password_space_warn');
      passwordFormatOk = confirm(text);
    }
    if (passwordFormatOk) {
      if (this.passwordData.password !== this.passwordConfirmation) {
        var message = this.t('views.tutor.profile.different_password');
        this.$['flash-message'].error(message);
      } else {
        this.submitPasswordForm();
      }
    }
  },
  submitPasswordForm:  function() {
    var userParams = this.convertKeysFromCamelToSnakeCase(this.passwordData);
    var updatePasswordApi = '/tutor/profile/update_password';
    this.btnSendPassword.addClass('disabled');
    $.ajax({
      url: updatePasswordApi,
      data: {
        tutor: userParams
      },
      type: 'PUT',
      success: this.onSubmitSuccess.bind(this),
      error:  this.onSubmitError.bind(this)
    });
  },
  onSubmitSuccess: function(res) {
    this.btnSendProfile.removeClass('disabled');
    this.btnSendPassword.removeClass('disabled');
    this.$['flash-message'].success(res.message);
  },
  onSubmitError: function(res) {
    this.btnSendProfile.removeClass('disabled');
    this.btnSendPassword.removeClass('disabled');
    var json = res.responseJSON || {};
    this.$['flash-message'].error(json.message);
  }
});
