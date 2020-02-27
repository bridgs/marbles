import "level/object/LevelObject"
import "physics/PhysCircle"
import "render/camera"
import "scene/time"
import "utility/math"

class("Booster").extends("LevelObject")

local image = playdate.graphics.image.new("images/booster.png")
local imageWidth, imageHeight = image:getSize()

function Booster:init(x, y, rotation)
	Booster.super.init(self, LevelObject.Type.Booster)
	self.physCircle = self:addPhysicsObject(PhysCircle(x, y, 10))
	self.cooldown = 0
	self.rotation = rotation
	local angle = drawableAngleToTrigAngle(self.rotation)
	self.launchX = math.cos(angle)
	self.launchY = math.sin(angle)
end

function Booster:update()
	self.cooldown = math.max(0, self.cooldown - time.dt)
end

function Booster:draw()
	local x, y = self:getPosition()
	x, y = camera.matrix:transformXY(x, y)
	local scale = camera.scale
	image:drawRotated(x, y, self.rotation - camera.rotation, scale)
end

function Booster:preCollide(other, collision)
	if self.cooldown <= 0 then
		self.cooldown = 0
		other:setVelocity(350 * self.launchX, 350 * self.launchY)
	end
	return false
end

function Booster:getEditableFields()
	return {
		{
			label = "Rotation",
			field = "rotation",
			increase = function()
				self.rotation += 15
				if self.rotation >= 360 then
					self.rotation -= 360
				end
			end,
			decrease = function()
				self.rotation -= 15
				if self.rotation < 0 then
					self.rotation += 360
				end
			end
		}
	}
end

function Booster:serialize()
	local data = Booster.super.serialize(self)
	data.rotation = self.rotation
	return data
end

function Booster.deserialize(data)
	return Booster(data.x, data.y, data.rotation)
end
