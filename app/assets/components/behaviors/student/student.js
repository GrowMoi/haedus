var StudentBehavior = StudentBehavior || {};
StudentBehavior.formatStudentData = function(items) {
  var students = items.filter(function(item) {
    return item.status == 'accepted';
  });

  return $.map(students, function(item) {
    var text;
    text = item.username;
    if (item.name) {
      text = item.name + " (" + item.username + ")";
    }
    return {
      id: item.id,
      text: text
    };
  });
};
