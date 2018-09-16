// Parse query string
var params = {};
var urlPairs = window.location.search.substring(1).split('&');
for (var i = 0; i < urlPairs.length; i++) {
  var paramPair = urlPairs[i].split('=');
  if (paramPair.length == 2) {
    var paramName = decodeURIComponent(paramPair[0]);
    var paramValue = decodeURIComponent(paramPair[1]);
    if (params[paramName]) {
      if (Array.isArray(params[paramName])) {
        params[paramName].push(paramValue);
      } else {
        params[paramName] = [ params[paramName], paramValue ];
      }
    } else {
      params[paramName] = paramValue;
    }
  }
}
