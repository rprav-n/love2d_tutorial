
-- Variables
message = "Lua is awsome"
local num = 1

local output = num + 1
num = num + 1


-- If/Else Statments
local condition = 0
if condition > 0 then
    message = 1
elseif condition == 0 then
    message = 0
else
    message = -1
end

-- While Loop
local count = 1
while count < 5 do

    count = count + 1
end

-- For Loop
local pickle = 0
for i = 1, 3, 1 do -- 3 is included
    pickle = pickle + 1
end

-- Functions
local val = 0
local function increaseVal(by)
    val = val + by
end

increaseVal(10)
increaseVal(5)

function addOne(num)
    num = num +1
    return num
end

num = addOne(2)

-- Comments
-- Singel line
--[[
Multi
line
comment
]]

-- Local and Global Variables
test = 0 -- global

function foo()
    local n = 0
end

foo()

-- Tables - IMPORTANT: Index starts at 1
testScores = {95, 87, 98}

testScores[1] = 95
testScores[2] = 87
testScores[3] = 98

testScores = {}

table.insert(testScores, 100)
table.insert(testScores, 50)

testScores["math"] = 67

num = testScores["math"]

testScores = {95, 87, 98}
testScores.subject = "science"

myNum = 0
for i, s in ipairs(testScores) do
    myNum = myNum + s
end

s = 0

if s < 10 then
    s = s + 5
end

function love.draw()
    love.graphics.setFont(love.graphics.newFont(50))
    love.graphics.print(s)
end