Player = World:newRectangleCollider(300, 100, 40, 100, {collision_class="Player"})
Player:setFixedRotation(true)
Player.speed = 250
Player.animation = Animations.idle
Player.isMoving = false
Player.direction = 1
Player.onGround = true


function updatePlayer(dt)
    if Player.body then
        Colliders = World:queryRectangleArea(Player:getX() - 20, Player:getY() + 50, 40, 2, {"Platform"})

        if #Colliders > 0 then
            Player.onGround = true
        else
            Player.onGround = false
        end

        local px, py = Player:getPosition()
        if love.keyboard.isDown("d") then
            Player:setX(px + Player.speed * dt)
            Player.isMoving = true
            Player.direction = 1
        elseif love.keyboard.isDown("a") then
            Player:setX(px - Player.speed * dt)
            Player.isMoving = true
            Player.direction = -1
        else
            Player.isMoving = false
        end


        if Player.onGround then
            if Player.isMoving then
                Player.animation = Animations.run
            else
                Player.animation = Animations.idle
            end    
        else
            Player.animation = Animations.jump
        end


        if Player:enter("Danger") then
            Player:destroy()
        end
    end
    Player.animation:update(dt)
end

function drawPlayer()
    if Player.body then
        local px, py = Player:getPosition()
        Player.animation:draw(Sprites.playerSheet, px, py, nil, Player.direction * 0.25, 0.25, 130, 300)
    end
end