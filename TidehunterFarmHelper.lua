local Tide = {}
local optionEnable = Menu.AddOption({"kawaiiskiy", "Tidehunter"}, "Enable", "Auto-cast Anchor Smash to kill range creep and harass the enemy if the enemy is in range")

function Tide.CleanVar()
    myHero = nil
    myMana = nil
    myTeam = nil
    myPlayer = nil
end

function Tide.Init()
    myHero = Heroes.GetLocal()
    myMana = NPC.GetMana(myHero)
    myTeam = Entity.GetTeamNum(myHero)
    myPlayer = Players.GetLocal()

    if NPC.GetUnitName(myHero) ~= "npc_dota_hero_tidehunter" then
        return
    end

    if not myHero then
        return
    end

    if not Menu.IsEnabled(optionEnable) then return end

end

function Tide.OnGameStart()
    Tide.CleanVar()
    Tide.Init()
end

function Tide.OnGameEnd()
    Tide.CleanVar()
end

function Tide.OnUpdate()
    if not Menu.IsEnabled(optionEnable) then return end
    myHero = Heroes.GetLocal()
    if NPC.GetUnitName(myHero) ~= "npc_dota_hero_tidehunter" then
        return
    end
    myMana = NPC.GetMana(myHero)
    myTeam = Entity.GetTeamNum(myHero)
    myPlayer = Players.GetLocal()
    e = NPC.GetAbilityByIndex(myHero, 2)
    e__damage = Ability.GetLevelSpecialValueFor(e, "attack_damage")
    enemyTable = Entity.GetHeroesInRadius(myHero, 375, Enum.TeamType.TEAM_ENEMY) or {}
    creepTable = Entity.GetUnitsInRadius(myHero, 375, Enum.TeamType.TEAM_ENEMY) or {}
    Tide.Haras()
end

function Tide.Haras()

    for index, hero in pairs(enemyTable) do
        if not Entity.IsSameTeam(myHero, hero) and not NPC.IsIllusion(hero) and Entity.IsAlive(hero) then
            enemy = hero
        end
        for index, maybeCreep in pairs(creepTable) do
            if not Entity.IsSameTeam(myHero, maybeCreep) and (NPC.GetUnitName(maybeCreep) == "npc_dota_creep_goodguys_ranged" or NPC.GetUnitName(maybeCreep) == "npc_dota_creep_badguys_ranged") and Entity.IsAlive(maybeCreep) then
                creep = maybeCreep
            end

            if NPC.IsEntityInRange(myHero, enemy, 375) and NPC.IsEntityInRange(myHero, creep, 375) and e and enemy and creep and e__damage > Entity.GetHealth(creep) and Ability.IsCastable(e, myMana) then
                Ability.CastNoTarget(e)
            end

        end
    end

end


return Tide
