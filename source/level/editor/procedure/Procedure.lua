import "CoreLibs/object"

class("Procedure").extends()

function Procedure:init()
	Procedure.super.init(self)
end

function Procedure:update() end
function Procedure:draw() end
function Procedure:advance() end
function Procedure:back() end
function Procedure:finish() end
function Procedure:terminate() end
