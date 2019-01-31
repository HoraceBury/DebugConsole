local debugconsole = require("debugconsole")
debugconsole.enableDebugPrint()
debugconsole.setBackgroundColor( .94, .64, .64 )
debugconsole.setFontSize( 40 )
debugconsole.setConsoleWidth( display.actualContentWidth*.8 )
debugconsole.setConsoleHeight( display.actualContentHeight*.8 )
debugconsole.enableDebugPrintConsole()

local function button( text, x, y, callback )
    local btn = display.newGroup()
    btn.x, btn.y = x, y
    display.newRect( btn, 0,0, 200,50 ).fill = {0,0,1}
    display.newText{ parent=btn, text=text }.fill = {1,1,1}
    btn[1].width, btn[1].height = btn[2].width*2, btn[2].height*2

    btn:addEventListener( "tap", callback )

    return btn
end

button("PRINT",display.contentCenterX, display.contentCenterY,function()
    print("Test print "..system.getTimer())
end)

button("SHAKE",display.contentCenterX, 150,function()
    Runtime:dispatchEvent{ name="accelerometer", isShake=true }
end)
