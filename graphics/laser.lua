--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:8568712d04793110c57bcf23da7cf1c0:c2a5661bbc42cdcfeeb7e03b6f4d79a6:0ec66e9195143b9bea0a0eb6aa9c7627$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- laser1
            x=1,
            y=79,
            width=16,
            height=14,

        },
        {
            -- laser2
            x=1,
            y=62,
            width=16,
            height=15,

        },
        {
            -- laser3
            x=1,
            y=37,
            width=16,
            height=23,

        },
        {
            -- laser4
            x=1,
            y=1,
            width=16,
            height=34,

        },
    },
    
    sheetContentWidth = 18,
    sheetContentHeight = 94
}

SheetInfo.frameIndex =
{

    ["laser1"] = 1,
    ["laser2"] = 2,
    ["laser3"] = 3,
    ["laser4"] = 4,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
