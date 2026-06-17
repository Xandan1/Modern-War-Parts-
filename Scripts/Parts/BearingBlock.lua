BearingBlock = class()

BearingBlock.connectionInput = sm.interactable.connectionType.logic
BearingBlock.connectionOutput = sm.interactable.connectionType.bearing
BearingBlock.maxParentCount = 1
BearingBlock.maxChildCount = 5
BearingBlock.colorNormal = sm.color.new( "046e19" )
BearingBlock.colorHighlight = sm.color.new( "098723" )

function BearingBlock:server_onCreate()
    print("Hello from AlHiMiK :)")
    self.interactable:setActive(false)
end

function BearingBlock:server_onFixedUpdate(timeStep)
	local parents = self.interactable:getParents()
    local bearings = self.interactable:getBearings()

	if #parents>0 then
		for id, parent in pairs(parents) do
			if parent:isActive() then
                for id, bearing in pairs(bearings) do
                    bearing:setTargetAngle(0, 1 , 100000)
                end
            else
                for id, bearing in pairs(bearings) do
                    bearing:setTargetAngle(0, 0 , 0)
                end
            end
		end
	end
end
