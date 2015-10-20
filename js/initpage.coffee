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

refreshAsides = (withLogging = false) ->

    origLog = log
    if not withLogging
        log = (msg) ->

    # Special thanks to the Game Programming Patterns book for the sample on how to
    # set up asides.
    # https://github.com/munificent/game-programming-patterns/blob/master/html/script.js#L24
    # Also, you should read: http://gameprogrammingpatterns.com/contents.html

    $("aside").each((index) ->
        # Don't mess with aside offsets if we're in a mode where they're not being positioned
        # absolutely (e.g. small screen mode)
        if $(@).css('position') != 'absolute'
            return

        name = $(@).attr('name')
        if not name
            log("Aside tag found without a name")
            return

        target = $("span[name='#{name}']")
        if target.length == 0
            log("Could not find span tag to match aside name '#{name}'")
            return

        targetY = target.offset().top + target.outerHeight() / 2
        $(@).offset({ top: targetY - $(@).outerHeight() / 2 })
    )

    if not withLogging
        log = origLog

$(document).ready ->
    window.clearlog = clearlog
    clearlog()

    refreshAsides(withLogging: true)
    $(window).resize(refreshAsides)

    # Hacks ahoy: Additional refreshes which give the document a bit more time to load
    # Redundant calls to refreshAsides are harmless, if inelegant
    setTimeout(refreshAsides, 200) # Fast connections
    setTimeout(refreshAsides, 600) # Medium fast connections
    setTimeout(refreshAsides, 1500) # Slower connections
    setTimeout(refreshAsides, 3100) # Chrome, etc., wait 3 seconds before giving up on fonts
    setTimeout(refreshAsides, 31000) # Safari waits 30 seconds before giving up on fonts