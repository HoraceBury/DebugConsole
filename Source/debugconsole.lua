-- debug console

local widget = require("widget")

local lib = {}

local originalPrintFunc = print
local debugPrintFunc = nil

local showingDebugConsole = false
local debugConsoleGroup = nil

local debugPrintList = {}
local consoleBufferLength = 100
local consoleWidth = display.contentWidth
local consoleHeight = display.contentHeight
local fontSize = 32
local r, g, b = 1, 1, 1

debugPrintFunc = function( ... )
	originalPrintFunc( unpack( arg ) )
	local str = ""
	for i=1, #arg do
		str = str .. tostring(arg[i])
	end
	debugPrintList[#debugPrintList+1] = str
	while (#debugPrintList > consoleBufferLength) do
		table.remove( debugPrintList, 1 )
	end
end

local function setBufferLength( length )
	length = tonumber(length or 100)
	if (length < 1) then
		length = 1
	end
	consoleBufferLength = length
end

local function setFontSize( size )
	size = tonumber(size or 32)
	if (size < 8) then
		size = 8
	end
	fontSize = size
end

local function setBackgroundColor( _r, _g, _b )
	r = tonumber(_r or 1)
	g = tonumber(_g or 1)
	b = tonumber(_b or 1)
end

local function enableDebugPrint()
	print = debugPrintFunc
end

local function disableDebugPrint()
	print = originalPrintFunc
end

local function showDebugConsole()
	local group = display.newGroup()
	debugConsoleGroup = group
	
	local scrollview = widget.newScrollView{
		x = display.contentCenterX,
		y = display.contentCenterY,
		width = consoleWidth,
		height = consoleHeight,
		scrollWidth = consoleWidth,
		scrollHeight = consoleHeight,
		backgroundColor = {r,g,b},
		hideBackground = false,
	}
	group:insert( scrollview )
	
	local y = 0
	for i=1, #debugPrintList do
		local line = display.newText{ text=debugPrintList[i], fontSize=fontSize, width=consoleWidth }
		scrollview:insert( line )
		line.fill = {0,0,0}
		line.x, line.y = line.width * .5, y + line.height * .5
		y = y + line.height
	end
	
	if (y > display.actualContentHeight) then
		scrollview:setScrollHeight( y )
		local view = scrollview:getView()
		scrollview:scrollToPosition{ y=consoleHeight-y, time=0 }
	end
	
	return group
end

local function hideDebugConsole()
	debugConsoleGroup:removeSelf()
	debugConsoleGroup = nil
end

local function setConsoleWidth( width )
	width = tonumber(width)
	width = width or display.contentWidth
	if (width > display.actualContentWidth) then
		width = display.actualContentWidth
	end
	consoleWidth = width
end

local function setConsoleHeight( height )
	height = tonumber(height)
	height = height or display.contentHeight
	if (height > display.actualContentHeight) then
		height = display.actualContentHeight
	end
	consoleHeight = height
end

local function shake( event )
	if (event.isShake) then
		showingDebugConsole = not showingDebugConsole
		if (showingDebugConsole) then
			showDebugConsole()
		else
			hideDebugConsole()
		end
	end
	return true
end

local function enableDebugPrintConsole()
	Runtime:addEventListener( "accelerometer", shake )
end

local function disableDebugPrintConsole()
	Runtime:removeEventListener( "accelerometer", shake )
end

lib.enableDebugPrintConsole = enableDebugPrintConsole
lib.disableDebugPrintConsole = disableDebugPrintConsole
lib.enableDebugPrint = enableDebugPrint
lib.disableDebugPrint = disableDebugPrint
lib.setConsoleWidth = setConsoleWidth
lib.setConsoleHeight = setConsoleHeight
lib.showDebugConsole = showDebugConsole
lib.hideDebugConsole = hideDebugConsole
lib.setBufferLength = setBufferLength
lib.setFontSize = setFontSize
lib.setBackgroundColor = setBackgroundColor

return lib
