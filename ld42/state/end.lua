s = {}

function s.update(dt)
end

function s.draw()
	love.graphics.draw(iDeath, 0, 0)
end

function s.keyevent(key)
	state = 2
end

return s
