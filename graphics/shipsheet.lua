--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:f8a34cdf7abfb5941ff2dc4119c29260:bf94a0611ecda62f40c45f6d877b7b1f:0100f169bb6acbe95123d224f5c82b59$
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
            -- ship-1
            x=1,
            y=1,
            width=86,
            height=82,

        },
        {
            -- ship-2
            x=89,
            y=1,
            width=86,
            height=82,

        },
        {
            -- ship-3
            x=265,
            y=1,
            width=84,
            height=82,

        },
        {
            -- ship-4
            x=437,
            y=1,
            width=82,
            height=82,

        },
        {
            -- ship-5
            x=605,
            y=1,
            width=80,
            height=82,

        },
        {
            -- ship0
            x=857,
            y=1,
            width=87,
            height=80,

        },
        {
            -- ship1
            x=769,
            y=1,
            width=86,
            height=81,

        },
        {
            -- ship2
            x=177,
            y=1,
            width=86,
            height=82,

        },
        {
            -- ship3
            x=351,
            y=1,
            width=84,
            height=82,

        },
        {
            -- ship4
            x=521,
            y=1,
            width=82,
            height=82,

        },
        {
            -- ship5
            x=687,
            y=1,
            width=80,
            height=82,

        },
    },
    
    sheetContentWidth = 945,
    sheetContentHeight = 84
}

SheetInfo.frameIndex =
{

    ["ship-1"] = 1,
    ["ship-2"] = 2,
    ["ship-3"] = 3,
    ["ship-4"] = 4,
    ["ship-5"] = 5,
    ["ship0"] = 6,
    ["ship1"] = 7,
    ["ship2"] = 8,
    ["ship3"] = 9,
    ["ship4"] = 10,
    ["ship5"] = 11,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
