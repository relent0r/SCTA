#****************************************************************************
#**
#**  File     :  /effects/Entities/UEFNukeEffect011/UEFNukeEffect01_script.lua
#**  Author(s):  Gordon Duclos
#**
#**  Summary  :  Nuclear explosion script
#**
#**  Copyright � 2005,2006 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local NullShell = import('/lua/sim/defaultprojectiles.lua').NullShell

TANukeEffect01 = Class(NullShell) {
    
    OnCreate = function(self)
		NullShell.OnCreate(self)
		self:ForkThread(self.EffectThread)
    end,
    
    EffectThread = function(self)
		local army = self:GetArmy()
		
		
		WaitSeconds(4)
		--coroutine.yield(40)
		CreateEmitterAtEntity(self, army, '/mods/SCTA-master/effects/emitters/EMPBOOM_emit.bp'):ScaleEmitter(10)

		self:SetVelocity(0,3,0)
    end,      
}

TypeClass = TANukeEffect01

