--game where eggs fall from top player clicks
--before hit the bottom
--game ends when egg hits bottom

function love.load()
  
-- Default states
eggClicked = false
eggSpeed = 200
score = 0

-- Set image sizes
setEggSize = 0.2
setPowerUpSize = 0.1


-- Load images for the game
  yoshiEgg = love.graphics.newImage("Yoshi_egg.png")
  backgroundImage = love.graphics.newImage("bg.jpg")
  powerUp = love.graphics.newImage("starPower.png")

-- Set the width and height of the eggs and power-ups based on the set size. Creating a variable saves us from having to type out the math every time we want to use it.
  eggW = yoshiEgg:getWidth() * setEggSize
  eggH = yoshiEgg:getHeight() * setEggSize
  
  powerUpW = powerUp:getWidth() * setPowerUpSize
  powerUpH = powerUp:getHeight() * setPowerUpSize


  -- Randomize drop locations for the eggs
  math.randomseed(os.time())
  math.random(); math.random(); math.random()
  startx = {
      math.random(0, love.graphics.getWidth() - eggW ), 
      math.random(0, love.graphics.getWidth() - eggW),  
      math.random(0, love.graphics.getWidth() - eggW),  
      math.random(0, love.graphics.getWidth() - eggW), 
      math.random(0, love.graphics.getWidth() - eggW)
  }

  starty = {
      0 - math.random(eggH, eggH * 2),
      0 - math.random(eggH, eggH * 2),
      0 - math.random(eggH, eggH * 2),
      0 - math.random(eggH, eggH * 2),
      0 - math.random(eggH, eggH * 2)
  }

  -- Set power up variables: visibility, position, and time between power up spawns
  powerUpClicked = false
  powerUpVisible = false
  powerUpX = 0
  powerUpY = 0
  powerUpTimer = 25
  powerUpLength = 5

  -- Randomly spawn a power up after a certain time
  function spawnPowerup()
      powerUpX = math.random(0, love.graphics.getWidth() - powerUpW)
      powerUpY = math.random(0, love.graphics.getHeight() - powerUpH)
      powerUpVisible = true
  end
end

-------------------------------------------------
--MOUSE PRESS
--1 = left, 2 = right, 3 = middle wheel
-------------------------------------------------
function love.mousepressed(x, y, button, istouch)
    if button == 1 then

        -- check if the power up is clicked
        if powerUpVisible then
            if x >= powerUpX and x <= powerUpX + powerUpW
            and y >= powerUpY and y <= powerUpY + powerUpH then
                
                powerUpVisible = false
                powerUpTimer = 0

                powerUpClicked = true
                powerUpLength = 5   -- reset duration

                eggSpeed = eggSpeed / 2   -- slow eggs by half
            end
        end

        -- check if any of the yoshi eggs are clicked
        for i, v in ipairs(startx) do
            if x >= startx[i] and x <= startx[i] + eggW
            and y >= starty[i] and y <= starty[i] + eggH then

                eggClicked = true
                starty[i] = math.random(eggH, eggH * 2) * -1
            end
        end
    end
end

-------------------------------------------------
--UPDATE
-------------------------------------------------
function love.update(dt)

      -- powerup timer
      if not powerUpVisible then
          powerUpTimer = powerUpTimer + dt
          if powerUpTimer >= 25 then
              spawnPowerup()
              powerUpTimer = 0
          end
      end

      --powerup duration timer
      if powerUpClicked then
        powerUpLength = powerUpLength - dt

        if powerUpLength <= 0 then
            powerUpClicked = false
            eggSpeed = 200   -- reset speed to normal
        end
      end


      -- update the position of the yoshi eggs
      for i, v in ipairs(starty) do

          --if yoshi egg hits the bottom of the screen, lua quits (we lose)
          if starty[i] + eggH >= love.graphics.getHeight() then
              love.event.quit()
          end

          --yoshi eggs move down 
          starty[i] = starty[i] + eggSpeed * dt
      end
      -- Score counter
      if eggClicked then
          score = score + 1
          eggClicked = false
  end
end
-------------------------------------------------
--DRAW
-------------------------------------------------
function love.draw()

  -- draw background image: image, x position, y position, rotation, x scale, y scale
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(backgroundImage, 0, 0, 0, 0.8, 0.8)

    --draw each yoshi egg at their respective x and y
    for i, v in ipairs(startx) do
      love.graphics.draw(yoshiEgg, startx[i], starty[i], 0, setEggSize, setEggSize)
    end

    -- draw power up if visible
    if powerUpVisible then
      love.graphics.draw(powerUp, powerUpX, powerUpY, 0, setPowerUpSize, setPowerUpSize)
    end

    -- draw score
    love.graphics.setFont(love.graphics.newFont(20))
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("Score: " .. score, 10, 10)

end
