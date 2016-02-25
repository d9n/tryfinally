(function() {
  var clearlog, getDebugConsole, initAsideMouseEvents, log, logbuffer, loopAsides, maxNumLines, refreshAsides;

  getDebugConsole = function() {
    return $('#debug-console');
  };

  logbuffer = [];

  maxNumLines = 5;

  log = function(text) {
    var debugConsole, lines, removedCount;
    debugConsole = getDebugConsole();
    if (debugConsole.length === 0) {
      return;
    }
    debugConsole.css('display', 'block');
    logbuffer.push(text);
    removedCount = logbuffer.length - maxNumLines;
    lines = logbuffer.slice(-maxNumLines);
    if (removedCount > 0) {
      lines.splice(0, 0, "<i>... and " + removedCount + " more lines...</i>");
    }
    debugConsole.html(lines.join('<br>'));
    return console.log(text);
  };

  clearlog = function() {
    var debugConsole;
    logbuffer = [];
    debugConsole = getDebugConsole();
    if (debugConsole.length === 0) {
      return;
    }
    debugConsole.css('display', 'none');
    return debugConsole.html('');
  };

  loopAsides = function(callback, withLogging) {
    var origLog;
    if (withLogging == null) {
      withLogging = false;
    }
    origLog = log;
    if (!withLogging) {
      log = function(msg) {};
    }
    $("aside").each(function(index) {
      var name, target;
      name = $(this).attr('name');
      if (!name) {
        log("Aside tag found without a name");
        return;
      }
      target = $("span[name='" + name + "']");
      if (target.length === 0) {
        log("Could not find span tag to match aside name '" + name + "'");
        return;
      }
      return callback($(this), target);
    });
    if (!withLogging) {
      return log = origLog;
    }
  };

  initAsideMouseEvents = function(withLogging) {
    if (withLogging == null) {
      withLogging = false;
    }
    return loopAsides(function(aside, span) {
      var addClassFunc, removeClassFunc;
      addClassFunc = function() {
        span.addClass("highlight-span");
        return aside.addClass("highlight-aside");
      };
      removeClassFunc = function() {
        span.removeClass("highlight-span");
        return aside.removeClass("highlight-aside");
      };
      aside.mouseenter(addClassFunc);
      aside.mouseleave(removeClassFunc);
      span.mouseenter(addClassFunc);
      return span.mouseleave(removeClassFunc);
    }, withLogging);
  };

  refreshAsides = function(withLogging) {
    if (withLogging == null) {
      withLogging = false;
    }
    return loopAsides(function(aside, span) {
      if (aside.css('position') !== 'absolute') {
        return;
      }
      return aside.offset({
        top: span.offset().top
      });
    }, withLogging);
  };

  $(document).ready(function() {
    window.clearlog = clearlog;
    clearlog();
    initAsideMouseEvents({
      withLogging: false
    });
    refreshAsides({
      withLogging: true
    });
    $(window).resize(refreshAsides);
    setTimeout(refreshAsides, 200);
    setTimeout(refreshAsides, 600);
    setTimeout(refreshAsides, 1500);
    setTimeout(refreshAsides, 3100);
    return setTimeout(refreshAsides, 31000);
  });

}).call(this);
