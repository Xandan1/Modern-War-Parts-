Taran = class()
function Taran.server_onCollision(self, other, position, selfPointVelocity, otherPointVelocity, normal)
	local sum = math.floor((selfPointVelocity:length()) + 2)
	if sum >= 3 then
		sm.physics.explode(position, 1, 0.8, 1, 0.1)
	end
end