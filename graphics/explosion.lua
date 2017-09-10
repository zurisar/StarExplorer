--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:9ab993c7de17ec1b3e2fc5f09136337c:35701ec5553b26a0c1e3bbb0fb83a1e6:ff6ed9a539a848dae2d91c7b3e7c2dd2$
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
            -- 01
            x=201,
            y=109,
            width=12,
            height=10,

            sourceX = 61,
            sourceY = 61,
            sourceWidth = 128,
            sourceHeight = 128
        },
        {
            -- 02
            x=419,
            y=35,
            width=24,
            height=26,

            sourceX = 56,
            sourceY = 48,
            sourceWidth = 128,
            sourceHeight = 128
        },
        {
            -- 03
            x=419,
            y=1,
            width=30,
            height=32,

            sourceX = 53,
            sourceY = 45,
            sourceWidth = 128,
            sourceHeight = 128
        },
        {
            -- 04
            x=201,
            y=71,
            width=36,
            height=36,

            sourceX = 50,
            sourceY = 43,
            sourceWidth = 128,
            sourceHeight = 128
        },
        {
            -- 05
            x=101,
            y=73,
            width=42,
            height=42,

            sourceX = 47,
            sourceY = 40,
            sourceWidth = 128,
            sourceHeight = 128
        },
        {
            -- 06
            x=53,
            y=75,
            width=46,
            height=46,

            sourceX = 45,
            sourceY = 38,
            sourceWidth = 128,
            sourceHeight = 128
        },
        {
            -- 07
            x=1,
            y=75,
            width=50,
            height=50,

            sourceX = 43,
            sourceY = 36,
            sourceWidth = 128,
            sourceHeight = 128
        },
        {
            -- 08
            x=145,
            y=71,
            width=54,
            height=54,

            sourceX = 41,
            sourceY = 34,
            sourceWidth = 128,
            sourceHeight = 128
        },
        {
            -- 09
            x=239,
            y=69,
            width=58,
            height=56,

            sourceX = 39,
            sourceY = 33,
            sourceWidth = 128,
            sourceHeight = 128
        },
        {
            -- 010
            x=361,
            y=65,
            width=60,
            height=60,

            sourceX = 38,
            sourceY = 31,
            sourceWidth = 128,
            sourceHeight = 128
        },
        {
            -- 011
            x=353,
            y=1,
            width=64,
            height=62,

            sourceX = 36,
            sourceY = 30,
            sourceWidth = 128,
            sourceHeight = 128
        },
        {
            -- 012
            x=285,
            y=1,
            width=66,
            height=64,

            sourceX = 35,
            sourceY = 29,
            sourceWidth = 128,
            sourceHeight = 128
        },
        {
            -- 013
            x=215,
            y=1,
            width=68,
            height=66,

            sourceX = 34,
            sourceY = 28,
            sourceWidth = 128,
            sourceHeight = 128
        },
        {
            -- 014
            x=143,
            y=1,
            width=70,
            height=68,

            sourceX = 33,
            sourceY = 27,
            sourceWidth = 128,
            sourceHeight = 128
        },
        {
            -- 015
            x=69,
            y=1,
            width=72,
            height=70,

            sourceX = 32,
            sourceY = 25,
            sourceWidth = 128,
            sourceHeight = 128
        },
        {
            -- 016
            x=1,
            y=1,
            width=66,
            height=72,

            sourceX = 32,
            sourceY = 24,
            sourceWidth = 128,
            sourceHeight = 128
        },
        {
            -- 017
            x=299,
            y=67,
            width=60,
            height=58,

            sourceX = 35,
            sourceY = 35,
            sourceWidth = 128,
            sourceHeight = 128
        },
    },
    
    sheetContentWidth = 450,
    sheetContentHeight = 126
}

SheetInfo.frameIndex =
{

    ["01"] = 1,
    ["02"] = 2,
    ["03"] = 3,
    ["04"] = 4,
    ["05"] = 5,
    ["06"] = 6,
    ["07"] = 7,
    ["08"] = 8,
    ["09"] = 9,
    ["010"] = 10,
    ["011"] = 11,
    ["012"] = 12,
    ["013"] = 13,
    ["014"] = 14,
    ["015"] = 15,
    ["016"] = 16,
    ["017"] = 17,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
