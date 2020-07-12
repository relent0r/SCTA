local BaseGenericDebris = import('/lua/sim/DefaultProjectiles.lua').BaseGenericDebris
local EffectTemplates = import('/lua/EffectTemplates.lua')

ARMWIN_debris01 = Class(BaseGenericDebris) {
    FxImpactLand = EffectTemplates.GenericDebrisLandImpact01,
    FxTrails = {
	'/mods/SCTA-master/effects/emitters/debris_smoke_emit.bp',
	'/mods/SCTA-master/effects/emitters/debrisfire_smoke_emit.bp',
    },
}

TypeClass = ARMWIN_debris01

