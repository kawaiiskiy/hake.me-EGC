local Void = {}
local optionEnable = Menu.AddOption({"kawaiiskiy", "Void spirit"}, "Enable", "Auto-cast Resonant Pulse to kill range creep and harass the enemy if the enemy is in range")

function Void.CleanVar()
    myHero = nil
    myMana = nil
    myTeam = nil
    myPlayer = nil
end

function Void.Init()
    myHero = Heroes.GetLocal()
    myMana = NPC.GetMana(myHero)
    myTeam = Entity.GetTeamNum(myHero)
    myPlayer = Players.GetLocal()

    if NPC.GetUnitName(myHero) ~= "npc_dota_hero_void_spirit" then
        return
    end

    if not myHero then
        return
    end

    if not Menu.IsEnabled(optionEnable) then return end

end

function Void.OnGameStart()
    Void.CleanVar()
    Void.Init()
end

function Void.OnGameEnd()
    Void.CleanVar()
end

function Void.OnUpdate()
    if not Menu.IsEnabled(optionEnable) then return end
    myHero = Heroes.GetLocal()
    if NPC.GetUnitName(myHero) ~= "npc_dota_hero_void_spirit" then
        return
    end
    myMana = NPC.GetMana(myHero)
    myTeam = Entity.GetTeamNum(myHero)
    myPlayer = Players.GetLocal()
    e = NPC.GetAbilityByIndex(myHero, 2)
    e__damage = Ability.GetLevelSpecialValueFor(e, "damage")
    enemyTable = Entity.GetHeroesInRadius(myHero, 1200, Enum.TeamType.TEAM_ENEMY) or {}
    creepTable = Entity.GetUnitsInRadius(myHero, 1200, Enum.TeamType.TEAM_ENEMY) or {}
    Void.Haras()
end

function Void.Haras()

    for index, hero in pairs(enemyTable) do
        if not Entity.IsSameTeam(myHero, hero) and not NPC.IsIllusion(hero) and Entity.IsAlive(hero) then
            enemy = hero
        end
        for index, maybeCreep in pairs(creepTable) do
            if not Entity.IsSameTeam(myHero, maybeCreep) and (NPC.GetUnitName(maybeCreep) == "npc_dota_creep_goodguys_ranged" or NPC.GetUnitName(maybeCreep) == "npc_dota_creep_badguys_ranged") and Entity.IsAlive(maybeCreep) then
                creep = maybeCreep
            end

            if NPC.IsEntityInRange(myHero, enemy, 500) and NPC.IsEntityInRange(myHero, creep, 500) and e and enemy and creep and e__damage > Entity.GetHealth(creep) and Ability.IsCastable(e, myMana) then
                Ability.CastNoTarget(e)
            end

        end
    end

end


return Void
