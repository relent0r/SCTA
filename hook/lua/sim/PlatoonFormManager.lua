WARN('['..string.gsub(debug.getinfo(1).source, ".*\\(.*.lua)", "%1")..', line:'..debug.getinfo(1).currentline..'] * SCTAAI: offset PlatoonForm.lua' )
local TAPrior = import('/mods/SCTA-master/lua/AI/TAEditors/TAPriorityManager.lua')
SCTAPlatoonFormManager = PlatoonFormManager
PlatoonFormManager = Class(SCTAPlatoonFormManager) {
    Create = function(self, brain, lType, location, radius)
        if not brain.SCTAAI then
            --LOG('*self.template2', brain.SCTAAI)
            return SCTAPlatoonFormManager.Create(self, brain, lType, location, radius)
        end
        BuilderManager.Create(self,brain)
        --LOG('IEXIST2')
        if not lType or not location or not radius then
            error('*PLATOOM FORM MANAGER ERROR: Invalid parameters; requires locationType, location, and radius')
            return false
        end
        ---self.Terrain = self.ThreatType

        self.Location = location
        self.Radius = radius
        self.LocationType = lType
        --LOG('*TALocation', lType)
        if string.find(lType, 'Naval') then
        self.Naval = true
        --LOG('*TALocation3', self.LocationType)
        elseif lType == 'MAIN' then
        self.Main = true
        --LOG('*TALocation2', self.Main)
        end
        --LOG('*TATerrain', self.Naval)
        --LOG('*TATerrain2', self.Radius)
        --LOG('*TATerrain3', self.LocationType)
        local builderTypes = {'AirForm', 'LandForm', 'SeaForm', 'Scout', 'StructureForm', 'EngineerForm', 'CommandTA', 'Other'}
        for _,v in builderTypes do
			self:AddBuilderType(v)
		end
        self.BuilderCheckInterval = 5
    end,

   AddBuilder = function(self, builderData, locationType, builderType)
        if not self.Brain.SCTAAI then
            return SCTAPlatoonFormManager.AddBuilder(self, builderData, locationType, builderType)
        end
        local newBuilder = Builder.CreatePlatoonBuilder(self.Brain, builderData, locationType)
        if newBuilder:GetBuilderType() == 'Any' then
            for k,v in self.BuilderData do
                self:AddInstancedBuilder(newBuilder, k)
            end
        else
            self:AddInstancedBuilder(newBuilder)
        end
        return newBuilder
    end,

    ManagerLoopBody = function(self,builder,bType)
        if not self.Brain.SCTAAI then
            --LOG('*self.template3', self.Brain.SCTAAI)
            return SCTAPlatoonFormManager.ManagerLoopBody(self,builder,bType)
        end
        BuilderManager.ManagerLoopBody(self,builder,bType)
        local poolPlatoon = self.Brain:GetPlatoonUniquelyNamed('ArmyPool')
        local Sea = poolPlatoon:GetNumCategoryUnits(categories.NAVAL * categories.MOBILE)
        local Scout = poolPlatoon:GetNumCategoryUnits( categories.armpw + categories.corgator + ((categories.SCOUT + categories.AMPHIBIOUS) * categories.MOBILE) - categories.ENGINEER - categories.NAVAL)
        local Land = poolPlatoon:GetNumCategoryUnits(categories.LAND * categories.MOBILE - categories.ENGINEER - categories.SCOUT)
        local Air = poolPlatoon:GetNumCategoryUnits(categories.AIR * categories.MOBILE - categories.ENGINEER - categories.SCOUT)  
        local Engineer = poolPlatoon:GetNumCategoryUnits(categories.ENGINEER * categories.MOBILE - categories.COMMAND - categories.FIELDENGINEER - categories.SUBCOMMANDER)
        local Command = poolPlatoon:GetNumCategoryUnits(categories.COMMAND + categories.SUBCOMMANDER)
        local Other = poolPlatoon:GetNumCategoryUnits(categories.FIELDENGINEER + categories.EXPERIMENTAL)
        local Structure = poolPlatoon:GetNumCategoryUnits(categories.STRUCTURE + categories.CQUEMOV)

        if Sea > 1 and self.Naval then 
            self:SCTAManagerLoopBody(builder, 'SeaForm')
        elseif self.Main and bType == 'CommandTA' or bType == 'Scout' then
            if Command > 0 and TAPrior.UnitProduction >= 75 then 
               self:SCTAManagerLoopBody(builder, 'CommandTA') 
            elseif Scout > 0 and TAPrior.UnitProductionT1 >= 100 then 
               self:SCTAManagerLoopBody(builder, 'Scout')
            end
        elseif not self.Naval then 
            if Other > 0 and TAPrior.UnitProductionField >= 200 then 
                self:SCTAManagerLoopBody(builder, 'Other')
            elseif Scout > 0 and not self.Main then 
                self:SCTAManagerLoopBody(builder, 'Scout')
            elseif Engineer > 4 and TAPrior.UnitProduction >= 75 then 
                self:SCTAManagerLoopBody(builder, 'EngineerForm')
            elseif Structure > 1 and TAPrior.UnitProduction >= 75 then 
                self:SCTAManagerLoopBody(builder, 'StructureForm')
            elseif Land > 2 then 
                self:SCTAManagerLoopBody(builder, 'LandForm')    
            elseif Air > 0 then 
                self:SCTAManagerLoopBody(builder, 'AirForm') 
            end
        end
    end,
        
    ----return self:ForkThread(self.SCTAManagerLoopBody

    SCTAManagerLoopBody = function(self,builder,bType)
        --BuilderManager.ManagerLoopBody(self,builder,bType)
        if self.Brain.BuilderManagers[self.LocationType] and builder.Priority >= 1 and builder:CheckInstanceCount() then
                local personality = self.Brain:GetPersonality()
                local poolPlatoon = self.Brain:GetPlatoonUniquelyNamed('ArmyPool')
                local template = self:GetPlatoonTemplate(builder:GetPlatoonTemplate())
                builder:FormDebug()
                if bType == 'AirForm' or bType == 'StructureForm' then 
                    self.Radius = 1000
                elseif bType == 'LandForm' or bType == 'Scout' then 
                    self.Radius = 100 
                end
                local radius = self.Radius
                if builder:GetFormRadius() then radius = builder:GetFormRadius() end
            if not template or not self.Location or not radius then
                if type(template) != 'table' or type(template[1]) != 'string' or type(template[2]) != 'string' then
                    WARN('*Platoon Form: Could not find template named: ' .. builder:GetPlatoonTemplate())
                    return
                end
                WARN('*Platoon Form: Could not find template named: ' .. builder:GetPlatoonTemplate())
                return
            end
            local formIt = poolPlatoon:CanFormPlatoon(template, personality:GetPlatoonSize(), self.Location, radius)
            if formIt and builder:GetBuilderStatus() then
                local hndl = poolPlatoon:FormPlatoon(template, personality:GetPlatoonSize(), self.Location, radius)

                #LOG('*AI DEBUG: ARMY ', repr(self.Brain:GetArmyIndex()),': Platoon Form Manager Forming - ',repr(builder.BuilderName),': Location = ',self.LocationType)
                #LOG('*AI DEBUG: ARMY ', repr(self.Brain:GetArmyIndex()),': Platoon Form Manager - Platoon Size = ', table.getn(hndl:GetPlatoonUnits()))
                hndl.PlanName = template[2]
                if builder:GetPlatoonAIFunction() then
                    hndl:StopAI()
                    local aiFunc = builder:GetPlatoonAIFunction()
                    hndl:ForkAIThread(import(aiFunc[1])[aiFunc[2]])
                end
                if builder:GetPlatoonAIPlan() then
                    hndl.PlanName = builder:GetPlatoonAIPlan()
                    hndl:SetAIPlan(hndl.PlanName)
                end
                if builder:GetPlatoonAddPlans() then
                    for papk, papv in builder:GetPlatoonAddPlans() do
                        hndl:ForkThread(hndl[papv])
                    end
                end

                if builder:GetPlatoonAddFunctions() then
                    for pafk, pafv in builder:GetPlatoonAddFunctions() do
                        hndl:ForkThread(import(pafv[1])[pafv[2]])
                    end
                end

                if builder:GetPlatoonAddBehaviors() then
                    for pafk, pafv in builder:GetPlatoonAddBehaviors() do
                        hndl:ForkThread(import('/lua/ai/AIBehaviors.lua')[pafv])
                    end
                end

                hndl.Priority = builder.Priority
                hndl.BuilderName = builder.BuilderName

                hndl:SetPlatoonData(builder:GetBuilderData(self.LocationType))

                for k,v in hndl:GetPlatoonUnits() do
                    if not v.PlatoonPlanName then
                        v.PlatoonHandle = hndl
                    end
                end

                builder:StoreHandle(hndl)
            end
        end
    end,

}