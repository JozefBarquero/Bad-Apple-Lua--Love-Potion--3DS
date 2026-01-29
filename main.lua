local currentFrame = 1
local fps = 3
local totalFrames = 972
local frameImage = nil
local drawX, drawY = 0, 0
local gcTimer = 0

local frameCounter = 0
local pauseForCleanup = false
local cleanupTimer = 0
local cleanupDelay = 0.4

local fpsTimer = 0
local fpsFrames = 0
local realFPS = 0

local music = nil
local lastDisplayedFrame = -1

function love.load()
is3DS = (love.system.getOS() == "3DS")
love.filesystem.mountFullPath("sdmc:/", "data", "read")

local ok, src = pcall(love.audio.newSource, "data/3ds/LovePotion/game/audio/final_bad_apple.wav", "stream")
if ok and src then
    music = src
    music:setLooping(false)
    music:play()
    end
    end

    local function loadFrame(n)
    local path = string.format("data/3ds/LovePotion/game/frames/frame_%04d.t3x", n)

    if frameImage then
        if frameImage.release then
            pcall(frameImage.release, frameImage)
            end
            frameImage = nil
            end

            local ok, img = pcall(love.graphics.newImage, path)
            if ok and img then
                frameImage = img
                drawX = (400 - frameImage:getWidth()) / 2
                drawY = (240 - frameImage:getHeight()) / 2
                end
                end

                function love.update(dt)
                fpsTimer = fpsTimer + dt
                fpsFrames = fpsFrames + 1
                if fpsTimer >= 1 then
                    realFPS = fpsFrames
                    fpsFrames = 0
                    fpsTimer = 0
                    end

                    if pauseForCleanup then
                        cleanupTimer = cleanupTimer + dt
                        if cleanupTimer >= cleanupDelay then
                            cleanupTimer = 0
                            pauseForCleanup = false
                            end
                            return
                            end

                            if music then
                                local t = music:tell()
                                local targetFrame = math.floor(t * fps) + 1

                                while targetFrame > totalFrames do
                                    targetFrame = targetFrame - totalFrames
                                    end

                                    if targetFrame ~= currentFrame then
                                        currentFrame = targetFrame

                                        if currentFrame ~= lastDisplayedFrame then
                                            loadFrame(currentFrame)
                                            lastDisplayedFrame = currentFrame

                                            frameCounter = frameCounter + 1
                                            if frameCounter >= 25 then
                                                frameCounter = 0
                                                pauseForCleanup = true

                                                if frameImage then
                                                    if frameImage.release then
                                                        pcall(frameImage.release, frameImage)
                                                        end
                                                        frameImage = nil
                                                        end

                                                        collectgarbage("collect")
                                                        collectgarbage("collect")
                                                        end
                                                        end
                                                        end
                                                        end

                                                        gcTimer = gcTimer + dt
                                                        if gcTimer >= 1.5 then
                                                            gcTimer = 0
                                                            collectgarbage("collect")
                                                            end
                                                            end

                                                            function love.draw(screen)
                                                            if screen == "bottom" then
                                                                local stats = love.graphics.getStats()
                                                                local luaKb = collectgarbage("count")

                                                                love.graphics.print("Debug  2DS/3DS LUA Bad Apple.", 10, 10)
                                                                love.graphics.print("Frame: #" .. currentFrame, 10, 30)
                                                                love.graphics.print("FPS Configurados: " .. fps, 10, 50)
                                                                love.graphics.print("Real FPS: " .. realFPS, 10, 70)
                                                                love.graphics.print(
                                                                    string.format("VRAM: %.1f KB", (stats.texturememory or 0) / 1024),
                                                                                    10,
                                                                                    110
                                                                )
                                                                love.graphics.print("Lua KB: " .. math.floor(luaKb), 10, 130)
                                                                love.graphics.print("Pausa Limpieza: " .. tostring(pauseForCleanup), 10, 150)
                                                                return
                                                                end

                                                                if frameImage then
                                                                    love.graphics.draw(frameImage, drawX, drawY)
                                                                    end
                                                                    end
