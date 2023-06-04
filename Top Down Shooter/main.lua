function love.load()

    math.randomseed(os.time())

    love.window.setTitle("Top Down Shooter")

    Sprites = {}
    Sprites.background = love.graphics.newImage("sprites/background.png")
    Sprites.player = love.graphics.newImage("sprites/player.png")
    Sprites.bullet = love.graphics.newImage("sprites/bullet.png")
    Sprites.zombie = love.graphics.newImage("sprites/zombie.png")

    Player = {}
    Player.x = love.graphics.getWidth()/2
    Player.y = love.graphics.getHeight()/2
    Player.speed = 180

    Zombies = {}
    ZombieMaxTime = 2
    ZombieTimer = ZombieMaxTime
    ZombieCountDown = 0

    Bullets = {}
   
    GameState = 1
    Score = 0
    MyFont = love.graphics.newFont(30)

end

function love.update(dt)
    if GameState == 2 then
        local speed = Player.speed * dt
        if love.keyboard.isDown("d") and Player.x + Sprites.player:getWidth()/2 < love.graphics.getWidth() then
            Player.x = Player.x + speed
        end
        if love.keyboard.isDown("a") and Player.x - Sprites.player:getWidth()/2 > 0 then
            Player.x = Player.x - speed
        end
        if love.keyboard.isDown("w") and Player.y -  Sprites.player:getHeight()/2 > 0 then
            Player.y = Player.y - speed
        end
        if love.keyboard.isDown("s") and Player.y + Sprites.player:getHeight()/2 < love.graphics.getHeight() then
            Player.y = Player.y + speed
        end
    end

    if GameState == 2 then
        ZombieCountDown = ZombieCountDown + dt
        if ZombieCountDown >= ZombieMaxTime then
            ZombieTimer = ZombieTimer - 1
            if ZombieTimer <= 0 then
                spawnZombie()
                ZombieMaxTime = 0.95 * ZombieMaxTime
                if ZombieMaxTime <= 0.5 then
                    ZombieMaxTime = 0.5
                end
                ZombieTimer = ZombieMaxTime
            end
            ZombieCountDown = 0
        end
    end


    for i, z in ipairs(Zombies) do
        z.x = z.x + (math.cos(zombiePlayerAngle(z)) * z.speed * dt)
        z.y = z.y + (math.sin(zombiePlayerAngle(z)) * z.speed * dt)

        local d = distanbeBetween(z.x, z.y, Player.x, Player.y)

        if d < 30 then
            table.remove(Zombies, i)
            -- Reset game
            GameState = 1
            ZombieMaxTime = 2
            Score = 0
            Player.x = love.graphics.getWidth()/2
            Player.y = love.graphics.getHeight()/2
        end
    end

    for i, b in ipairs(Bullets) do
        b.x = b.x + (math.cos(b.direction) * b.speed * dt)
        b.y = b.y + (math.sin(b.direction) * b.speed * dt)
    end

    for i = #Bullets, 1, -1 do
        local b = Bullets[i]
        if b.x < 0 or b.x > love.graphics.getWidth() or b.y > love.graphics.getHeight() or b.y < 0 or b.dead then
            table.remove(Bullets, i)
        end
    end

    for i, z in ipairs(Zombies) do
        for j, b in ipairs(Bullets) do
            if distanbeBetween(z.x, z.y, b.x, b.y) < 20 then
                z.dead = true
                b.dead = true
                Score = Score + 1
            end
        end
    end

    for i = #Zombies, 1, -1 do
        local z = Zombies[i]
        if z.dead then
            table.remove(Zombies, i)
        end
    end

end

function love.draw(dt)
    -- Background
    love.graphics.draw(Sprites.background, 0, 0)

    if GameState == 1 then
        love.graphics.setFont(MyFont)
        love.graphics.printf("Click anywhere to begin!", 0, 50, love.graphics.getWidth(), "center")
    end

    love.graphics.printf("Score: " .. Score, 0, love.graphics.getHeight() - 50, love.graphics.getWidth(), "center")

    -- Bullets
    for i, b in ipairs(Bullets) do
        love.graphics.draw(Sprites.bullet, b.x, b.y, nil, 0.5, nil, Sprites.bullet:getWidth()/2, Sprites.bullet:getHeight()/2)
    end

    -- Player
    love.graphics.draw(Sprites.player, Player.x, Player.y, playerMouseAngle(), nil, nil, Sprites.player:getWidth()/2, Sprites.player:getHeight()/2)

    -- Zombies
    for _, z in ipairs(Zombies) do
        love.graphics.draw(Sprites.zombie, z.x, z.y, zombiePlayerAngle(z), nil, nil, Sprites.zombie:getWidth()/2, Sprites.zombie:getHeight()/2)
    end


    -- love.graphics.rectangle("line", Player.x - Sprites.player:getWidth()/2, Player.y - Sprites.player:getHeight()/2, Sprites.player:getWidth(), Sprites.player:getHeight())

    -- for i, z in ipairs(Zombies) do
    --     love.graphics.rectangle("line", z.x - Sprites.zombie:getWidth()/2, z.y - Sprites.zombie:getHeight()/2, Sprites.zombie:getWidth(), Sprites.zombie:getHeight())
    -- end

end

function love.mousepressed( x, y, button, istouch, presses )
    if button == 1 and GameState == 2 then
        spawnBullet()
    elseif button == 1 and GameState == 1 then
        GameState = 2
        ZombieMaxTime = 2
    end
    
end


function playerMouseAngle()
    return math.atan2(Player.y - love.mouse.getY(), Player.x - love.mouse.getX()) + math.pi
end

function zombiePlayerAngle(enemy)
    return math.atan2(Player.y - enemy.y, Player.x - enemy.x)
end

function spawnZombie()
    local zombie = {}
    local side = math.random(1, 4)
    if side == 1 then -- left
        zombie.x = -30
        zombie.y = math.random(0, love.graphics.getHeight())
    elseif side == 2 then -- right
        zombie.x = love.graphics.getWidth() + 30
        zombie.y = math.random(0, love.graphics.getHeight())
    elseif side == 2 then -- up
        zombie.x = math.random(0, love.graphics.getWidth())
        zombie.y = -30
    else -- bottom
        zombie.x = math.random(0, love.graphics.getWidth())
        zombie.y = love.graphics.getHeight() + 30
    end
    zombie.speed = 140
    zombie.dead = false
    table.insert(Zombies, zombie)
end

function spawnBullet()
    local bullet = {}
    bullet.x = Player.x
    bullet.y = Player.y
    bullet.speed = 400
    bullet.dead = false
    bullet.direction = playerMouseAngle()
    table.insert(Bullets, bullet)
end

function distanbeBetween(x1, y1, x2, y2)
    return math.sqrt((x1-x2)^2 + (y2-y1)^2)
end

