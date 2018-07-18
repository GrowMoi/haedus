var UtilsBehavior = UtilsBehavior || {};
UtilsBehavior.parseQueryString = function (query) {
  var vars = query.split("&");
  var queryString = {};
  for (var i = 0; i < vars.length; i++) {
    var pair = vars[i].split("=");
    if (typeof queryString[pair[0]] === "undefined") {
      queryString[pair[0]] = decodeURIComponent(pair[1]);
    } else if (typeof queryString[pair[0]] === "string") {
      var arr = [queryString[pair[0]], decodeURIComponent(pair[1])];
      queryString[pair[0]] = arr;
    } else {
      queryString[pair[0]].push(decodeURIComponent(pair[1]));
    }
  }
  return queryString;
};

UtilsBehavior.getQueryUrlParams = function () {
  return window.location.search.substring(1) || '';
};

UtilsBehavior.getCurrentUrlParams = function () {
  var query = this.getQueryUrlParams();
  return this.parseQueryString(query);
};

UtilsBehavior.convertObjectToArrayItems = function (objectData) {
  var res = [];
  $.each(objectData, function (key, value) {
    res.push({
      label: key,
      value: value
    });
  });
  return res;
};

UtilsBehavior.addParamToUrl = function (stateName, paramName, value) {
  var url = window.location.href.split('?')[0];
  if (url) {
    window.history.pushState(stateName, '', url + '?' + paramName + '=' + value);
  }
};


UtilsBehavior.mergeObjectsWithSpecificProps = function(defaultObj, inputObj) {
  var result = {};
  Object.keys(defaultObj).forEach(function (key) {
    var inputProperty = inputObj[key];
    var defaultProperty = defaultObj[key];
    result[key] = inputProperty ? inputProperty : defaultProperty;
  });
  return result;
};

UtilsBehavior.isObject = function(obj) {
  return obj === Object(obj);
};

UtilsBehavior.isNumber = function(value) {
  return typeof value === 'number' && !isNaN(value);
};

//https://gist.github.com/simongong/14d39e113f1514a0264a3355efb44b15
UtilsBehavior.convertKeysFromSnakeToCamelCase = function(data, depth) {
  if (UtilsBehavior.isObject(data)) {
    if (typeof depth === 'undefined') {
      depth = 1;
    }
    return processKeys(data, camelize, depth);
  } else {
    return camelize(data);
  }
};

UtilsBehavior.convertKeysFromCamelToSnakeCase = function(data, depth) {
  if (UtilsBehavior.isObject(data)) {
    if (typeof depth === 'undefined') {
      depth = 1;
    }
    return processKeys(data, snakelize, depth);
  } else {
    return snakelize(data);
  }
};

function snakelize(key) {
  var separator = '_';
  var split = /(?=[A-Z])/;

  return key.split(split).join(separator).toLowerCase();
}

function camelize(key) {
  if (UtilsBehavior.isNumber(key)) {
    return key;
  }
  key = key.replace(/[\-_\s]+(.)?/g, function(match, ch) {
    return ch ? ch.toUpperCase() : '';
  });
  return key.substr(0, 1).toLowerCase() + key.substr(1);
}

function processKeys(obj, processer, depth) {
  if (depth === 0 || !UtilsBehavior.isObject(obj)) {
    return obj;
  }

  var result = {};
  var keys = Object.keys(obj);

  for (var i = 0; i < keys.length; i++) {
    result[processer(keys[i])] = processKeys(obj[keys[i]], processer, depth - 1);
  }

  return result;
}

