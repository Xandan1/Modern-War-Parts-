Machin_Gun_Ammo = class()

local ProjectileDamage
local HP

function Machin_Gun_Ammo:server_onCreate()
    self.HP = self.data.Health
    self.ProjectileDamage = self.data.ProjDamage
end

function Machin_Gun_Ammo:server_onProjectile()
    self:Damage(self.ProjectileDamage)
end

function Machin_Gun_Ammo:Damage(damage)
    self.HP = self.HP - damage
    if self.HP <= 0 then
        self.shape.destroyShape(self.shape, 0)
    end
end