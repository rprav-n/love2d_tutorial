function love.load()
    Target = {}
    Target.x = 300
    Target.y = 300
    Target.radius = 50

    Score = 0
    Timer = 0
    Countdown = 0

    GameFont = love.graphics.newFont(40)

    Sprites = {}
    Sprites.sky = love.graphics.newImage("sprites/sky.png")
    Sprites.target = love.graphics.newImage("sprites/target.png")
    Sprites.crosshairs = love.graphics.newImage("sprites/crosshairs.png")

    love.mouse.setVisible(false)

    GameState = 1

end

function love.update(dt)
    Countdown = Countdown + dt
    if Countdown >= 1 then
        if Timer > 0 and GameState == 2 then
            Timer = Timer - 1
        end
        Countdown = 0
    end
    if Timer <= 0 then
        GameState = 1
        Timer = 0
    end
    
end

function love.draw()

    love.graphics.setFont(GameFont)
    love.graphics.setColor(1, 1, 1)

    -- Sky
    love.graphics.draw(Sprites.sky, 0, 0)
    
    -- Target
    if GameState == 2 then
        love.graphics.draw(Sprites.target, Target.x, Target.y, 0, 1, 1, Target.radius, Target.radius)    
    end
    
    -- Crosshair
    love.graphics.draw(Sprites.crosshairs, love.mouse.getX(), love.mouse.getY(), 0, 1, 1, 20, 20)

    -- Score
    love.graphics.print("Score: " .. Score, 5, 5)

    -- Timer
    love.graphics.printf("Time: "..Timer, 0, 5, love.graphics.getWidth(), "center")

    if GameState == 1 then
        love.graphics.printf("Click anywhere to begin!", 0, 250, love.graphics.getWidth(), "center")
    end
    

end

function love.mousepressed( x, y, button, istouch, presses)
    if button == 1 and GameState == 2 then
        local mouseToTarget = distanceBetween(x, y, Target.x, Target.y)
        if mouseToTarget <= Target.radius then
            Score = Score + 1
            Target.x = math.random(Target.radius, love.graphics.getWidth() - Target.radius)
            Target.y = math.random(Target.radius, love.graphics.getHeight() - Target.radius)
        end
    elseif button == 1 and GameState == 1 then
        GameState = 2
        Countdown = 0
        Timer = 10
        Score = 0
    end
end

function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2-x1)^2 + (y2-y1)^2)
end
