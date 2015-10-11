---
---

getDebugConsole = ->
	return $('#debug-console')

removedCount = 0
maxNumLines = 5
log = (text) ->
	debugConsole = getDebugConsole()
	if (debugConsole.length == 0) # Production mode, no debug console
		return	

	debugConsole.css('display', 'block')
	lines = debugConsole.html().split('<br>').filter((line) -> line != '')
	lines.push(text)

	if lines.length > maxNumLines
		if removedCount > 0
			removedCount-- # Account for extra ... line we added last time

		removedCount += lines.length - maxNumLines;
		lines = lines[-maxNumLines..]
		lines.splice(0, 0, "<i>... and #{removedCount} more lines...</i>")

	debugConsole.html(lines.join('<br>'))
	console.log(text)

clearlog = ->
	removedCount = 0
	debugConsole = getDebugConsole()
	if (debugConsole.length == 0) # Production mode, no debug console
		return	

	debugConsole.css('display', 'none')
	debugConsole.html('')

$(document).ready ->
	window.clearlog = clearlog
	clearlog()

	for i in [1...100]
		delegate = (index) ->
			setTimeout((-> log("Hi: #{index}")), index * 10)

		delegate(i)
