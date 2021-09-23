WARN('['..string.gsub(debug.getinfo(1).source, ".*\\(.*.lua)", "%1")..', line:'..debug.getinfo(1).currentline..'] * SCTAAI: offset FactoryBuilderManager.lua' )
local Traffic = (categories.MOBILE - categories.EXPERIMENTAL - categories.AIR - categories.CONSTRUCTION)
local TAEco = import('/mods/SCTA-master/lua/AI/TAEditors/TAAIInstantConditions.lua').GreaterTAStorageRatio

SCTAFactoryBuilderManager = FactoryBuilderManager
FactoryBuilderManager = Class(SCTAFactoryBuilderManager) {
    Create = function(self, brain, lType, location, radius, useCenterPoint)
        if not brain.SCTAAI then
            return SCTAFactoryBuilderManager.Create(self, brain, lType, location, radius, useCenterPoint)
        end
		BuilderManager.Create(self, brain)
        if not lType or not location or not radius then
            error('*FACTORY BUILDER MANAGER ERROR: Invalid parameters; requires locationType, location, and radius')
            return false
        end
        --LOG('IEXISTFACT')
        local builderTypes = {'Air', 'KBot', 'Vehicle', 'Hover', 'Sea', 'Seaplane', 'Gate', }
        for _,v in builderTypes do
			self:AddBuilderType(v)
		end
        --LOG('SCTAExist', brain.Rally)
        self.Location = location
        --LOG('*Location', self.Location)
        self.Radius = radius
        self.LocationType = lType
        --LOG('*Location', self.LocationType)
        self.RallyPoint = false

        self.FactoryList = {}

        self.LocationActive = false

        self.RandomSamePriority = true
        self.PlatoonListEmpty = true
	end,

    AddBuilder = function(self, builderData, locationType)
        if not self.Brain.SCTAAI then
            return SCTAFactoryBuilderManager.AddBuilder(self, builderData, locationType)
        end
        ---testremoving for/end looops in this builder now testingto confirm in log
        ----testconfirmed suspicisions initial, thanks to Sprouto now onto Engineers
        local newBuilder = Builder.CreateFactoryBuilder(self.Brain, builderData, locationType)
        if newBuilder:GetBuilderType() == 'All' then
            for k,v in self.BuilderData do
                self:AddInstancedBuilder(newBuilder, k)
            end
        elseif newBuilder:GetBuilderType() == 'Land' then
            --for __,v in self.BuilderData do
                self:AddInstancedBuilder(newBuilder, 'KBot')
                self:AddInstancedBuilder(newBuilder, 'Vehicle')
            --end
        elseif newBuilder:GetBuilderType() == 'SpecHover' then
            --for __,v in self.BuilderData do
                self:AddInstancedBuilder(newBuilder, 'KBot')
                self:AddInstancedBuilder(newBuilder, 'Vehicle')
                self:AddInstancedBuilder(newBuilder, 'Hover')
                self:AddInstancedBuilder(newBuilder, 'Sea')
            --end
        elseif newBuilder:GetBuilderType() == 'SpecAir' then
            --for __,v in self.BuilderData do
                self:AddInstancedBuilder(newBuilder, 'Air')
                self:AddInstancedBuilder(newBuilder, 'Seaplane')
            --end
        elseif newBuilder:GetBuilderType() == 'Field' then
            --for __,v in self.BuilderData do
                self:AddInstancedBuilder(newBuilder, 'KBot')
                self:AddInstancedBuilder(newBuilder, 'Vehicle')
                self:AddInstancedBuilder(newBuilder, 'Air')
            --end
        else
            self:AddInstancedBuilder(newBuilder)
        end
        return newBuilder
    end,

    GetFactoryFaction = function(self, factory)
            if not self.Brain.SCTAAI then
                return SCTAFactoryBuilderManager.GetFactoryFaction(self, factory)
            end
            if EntityCategoryContains(categories.ARM, factory) then
                return 'Arm'
            elseif EntityCategoryContains(categories.CORE, factory) then
                return 'Core'
            end
            return false
        end,

        AddFactory = function(self,unit)
            if not self.Brain.SCTAAI then
                return SCTAFactoryBuilderManager.AddFactory(self, unit)
            end
            if not self:FactoryAlreadyExists(unit) then
                table.insert(self.FactoryList, unit)
                if not EntityCategoryContains(categories.TECH1, unit) then
                    unit.DesiresAssist = true
                    if EntityCategoryContains(categories.TECH2, unit) then
                    unit.NumAssistees = 2
                    --LOG('SCTAT1EXIST', unit.DesiresAssist)
                    elseif EntityCategoryContains(categories.TECH3, unit) then
                    unit.NumAssistees = 4
                    --LOG('SCTAT2EXIST', unit.DesiresAssist)
                    else
                    unit.NumAssistees = 6
                    --LOG('SCTAT3EXIST', unit.DesiresAssist)
                    end
                end
              local bp = unit:GetBlueprint().Economy
               if EntityCategoryContains(categories.LAND, unit) then
                    if bp.KBot then
                    self:SetupTANewFactory(unit, 'KBot')
                    elseif bp.Vehicle then
                    self:SetupTANewFactory(unit, 'Vehicle')
                    else
                    self:SetupTANewFactory(unit, 'Hover')
                    end
                elseif EntityCategoryContains(categories.AIR, unit) then
                    if bp.AirFactory then
                    self:SetupTANewFactory(unit, 'Air')
                    else
                    self:SetupTANewFactory(unit, 'Seaplane')
                    end
                elseif bp.NavalFactory then
                    self:SetupTANewFactory(unit, 'Sea')
                else
                    --_ALERT('TABrainFactory', bp.Gantry)
                    self:SetupTANewFactory(unit, 'Gate')
                end
                self.LocationActive = true
            end
        end,

        SetupTANewFactory = function(self,unit,bType)
            self:SetupFactoryCallbacks({unit}, bType)
            self:ForkThread(self.DelayTARallyPoint, unit)
        end,

        GetNumCategoryBeingBuilt = function(self, category, facCategory)
            if not self.Brain.SCTAAI then
                return SCTAFactoryBuilderManager.GetNumCategoryBeingBuilt(self, category, facCategory)
            end
            return table.getn(self:TAGetFactoriesBuildingCategory(category, facCategory))
        end,

        TAGetFactoriesBuildingCategory = function(self, category, facCategory)
            local units = {}
            for k,v in EntityCategoryFilterDown(facCategory, self.FactoryList) do
                    if not (v.Dead or v.UnitBeingBuilt.Dead) and v:IsUnitState('Building') and EntityCategoryContains(category, v.UnitBeingBuilt) then
                    table.insert(units, v)
                    end
                end
                return units
        end,
    
        TAGetFactoriesWantingAssistance = function(self, category, facCatgory)
            local testUnits = self:TAGetFactoriesBuildingCategory(category, facCatgory)
    
            local retUnits = {}
            for k,v in testUnits do
                if v.DesiresAssist and v.NumAssistees and not table.getn(v:GetGuards()) >= v.NumAssistees then
                table.insert(retUnits, v)
                end
            end
            return retUnits
        end,
        
        DelayTARallyPoint = function(self, factory)
            --WaitSeconds(1)
            coroutine.yield(11)
            if not factory.Dead then
                self:SetTARallyPoint(factory)
            end
        end,

----InitialVersion Below From LOUD
        SetTARallyPoint = function(self, factory)
            WaitTicks(20)	  
            if not factory.Dead then
                local position = factory:GetPosition()     
                local rally = false           
                local rallyType = 'Rally Point'            
                if factory:GetBlueprint().Economy.NavalFactory then
                    rallyType = 'Naval Rally Point'
                end
                rally = AIUtils.AIGetClosestMarkerLocation(self, rallyType, position[1], position[3])   
                if not rally or VDist3( rally, position ) > 100 then
                    position = import('/mods/SCTA-master/lua/AI/TAEditors/TAAIInstantConditions.lua').TARandomLocation(position[1],position[3])
                    rally = position
                end           
                --IssueClearFactoryCommands( {factory} )
                IssueFactoryRallyPoint({factory}, rally)         
                factory:ForkThread(self.TrafficControlTAThread, position, rally)
            end
        end,
    
        -- thread runs as long as the factory is alive and monitors the units at that
        -- factory rally point - ordering them into formation if they are not in a platoon
        -- this helps alleviate traffic issues and 'stuck' unit problems
        ---This function apparently never actually got ran 
        TrafficControlTAThread = function(factory, factoryposition, rally)      
            WaitTicks(30) 
            --LOG('SCTAIFACTORYEXIST')  
            local GetOwnUnitsAroundPoint = import('/lua/ai/aiutilities.lua').GetOwnUnitsAroundPoint     
            --local category = 
            local rallypoint = { rally[1],rally[2],rally[3] }
            local factorypoint = { factoryposition[1], factoryposition[2], factoryposition[3] }       
            local Direction = import('/mods/SCTA-master/lua/AI/TAEditors/TAAIInstantConditions.lua').TAGetDirectionInDegrees( rallypoint, factorypoint )
            if Direction < 45 then 
                Direction = 0		-- South        
            elseif Direction < 135 then   
                Direction = 90		-- East     
            elseif Direction < 225 then
                Direction = 180		-- North  
            else
                Direction = 270		-- West
            end
            local aiBrain = factory:GetAIBrain()            
            while true do         
                local unitlist = nil
                local units = nil           
                WaitTicks(120)
                units = GetOwnUnitsAroundPoint( aiBrain, Traffic, rallypoint, 16)                
                if table.getn(units) > aiBrain.TARally then             
                    local unitlist = {}
                    for _,unit in units do            
                        if unit:IsIdleState() then
                            --LOG('SCTAIFACTORYEXIST', aiBrain.SCTAAI)
                            table.insert( unitlist, unit )
                        end
                    end   
                    if table.getn(unitlist) > aiBrain.Rally then  
                        --LOG("*AI DEBUG "..aiBrain.Nickname.." TraffMgt of "..table.getn(unitlist).." at "..repr(rallypoint))
                        IssueClearCommands( unitlist )
                        IssueFormMove( unitlist, rallypoint, 'GrowthFormation', Direction )
                    end
                end
            end
        end,

        SetupFactoryCallbacks = function(self,factories,bType)
            if not self.Brain.SCTAAI then
                return SCTAFactoryBuilderManager.SetupFactoryCallbacks(self,factories,bType)
            end
            for k,v in factories do
                if not v.BuilderManagerData then
                    v.BuilderManagerData = { FactoryBuildManager = self, BuilderType = bType, }
    
                    local factoryDestroyed = function(v)
                                                -- Call function on builder manager; let it handle death of factory
                                                self:FactoryDestroyed(v)
                                            end
                    import('/lua/ScenarioTriggers.lua').CreateUnitDestroyedTrigger(factoryDestroyed, v)
                    local factoryWorkFinish = function(v, finishedUnit)
                                                -- Call function on builder manager; let it handle the finish of work
                                                self:FactoryFinishBuilding(v, finishedUnit)
                                            end
                    import('/lua/ScenarioTriggers.lua').CreateUnitBuiltTrigger(factoryWorkFinish, v, categories.ALLUNITS)
                end
                self:ForkThread(self.TADelayBuildOrder, v, bType)
            end
        end,

        TADelayBuildOrder = function(self,factory,bType, delay)
            local guards = factory:GetGuards()
            for k,v in guards do
                if not v.Dead and v.Escorting and TAEco(self.Brain, 0.5, 0.5) then
                    --LOG('SCTAIEXIST', v.unitID)
                        --IssueClearCommands({v})
                        IssueGuard({v}, factory)
                    else                    
                        v.AssigningTask = nil
                        v.Escorting = nil
                        self.Brain.BuilderManagers[self.LocationType].EngineerManager:AssignEngineerTask(v)
                end
            end
            if factory.DelayThread then
                return
            end
            factory.DelayThread = true
            if delay then
            WaitTicks(math.random(9,29))
            end
            coroutine.yield(2)
            factory.DelayThread = false
            if factory.Dead then
                return
            elseif factory:IsIdleState() then
                factory.TABuildingUnit = nil
            end
            self:TAAssignBuildOrder(factory,bType)
        end,

        FactoryDestroyed = function(self, factory)
            if not self.Brain.SCTAAI then
                return SCTAFactoryBuilderManager.FactoryDestroyed(self, factory)
            end
            local guards = factory:GetGuards()
            for k,v in guards do
                if not v.Dead and v.AssigningTask then
                    IssueClearCommands({v})
                    v.AssigningTask = nil
                    v.Escorting = nil
                    self.Brain.BuilderManagers[self.LocationType].EngineerManager:AssignEngineerTask(v)
                end
            end
            for k,v in self.FactoryList do
                if v == factory then
                    self.FactoryList[k] = nil
                end
            end
            for k,v in self.FactoryList do
                if not v.Dead then
                    return
                end
            end
            self.LocationActive = false
        end,

        FactoryFinishBuilding = function(self,factory,finishedUnit)
            if not self.Brain.SCTAAI then
                return SCTAFactoryBuilderManager.FactoryFinishBuilding(self,factory,finishedUnit)
            end
            if EntityCategoryContains(categories.ENGINEER, finishedUnit) then
                self.Brain.BuilderManagers[self.LocationType].EngineerManager:AddUnit(finishedUnit)
            elseif EntityCategoryContains(categories.FACTORY, finishedUnit) then
                self:AddFactory(finishedUnit)
            end
            factory.TAAIFactoryBuilding = nil
            local guards = factory:GetGuards()
            for k,v in guards do
                if not v.Dead and v.AssigningTask then
                    --IssueClearCommands({v})
                    v.AssigningTask = nil
                    v.Escorting = nil
                    self.Brain.BuilderManagers[self.LocationType].EngineerManager:AssignEngineerTask(v)
                end
            end
            self:TAAssignBuildOrder(factory, factory.BuilderManagerData.BuilderType)
        end,

        TAAssignBuildOrder = function(self,factory,bType)
            --LOG('*TAIEXIST3', factory.TABuildingUnit)
            if factory.Dead then
                return
            end
            if table.getn(factory:GetCommandQueue()) <= 1 and (factory.TAAIFactoryBuilding or factory.TABuildingUnit) then
                return self:ForkThread(self.TADelayBuildOrder, factory, bType, true)
            end
            local builder = self:GetHighestBuilder(bType,{factory})
            --LOG('*TAIEXIST2', factory)
                if builder and not (factory.TAAIFactoryBuilding or factory.TABuildingUnit) then
                ---LOG('*TAIEXIST3', factory)
                factory.TAAIFactoryBuilding = true
                --LOG('TAIEXIST', factory.DesiresAssist)
                local template = self:GetFactoryTemplate(builder:GetPlatoonTemplate(), factory)
                --LOG('*TAAI DEBUG: ARMY ', repr(self.Brain:GetArmyIndex()),': Factory Builder Manager Building - ',repr(builder.BuilderName))

                -- rename factory to actual build-platoon name
                    if self.Brain[ScenarioInfo.Options.AIPLatoonNameDebug] or ScenarioInfo.Options.AIPLatoonNameDebug == 'all' then
                    factory:SetCustomName(builder.BuilderName)
                    end

                --LOG('*Building', template)
                if factory.DesiresAssist and TAEco(self.Brain, 0.5, 0.5) then
                    local Escorts = self.Brain:GetUnitsAroundPoint((categories.ENGINEER * categories.LAND * categories.TECH1) + categories.FIELDENGINEER, factory:GetPosition(), 10, 'Ally') 
                    --return
                    --local Escort = table.remove(Escort, Escort.Escorting)
                    for i = 1, factory.NumAssistees do
                        for _,Escort in Escorts do
                        if Escort and Escort.SCTAAIBrain and (Escort:IsIdleState() or not (Escort.AssigningTask or Escort.Escorting)) then 
                            if Escort.PlatoonHandle and self.Brain:PlatoonExists(Escort.PlatoonHandle) then
                                Escort.PlatoonHandle:Stop()
                                Escort.PlatoonHandle:TAPlatoonDisbandNoAssign()
                            end
                        Escort.AssigningTask = true
                        Escort.Escorting = true
                        
                        --LOG('TAIEXISTAssign', Escort.AssigningTask)
                        
                        ---local Assisting = self.Brain:AssignUnitsToPlatoon('SCTAAssisting', {Escort}, 'Guard', 'none')
                        ---break here to ensure only first LEGAL option is the one grabbed
                        IssueClearCommands({Escort})
                        IssueGuard({Escort}, factory) 
                        --IssueGuard({Escort}, factory)
                        break
                        --WaitSeconds(3)
                        --Escort.Escorting = nil
                        end
                        end
                    end
                end
                --local gaurds = factory:GetGuards()
                --LOG('TAIEXISTAssignGaurds', gaurds > 0)
                self.Brain:BuildPlatoon(template, {factory}, 1)
                --LOG('*TACanceling2', template)
                else
                    --LOG('*TAIEXIST4', factory.TABuildingUnit)
                -- rename factory
                if self.Brain[ScenarioInfo.Options.AIPLatoonNameDebug] or ScenarioInfo.Options.AIPLatoonNameDebug == 'all' then
                    if factory.PlatoonHandle.BuilderName then
                        factory:SetCustomName(factory.PlatoonHandle.BuilderName)
                    elseif factory:IsIdleState() then
                        factory:SetCustomName('')
                    end
                end
                -- No builder found setup way to check again
                self:ForkThread(self.TADelayBuildOrder, factory, bType, true)
                --LOG('*TACanceling1', factory)
            end
        end,
    }


--[[local position = factory:GetPosition()
local rally = false

if self.RallyPoint then
    IssueFactoryRallyPoint({factory}, self.RallyPoint)
    return true
end

local rallyType = 'Mass'
if EntityCategoryContains(categories.NAVAL, factory) then
    rallyType = 'Naval Area'
end

    -- use BuilderManager location
    rally = AIUtils.AIGetClosestMarkerLocation(self, rallyType, position[1], position[3])
    local expPoint = AIUtils.AIGetClosestMarkerLocation(self, 'Starting Location', position[1], position[3])

    if expPoint and rally then
        local rallyPointDistance = VDist2(position[1], position[3], rally[1], rally[3])
        local expansionDistance = VDist2(position[1], position[3], expPoint[1], expPoint[3])

        if expansionDistance < rallyPointDistance then
            rally = expPoint
        end
    end
end

-- Use factory location if no other rally or if rally point is far away
if not rally or VDist2(rally[1], rally[3], position[1], position[3]) > 75 then
    -- DUNCAN - added to try and vary the rally points.
    position = AIUtils.RandomLocation(position[1],position[3])
    rally = position
end
-- Use factory location if no other rally or if rally point is far away
IssueFactoryRallyPoint({factory}, rally)
self.RallyPoint = rally
return true
end,]]