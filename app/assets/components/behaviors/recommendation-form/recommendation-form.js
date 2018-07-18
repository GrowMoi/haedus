var RecommendationFormBehavior = RecommendationFormBehavior || {};
RecommendationFormBehavior.properties = {
  loading: {
    type: Boolean,
    observer: 'onLoadingData'
  },
  btnSendText: String,
  students: {
    type: Array,
    value: function () {
      return [];
    }
  },
  achievements: {
    type: Array,
    value: function () {
      return [];
    }
  },
  contents: {
    type: Array,
    value: function () {
      return [];
    }
  },
  disableSendButton: {
    type: Boolean,
    observer: 'onButtonStatusChange'
  },
  loadingContents: Boolean
};

RecommendationFormBehavior.onLoadingData = function(newVal, oldVal) {
  _this = this;
  this.async(function() {
    $(_this.$$('#btn-send')).addClass('disabled');
  });
};

RecommendationFormBehavior.onButtonStatusChange = function (newVal) {
  if (newVal) {
    $(this.$$('#btn-send')).addClass('disabled');
  } else {
    $(this.$$('#btn-send')).removeClass('disabled');
  }
};

RecommendationFormBehavior.onAchievementSelected = function (e, val) {
  this.fire('achievement-selected', val);
};

RecommendationFormBehavior.onChoosenContentSelected = function (e, val) {
  this.fire('choosen-content-selected', val);
};

RecommendationFormBehavior.onChoosenContentDeselected = function (e, val) {
  this.fire('choosen-content-deselected', val);
};

RecommendationFormBehavior.onStudentSelected = function (e, val) {
  this.fire('student-selected', val);
};

RecommendationFormBehavior.openDialog = function () {
  this.fire('open-dialog');
};

RecommendationFormBehavior.sendRecommendation = function () {
  this.fire('send-recommendation');
};
