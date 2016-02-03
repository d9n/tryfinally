---
---

getDebugConsole = ->
    return $('#debug-console')

logbuffer = []
maxNumLines = 5
log = (text) ->
    debugConsole = getDebugConsole()
    if (debugConsole.length == 0) # Production mode, no debug console
        return

    debugConsole.css('display', 'block')
    logbuffer.push(text)

    removedCount = logbuffer.length - maxNumLines;
    lines = logbuffer[-maxNumLines..]

    if removedCount > 0
        lines.splice(0, 0, "<i>... and #{removedCount} more lines...</i>")

    debugConsole.html(lines.join('<br>'))
    console.log(text)

clearlog = ->
    logbuffer = []
    debugConsole = getDebugConsole()
    if (debugConsole.length == 0) # Production mode, no debug console
        return

    debugConsole.css('display', 'none')
    debugConsole.html('')

# Special thanks to the Game Programming Patterns book for the sample on how to
# set up asides by pairing them with and positioning them against spans.
# https://github.com/munificent/game-programming-patterns/blob/master/html/script.js#L24
# Also, you should read: http://gameprogrammingpatterns.com/contents.html
loopAsides = (callback, withLogging = false) ->
    origLog = log
    if not withLogging
        log = (msg) ->

    $("aside").each((index) ->
        name = $(@).attr('name')
        if not name
            log("Aside tag found without a name")
            return

        target = $("span[name='#{name}']")
        if target.length == 0
            log("Could not find span tag to match aside name '#{name}'")
            return

        callback($(@), target)
    )

    if not withLogging
        log = origLog

initAsideMouseEvents = (withLogging = false) ->
    loopAsides((aside, span) ->
        addClassFunc = () ->
            span.addClass("highlight-span")
            aside.addClass("highlight-aside")
        removeClassFunc = () ->
            span.removeClass("highlight-span")
            aside.removeClass("highlight-aside")

        aside.mouseenter(addClassFunc)
        aside.mouseleave(removeClassFunc)
        span.mouseenter(addClassFunc)
        span.mouseleave(removeClassFunc)
    , withLogging)

refreshAsides = (withLogging = false) ->
    loopAsides((aside, span) ->
        # Don't mess with aside offsets if we're in a mode where they're not being positioned
        # absolutely (e.g. small screen mode)
        if aside.css('position') != 'absolute'
            return
        spanY = span.offset().top + span.outerHeight() / 2
        aside.offset({ top: spanY - aside.outerHeight() / 2 })
    , withLogging)

$(document).ready ->
    window.clearlog = clearlog
    clearlog()

    initAsideMouseEvents(withLogging: false)
    refreshAsides(withLogging: true)
    $(window).resize(refreshAsides)

    # Hacks ahoy: Additional refreshes which give the document a bit more time to load
    # Redundant calls to refreshAsides are harmless, if inelegant
    setTimeout(refreshAsides, 200) # Fast connections
    setTimeout(refreshAsides, 600) # Medium fast connections
    setTimeout(refreshAsides, 1500) # Slower connections
    setTimeout(refreshAsides, 3100) # Chrome, etc., wait 3 seconds before giving up on fonts
    setTimeout(refreshAsides, 31000) # Safari waits 30 seconds before giving up on fonts
