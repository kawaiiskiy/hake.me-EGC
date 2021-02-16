local Huskar = {}
local optionEnable = Menu.AddOption({"kawaiiskiy", "Huskar"}, "Enable", "Auto-cast Inner Fire to kill range creep and harass the enemy if the enemy is in range")

function Huskar.CleanVar()
    myHero = nil
    myMana = nil
    myTeam = nil
    myPlayer = nil
end

function Huskar.Init()
    myHero = Heroes.GetLocal()
    myMana = NPC.GetMana(myHero)
    myTeam = Entity.GetTeamNum(myHero)
    myPlayer = Players.GetLocal()

    if NPC.GetUnitName(myHero) ~= "npc_dota_hero_huskar" then
        return
    end

    if not myHero then
        return
    end

    if not Menu.IsEnabled(optionEnable) then return end

end

function Huskar.OnGameStart()
    Huskar.CleanVar()
    Huskar.Init()
end

function Huskar.OnGameEnd()
    Huskar.CleanVar()
end

function Huskar.OnUpdate()
    if not Menu.IsEnabled(optionEnable) then return end
    myHero = Heroes.GetLocal()
    if NPC.GetUnitName(myHero) ~= "npc_dota_hero_huskar" then
        return
    end
    myMana = NPC.GetMana(myHero)
    myTeam = Entity.GetTeamNum(myHero)
    myPlayer = Players.GetLocal()
    q = NPC.GetAbilityByIndex(myHero, 0)
    q__damage = Ability.GetLevelSpecialValueFor(q, "damage")
    enemyTable = Entity.GetHeroesInRadius(myHero, 500, Enum.TeamType.TEAM_ENEMY) or {}
    creepTable = Entity.GetUnitsInRadius(myHero, 500, Enum.TeamType.TEAM_ENEMY) or {}
    Huskar.Haras()
end

function Huskar.Haras()

    for index, hero in pairs(enemyTable) do
        if not Entity.IsSameTeam(myHero, hero) and not NPC.IsIllusion(hero) and Entity.IsAlive(hero) then
            enemy = hero
        end
        for index, maybeCreep in pairs(creepTable) do
            if not Entity.IsSameTeam(myHero, maybeCreep) and (NPC.GetUnitName(maybeCreep) == "npc_dota_creep_goodguys_ranged" or NPC.GetUnitName(maybeCreep) == "npc_dota_creep_badguys_ranged") and Entity.IsAlive(maybeCreep) then
                creep = maybeCreep
            end

            if NPC.IsEntityInRange(myHero, enemy, 500) and NPC.IsEntityInRange(myHero, creep, 500) and q and enemy and creep and q__damage > Entity.GetHealth(creep) and Ability.IsCastable(q, myMana) then
                Ability.CastNoTarget(q)
            end

        end
    end

end


return Huskar
