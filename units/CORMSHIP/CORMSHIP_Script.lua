#CORE Hydra - Missile Ship
#CORMSHIP
#
#Script created by Raevn

local TAunit = import('/mods/SCTA-master/lua/TAunit.lua').TAunit
local TARocket = import('/mods/SCTA-master/lua/TAweapon.lua').TARocket
local AAMWillOWisp = import('/lua/aeonweapons.lua').AAMWillOWisp

CORMSHIP = Class(TAunit) {
	OnCreate = function(self)
		TAunit.OnCreate(self)
		self.Spinners = {
			dish = CreateRotator(self, 'dish', 'y', nil, 0, 0, 0),
		}
		for k, v in self.Spinners do
			self.Trash:Add(v)
		end
		self.currentShot = 0
		self.Spinners.dish:SetSpeed(150)
	end,
	Weapons = {
		CORMSHIP_ROCKET = Class(TARocket) {
    			PlayFxRackReloadSequence = function(self)
				self.unit.currentShot = self.unit.currentShot + 1
				if self.unit.currentShot == 2 then
					self.unit:HideBone('rocket1', true)
					self.unit:HideBone('rocket2', true)
				elseif self.unit.currentShot == 4 then
					self.unit:HideBone('rocket1', true)
					self.unit:HideBone('rocket2', true)
					self.unit:HideBone('rocket3', true)
					self.unit:HideBone('rocket4', true)
				elseif self.unit.currentShot == 6 then
					self.unit:HideBone('rocket1', true)
					self.unit:HideBone('rocket2', true)
					self.unit:HideBone('rocket3', true)
					self.unit:HideBone('rocket4', true)
					self.unit:HideBone('rocket5', true)
					self.unit:HideBone('rocket6', true)
					WaitSeconds(0.6)
					self.unit.currentShot = 0
				end	
				TARocket.PlayFxRackReloadSequence(self)
			end,

			PlayFxWeaponUnpackSequence = function(self)
				self.unit:ShowBone('rocket1', true)
				self.unit:ShowBone('rocket2', true)
				self.unit:ShowBone('rocket3', true)
				self.unit:ShowBone('rocket4', true)
				self.unit:ShowBone('rocket5', true)
				self.unit:ShowBone('rocket6', true)
				TARocket.PlayFxWeaponUnpackSequence(self)
			end,	

			PlayFxWeaponPackSequence = function(self)
				WaitSeconds(0.5)
				TARocket.PlayFxWeaponPackSequence(self)
			end,	
		},
		CORSHIP_MISSILE = Class(AAMWillOWisp) {},
	},
}

TypeClass = CORMSHIP
