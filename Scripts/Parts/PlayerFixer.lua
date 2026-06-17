---@class PlayerFixer : ShapeClass
PlayerFixer = class()

local character
local fixDistance

function PlayerFixer:server_onCreate()
    self.fixDistance = self.data.distance
end

function PlayerFixer:client_onInteract(character, state)
    if state == true then
        self.network:sendToServer("sv_setCharacter", character)
    end
end

function PlayerFixer:sv_setCharacter(character)
    if sm.exists(self.character) then
        self.character = nil
    else
        self.character = character
    end
end

function PlayerFixer:server_onFixedUpdate(fixedStep)
    if sm.exists(self.character) then
        local position = self.shape.worldPosition + (self.shape.at * self.fixDistance)
        local force = position - self.character.worldPosition
        if force:length() >= 4 then
            self.character = nil
            return
        end
        force = force * 150
        sm.physics.applyImpulse(self.character, force, true)
    end
end