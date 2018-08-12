s = {}

player = {}
player.x = 0
player.y = 480
player.w = 60
player.h = 120
player.speedx = 0
player.speedy = 0
player.onground = true

drawX = (width - player.w) / 2

ground = 600
ceiling = 0
ceilingSpeed = 20

spawn = 0
nextSpawn = 3000

holes = {}
holes[1] = {x = 600, w = 200}

function addHole()
	table.insert(holes, {x = holes[#holes].x + holes[#holes].w + math.random(200, 400), w = math.random(100, 300)})
end

for n = 1, 100 do
	addHole()
end

function s.update(dt)
	player.speedy = player.speedy + 60

	if love.keyboard.isDown(kLeft) then
		player.speedx = -500
	elseif love.keyboard.isDown(kRight) then
		player.speedx = 500
	else
		player.speedx = 0
	end

	if love.keyboard.isDown(kJump) and player.onground then
		player.speedy = -1000
		player.onground = false
	end

	player.x = player.x + player.speedx * dt
	player.y = player.y + player.speedy * dt
	ceiling = ceiling + ceilingSpeed * dt

	if player.y + player.h > ground then
		player.y = ground - player.h
		player.speedy = 0
		player.onground = true
	end

	if player.onground then
		for _,h in pairs(holes) do
			if player.x >= h.x and player.x + player.w <= h.x + h.w then
				player.x = spawn
				player.y = 400
				sFail:play()
			end
		end
	end

	if player.y < ceiling then
		if player.onground then
			sDeath:play()
			player.x = 0
			player.y = 480
			player.speedx = 0
			player.speedy = 0
			local first = holes[1]
			holes = {}
			holes[1] = first
			for n = 1, 100 do
				addHole()
			end
			ceiling = 0
			state = 3
		else
			player.speedy = 0
			player.y = ceiling
		end
	end

	if player.x < 0 then
		player.x = 0
	elseif player.x > nextSpawn then
		spawn = nextSpawn
		nextSpawn = nextSpawn + 3000
		ceiling = ceiling - 100
		if ceiling < 0 then
			ceiling = 0
		end
		for n = 1, 50 do
			addHole()
		end
		sSpawn:play()
	end

end

function s.draw()
	--background
	love.graphics.setColor(120, 100, 90)
	love.graphics.rectangle("fill", 0, 0, width, height)
	--ground
	love.graphics.setColor(75, 65, 60)
	love.graphics.rectangle("fill", 0, ground, width, height - ground)
	--spawn
	love.graphics.setColor(120, 180, 90)
	love.graphics.rectangle("fill", nextSpawn - player.x + drawX, 0, 160, ground)
	--ceiling
	love.graphics.setColor(60, 60, 60)
	love.graphics.rectangle("fill", 0, 0, width, ceiling)
	--holes
	love.graphics.setColor(240, 40, 0)
	for _,h in pairs(holes) do
		if h.x + h.w - player.x + drawX > 0 then
			if h.x - player.x + drawX > width then
				break
			end
			love.graphics.rectangle("fill", h.x - player.x + drawX, ground, h.w, height - ground)
		end
	end
	--player
	love.graphics.setColor(255, 255, 255)
	love.graphics.rectangle("fill", drawX, player.y, player.w, player.h)
end

function s.keyevent(key)
end

return s
