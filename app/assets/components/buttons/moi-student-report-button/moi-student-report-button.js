Polymer({
  is: 'moi-student-report-button',
  properties: {
    studentId: String,
    glyphicon: String,
    text: String
  },
  ready: function() {
    $(this.$.btnredirect).addClass('glyphicon ' + this.glyphicon);
  },
  redirectToReportPage: function(e) {
    var origin;
    e.stopPropagation();
    origin = window.location.origin;
    window.open(origin + "/tutor/report?user_id=" + this.studentId, '_blank');
  }
});
