love.graphics.setDefaultFilter("nearest")
math.randomseed(os.time())

width = 1280
height = 720

kLeft = "left"
kRight = "right"
kJump = "up"

sSpawn = love.audio.newSource("sounds/spawn.ogg", "static")
sFail = love.audio.newSource("sounds/fail.ogg", "static")
sDeath = love.audio.newSource("sounds/death.ogg", "static")

iTitle = love.graphics.newImage("images/titlescreen.png")
iDeath = love.graphics.newImage("images/endscreen.png")

states = {}
states[1] = require "state.menu"
states[2] = require "state.game"
states[3] = require "state.end"
state = 1

function love.load()
	love.window.setMode(width, height)
	love.window.setTitle("LD42 - Running out of space")
end

function love.update(dt)
	states[state].update(dt)
end

function love.draw()
	states[state].draw()
end

function love.keypressed(key)
	states[state].keyevent(key)
end
