function love.load()
    love.window.setTitle("Platformer")
    love.window.setMode(1000, 768)

    Wf = require 'libraries/windfield/windfield'
    Anim8 = require 'libraries/anim8/anim8'
    Sti = require 'libraries/Simple-Tiled-Implementation/sti'
    CameraFile = require 'libraries/hump/camera'

    Camera = CameraFile()

    Sprites = {}
    Sprites.playerSheet = love.graphics.newImage("sprites/playerSheet.png")

    local grid = Anim8.newGrid(614, 564, Sprites.playerSheet:getWidth(), Sprites.playerSheet:getHeight())

    Animations = {}
    Animations.idle = Anim8.newAnimation(grid("1-15", 1), 0.05)
    Animations.jump = Anim8.newAnimation(grid("1-7", 2), 0.05)
    Animations.run = Anim8.newAnimation(grid("1-15", 3), 0.05)

    World = Wf.newWorld(0, 1200, false)
    World:setQueryDebugDrawing(true)

    World:addCollisionClass("Platform")
    World:addCollisionClass("Player" --[[, {ignores = {"Platform"}}]])
    World:addCollisionClass("Danger")

    require("player")

    -- Danger = World:newRectangleCollider(0, 550, 800, 50, {collision_class="Danger"})
    -- Danger:setType("static")

    Platforms = {}

    loadMap()
end

function love.update(dt)
    GameMap:update(dt)
    updatePlayer(dt)
    World:update(dt)

    if Player.body then
        local px, py = Player:getPosition()
        Camera:lookAt(px, love.graphics.getHeight()/2)
    end
    
end

function love.draw()
    Camera:attach()
        love.graphics.setBackgroundColor(53/255, 81/255, 92/255)
        GameMap:drawLayer(GameMap.layers["Tile Layer 1"])
        drawPlayer()
        World:draw()
    Camera:detach()
end

function love.keypressed(key)
    if key == "w" then
        if #Colliders > 0 then
            Player.onGround = false
            Player:applyLinearImpulse(0, -5000)
        end
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        local colliders = World:queryCircleArea(x, y, 100, {"Platform", "Danger"})
        for i, c in ipairs(colliders) do
            c:destroy()
        end
    end
end

function spawnPlatform(x, y, w, h)
    if w > 0 and h > 0  then
        local platform = World:newRectangleCollider(x, y, w, h, {collision_class="Platform"})
        platform:setType("static")
        table.insert(Platforms, platform)
    end

end

function loadMap()
    GameMap = Sti('maps/level1.lua')
    for i, obj in pairs(GameMap.layers["Platforms"].objects) do
        spawnPlatform(obj.x, obj.y, obj.width, obj.height)
    end
end
