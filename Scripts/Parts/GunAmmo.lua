---@class GunAmmo : ShapeClass
GunAmmo = class()

GunAmmo.connectionInput = sm.interactable.connectionType.logic
GunAmmo.connectionOutput = sm.interactable.connectionType.logic
GunAmmo.maxParentCount = 6
GunAmmo.maxChildCount = 10
GunAmmo.colorNormal = sm.color.new("096f94")
GunAmmo.colorHighlight = sm.color.new("0da8e0")

local Ammo
local MaxAmmo

function GunAmmo:server_onCreate()
    self:sv_init()
end

function GunAmmo:sv_init()
    self.sv = self.storage:load() or {
        Ammo = 0,
        MaxAmmo = 0
    }
    self.network:setClientData({Ammo = self.sv.Ammo, MaxAmmo = self.sv.MaxAmmo})
end

function GunAmmo:server_onFixedUpdate()
    local parents = self.interactable:getParents()
    self.interactable.active = self.sv.Ammo > 0

    if #parents>0 then
		for id, parent in pairs(parents) do
			if parent:isActive() then
                if parent.shape.color == sm.color.new("222222") then
                    self.sv.Ammo = sm.util.clamp((self.sv.Ammo - 1), 0, self.sv.MaxAmmo)
                else
                    self.sv.Ammo = sm.util.clamp((self.sv.Ammo + 1), 0, self.sv.MaxAmmo)
                end
                self.storage:save(self.sv)
                self.network:setClientData({Ammo = self.sv.Ammo})
			end
		end
	end
end

function GunAmmo:client_onCreate()
    self:cl_init()
    print("Hello from AlHiMiK :)")
end

function GunAmmo:cl_init()
    self.cl = {
        Ammo = 0,
        MaxAmmo = 0
    }
    local gui = sm.gui.createGuiFromLayout("$CONTENT_DATA/Gui/Layouts/GunAmmo.layout")
    gui:setTextChangedCallback("MaxAmmo", "cl_MaxAmmoChanged")
    self.cl.gui = gui
end

function GunAmmo:cl_MaxAmmoChanged(name, value)
    self.network:sendToServer("sv_ChangeMaxAmmo", value)
end

function GunAmmo:sv_ChangeMaxAmmo(value)
    self.sv.MaxAmmo = tonumber(value)
    self.storage:save(self.sv)
    self.network:setClientData({Ammo = self.sv.Ammo, MaxAmmo = self.sv.MaxAmmo})
end

function GunAmmo:client_onInteract(character, state)
    local gui = self.cl.gui

    if state then
        gui:open()
    end
end

function GunAmmo:client_onClientDataUpdate(data)
    for k, v in pairs(data) do
        self.cl[k] = v
    end
    self.cl.gui:setText("AmmoCount", tostring(self.cl.Ammo))
    self.cl.gui:setText("MaxAmmo", tostring(self.cl.MaxAmmo))
end
