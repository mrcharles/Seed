require "Base"
require "hump.vector"
require "spritemanager"
require "PaletteEffect"

LayeredSprite = Base:new()
LayeredSprite.position = vector(0, 0)
LayeredSprite.baseLayer = {}
LayeredSprite.topLayer = {}
LayeredSprite.effect = {}

function LayeredSprite:load(strData, strAnimation)
	self.baseLayer = spritemanager.createSprite()
	self.baseLayer.strData = strData
	self.baseLayer.animation = strAnimation
	self.baseLayer:setData(self.baseLayer.strData, self.baseLayer.animation, true)


	self.topLayer = spritemanager.createSprite()
	self.topLayer.strData = strData.."_cel"
	self.topLayer.animation = strAnimation.."_cel"
	self.topLayer:setData(self.topLayer.strData, self.topLayer.animation, true)
	self.topLayer.sprData.image:setFilter("linear", "linear")

	--self.effect = PaletteEffect:new()
	--self.effect:load("res/sprites/"..strData.."_palette.png")
end

function LayeredSprite:setPosition(pos)
	self.position = pos
end

function LayeredSprite:setAnimation(animation)
	self.baseLayer:setAnimation(animation, true)
	self.topLayer:setAnimation(animation.."_cel", true)
end

function LayeredSprite:update(dt)
	--LayeredSprite.effect:update(dt)

	self.baseLayer.x = self.position.x
	self.baseLayer.y = self.position.y

	self.topLayer.x = self.position.x
	self.topLayer.y = self.position.y

	self.baseLayer:update(dt)
	self.topLayer:update(dt)
end

function LayeredSprite:draw()
	--self.effect:setEffect()
	self.baseLayer:draw()
	--self.effect:clearEffect()
	self.topLayer:draw()
end
