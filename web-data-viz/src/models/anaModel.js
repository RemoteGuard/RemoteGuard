const { PrepareStatementInfo } = require("mysql2");
var database = require("../database/config");

function listarProcessos() {
  var instrucaoSql = `SELECT processo, MAX(id) AS id FROM dadosAna GROUP BY processo ORDER BY id DESC;`
  return database.executar(instrucaoSql);
}

function getDadosPorProcessoDias(processoEscolhido) {
  const instrucaoSql = `
           SELECT 
    CASE 
        WHEN DAYOFWEEK(dt) = 2 THEN 'Segunda-feira'
        WHEN DAYOFWEEK(dt) = 3 THEN 'Terça-feira'
        WHEN DAYOFWEEK(dt) = 4 THEN 'Quarta-feira'
        WHEN DAYOFWEEK(dt) = 5 THEN 'Quinta-feira'
        WHEN DAYOFWEEK(dt) = 6 THEN 'Sexta-feira'
        ELSE 'Desconhecido'
    END AS dia_semana, 
    SEC_TO_TIME(SUM(intervalo_segundos)) AS total_horas
FROM (
    SELECT 
        dt,
        TIMESTAMPDIFF(SECOND, MIN(hora), MAX(hora)) AS intervalo_segundos
    FROM 
        dadosAna
    WHERE 
        dt BETWEEN CURDATE() - INTERVAL 6 DAY AND CURDATE() 
        AND DAYOFWEEK(dt) BETWEEN 2 AND 6  
        AND processo = '${processoEscolhido}' 
    GROUP BY 
        dt
) AS subquery
GROUP BY 
    dia_semana
ORDER BY 
    FIELD(dia_semana, 'Segunda-feira', 'Terça-feira', 'Quarta-feira', 'Quinta-feira', 'Sexta-feira');
`;
  return database.executar(instrucaoSql);
}

function getDadosPorProcessoSemanas(processoEscolhido) {
  const instrucaoSql = `
    SELECT 
    CONCAT('Semana ', WEEK(dt) - WEEK(DATE_SUB(dt, INTERVAL DAYOFMONTH(dt)-1 DAY)) + 1) AS semana, 
    SEC_TO_TIME(SUM(intervalo_segundos)) AS total_horas_semana 
    FROM (
    SELECT 
        fkFunc, 
        dt, 
        TIMESTAMPDIFF(SECOND, MIN(hora), MAX(hora)) AS intervalo_segundos
    FROM 
        dadosAna
    WHERE 
        MONTH(dt) = 11  
        AND DAYOFWEEK(dt) BETWEEN 2 AND 6 
        AND processo = '${processoEscolhido}'  
        AND hora IS NOT NULL  
    GROUP BY 
        fkFunc, 
        dt
    ) AS subquery
    GROUP BY 
    semana 
    ORDER BY 
    semana;
`;
  return database.executar(instrucaoSql);
}

function getRankingMes(processoEscolhido) {
  const instrucaoSql = `
    SELECT 
    f.nome AS nome_funcionario, 
    SEC_TO_TIME(SUM(intervalo_segundos)) AS total_horas  
    FROM (
    SELECT 
        fkFunc, 
        TIMESTAMPDIFF(SECOND, MIN(hora), MAX(hora)) AS intervalo_segundos
    FROM 
        dadosAna
    WHERE 
        MONTH(dt) = 11 
        AND DAYOFWEEK(dt) BETWEEN 2 AND 6 
        AND processo = '${processoEscolhido}' 
        AND hora IS NOT NULL 
    GROUP BY 
        fkFunc, 
        dt
    ) AS subquery
    JOIN 
    funcionario f ON subquery.fkFunc = f.idFuncionario 
    GROUP BY 
    f.nome 
    ORDER BY 
    total_horas DESC; 
`;
  return database.executar(instrucaoSql);
}

function getRankingSemana(processoEscolhido) {
  const instrucaoSql = `
       SELECT 
    f.nome AS nome_funcionario, 
    SEC_TO_TIME(SUM(intervalo_segundos)) AS total_horas
FROM (
    SELECT 
        fkFunc, 
        dt, 
        TIMESTAMPDIFF(SECOND, MIN(hora), MAX(hora)) AS intervalo_segundos
    FROM 
        dadosAna
    WHERE 
        dt BETWEEN CURDATE() - INTERVAL 6 DAY AND CURDATE()  
        AND processo = '${processoEscolhido }' 
        AND hora IS NOT NULL 
    GROUP BY 
        fkFunc, 
        dt
) AS subquery
JOIN 
    funcionario f ON subquery.fkFunc = f.idFuncionario
GROUP BY 
    f.nome
ORDER BY 
    total_horas DESC limit 5;
`;
  return database.executar(instrucaoSql);
}

function totalHorasDias(processoEscolhido) {
  const instrucaoSql = `
    SELECT 
    SEC_TO_TIME(SUM(intervalo_segundos)) AS total_horas
FROM (
    SELECT 
        TIMESTAMPDIFF(SECOND, MIN(hora), MAX(hora)) AS intervalo_segundos
    FROM 
        dadosAna
    WHERE 
        dt BETWEEN CURDATE() - INTERVAL 6 DAY AND CURDATE()
        AND processo = '${processoEscolhido}'
    GROUP BY 
        dt
) AS subquery;
`;
  return database.executar(instrucaoSql);
}

function totalHorasMes(processoEscolhido) {
  const instrucaoSql = `
    SELECT 
    SEC_TO_TIME(SUM(intervalo_segundos)) AS total_horas
FROM (
    SELECT 
        TIMESTAMPDIFF(SECOND, MIN(hora), MAX(hora)) AS intervalo_segundos
    FROM 
        dadosAna
    WHERE 
        YEAR(dt) = YEAR(CURDATE()) AND MONTH(dt) = MONTH(CURDATE())
        AND processo = '${processoEscolhido}'
    GROUP BY 
        dt
) AS subquery;
`;
  return database.executar(instrucaoSql);
}

function obterMaiorProcessoSemana(){
  var instrucaoSql = `
    SELECT processo
FROM dadosAna
WHERE dt BETWEEN CURDATE() - INTERVAL 6 DAY AND CURDATE()
AND processo IN (
    'fortnite.exe', 'pubg.exe', 'leagueoflegends.exe', 'valorant.exe', 'apex_legends.exe',
    'dota2.exe', 'csgo.exe', 'rocketleague.exe', 'minecraft.exe', 'roblox.exe',
    'callofduty.exe', 'genshinimpact.exe', 'overwatch.exe', 'fifa.exe', 'nba2k.exe',
    'wow.exe', 'hearthstone.exe', 'fallguys.exe', 'rainbowsix.exe', 'destiny2.exe',
    'borderlands3.exe', 'seaofthieves.exe', 'tombraider.exe', 'skyrim.exe', 'battlefield.exe',
    'cyberpunk2077.exe', 'amongus.exe', 'eldenring.exe', 'horizon.exe', 'spiderman.exe',
    'thewitcher3.exe', 'godofwar.exe', 'reddeadredemption.exe', 'gta5.exe', 'assassinscreed.exe',
    'monsterhunter.exe', 'bloodborne.exe', 'diablo3.exe', 'starwarsbattlefront.exe', 'ark_survival.exe',
    'rust.exe', 'subnautica.exe', 'forzahorizon.exe', 'streetfighter.exe', 'tekken.exe',
    'mortalkombat.exe', 'nba2k23.exe', 'nhl23.exe', 'madden23.exe', 'splatoon.exe',
    'simcity.exe', 'cityskylines.exe', 'civilization.exe', 'anb_sandbox.exe', 'flight_simulator.exe',
    'doom_eternal.exe', 'halo_infinite.exe', 'mario_kart.exe', 'super_smash_bros.exe', 'animal_crossing.exe',
    'final_fantasy.exe', 'kingdom_hearts.exe', 'dragonquest.exe', 'elden_ring.exe', 'scarlet_nexus.exe',
    'spiderman_milesmorales.exe', 'milesmorales.exe', 'shadow_of_war.exe', 'farcry6.exe', 'dying_light.exe',
    'tom_clancy.exe', 'rainbow_six_siege.exe', 'gears_of_war.exe', 'age_of_empires.exe', 'fable.exe',
    'skull_and_bones.exe', 'dead_space.exe', 'watch_dogs.exe', 'need_for_speed.exe', 'just_cause.exe',
    'payday2.exe', 'witcher2.exe', 'mortal_kombat11.exe', 'ninja_gaiden.exe', 'bayonetta.exe',
    'metal_gear_solid.exe', 'nier_automata.exe', 'devil_may_cry5.exe', 'control.exe', 'the_order_1886.exe',
    'ghost_recon.exe', 'biomutant.exe', 'outriders.exe', 'watchdogs_legion.exe', 'medal_of_honor.exe',
    'vampyr.exe', 'l4d2.exe', 'dying_light2.exe', 'outriders.exe', 'borderlands2.exe',
    'back_4_blood.exe', 'left4dead.exe', 'hellblade.exe', 'alan_wake.exe', 'outlast.exe',
    'dark_souls.exe', 'nfs.exe', 'trackmania.exe', 'f1_2023.exe', 'forza_motorsport.exe',
    'whatsapp.exe', 'telegram.exe', 'discord.exe', 'slack.exe', 'zoom.exe',
    'skype.exe', 'wechat.exe', 'messenger.exe', 'line.exe', 'viber.exe',
    'netflix.exe', 'spotify.exe', 'twitch.exe', 'primevideo.exe', 'hulu.exe',
    'disneyplus.exe', 'hbomax.exe', 'youtube.exe', 'vimeo.exe', 'soundcloud.exe',
    'instagram.exe', 'facebook.exe', 'tiktok.exe', 'snapchat.exe', 'pinterest.exe',
    'twitter.exe', 'reddit.exe', 'tumblr.exe', 'quora.exe', 'wechat.exe',
    'solitaire.exe', 'pokerstars.exe', 'bet365.exe', 'bwin.exe', 'casino.exe',
    'blackjack.exe', 'slotgames.exe', 'casinohalls.exe', 'roulette.exe', 'baccarat.exe',
    'coinminer.exe', 'trojanagent.exe', 'malwarebytes_fake.exe', 'browser_hijacker.exe', 'adware_popup.exe',
    'ransomware_lock.exe', 'spyware_stealer.exe', 'keylogger.exe', 'rootkit_inject.exe', 'worm_spread.exe',
    'backdoor_access.exe', 'fakeflashplayer.exe', 'cryptolocker.exe', 'fakelogin.exe', 'ads_plugin.exe',
    'malicious_popup.exe', 'browser_spy.exe', 'fake_antivirus.exe', 'videoplayer.exe', 'warning_alert.exe', 'rstudio.exe'
)
GROUP BY processo
ORDER BY COUNT(*) DESC
LIMIT 1;
  `

  return database.executar(instrucaoSql)
}

function obterMaiorProcessoMes(){
  var instrucaoSql = `
    SELECT processo
FROM dadosAna
WHERE YEAR(dt) = YEAR(CURDATE()) AND MONTH(dt) = MONTH(CURDATE())
AND processo IN (
    'fortnite.exe', 'pubg.exe', 'leagueoflegends.exe', 'valorant.exe', 'apex_legends.exe',
    'dota2.exe', 'csgo.exe', 'rocketleague.exe', 'minecraft.exe', 'roblox.exe',
    'callofduty.exe', 'genshinimpact.exe', 'overwatch.exe', 'fifa.exe', 'nba2k.exe',
    'wow.exe', 'hearthstone.exe', 'fallguys.exe', 'rainbowsix.exe', 'destiny2.exe',
    'borderlands3.exe', 'seaofthieves.exe', 'tombraider.exe', 'skyrim.exe', 'battlefield.exe',
    'cyberpunk2077.exe', 'amongus.exe', 'eldenring.exe', 'horizon.exe', 'spiderman.exe',
    'thewitcher3.exe', 'godofwar.exe', 'reddeadredemption.exe', 'gta5.exe', 'assassinscreed.exe',
    'monsterhunter.exe', 'bloodborne.exe', 'diablo3.exe', 'starwarsbattlefront.exe', 'ark_survival.exe',
    'rust.exe', 'subnautica.exe', 'forzahorizon.exe', 'streetfighter.exe', 'tekken.exe',
    'mortalkombat.exe', 'nba2k23.exe', 'nhl23.exe', 'madden23.exe', 'splatoon.exe',
    'simcity.exe', 'cityskylines.exe', 'civilization.exe', 'anb_sandbox.exe', 'flight_simulator.exe',
    'doom_eternal.exe', 'halo_infinite.exe', 'mario_kart.exe', 'super_smash_bros.exe', 'animal_crossing.exe',
    'final_fantasy.exe', 'kingdom_hearts.exe', 'dragonquest.exe', 'elden_ring.exe', 'scarlet_nexus.exe',
    'spiderman_milesmorales.exe', 'milesmorales.exe', 'shadow_of_war.exe', 'farcry6.exe', 'dying_light.exe',
    'tom_clancy.exe', 'rainbow_six_siege.exe', 'gears_of_war.exe', 'age_of_empires.exe', 'fable.exe',
    'skull_and_bones.exe', 'dead_space.exe', 'watch_dogs.exe', 'need_for_speed.exe', 'just_cause.exe',
    'payday2.exe', 'witcher2.exe', 'mortal_kombat11.exe', 'ninja_gaiden.exe', 'bayonetta.exe',
    'metal_gear_solid.exe', 'nier_automata.exe', 'devil_may_cry5.exe', 'control.exe', 'the_order_1886.exe',
    'ghost_recon.exe', 'biomutant.exe', 'outriders.exe', 'watchdogs_legion.exe', 'medal_of_honor.exe',
    'vampyr.exe', 'l4d2.exe', 'dying_light2.exe', 'outriders.exe', 'borderlands2.exe',
    'back_4_blood.exe', 'left4dead.exe', 'hellblade.exe', 'alan_wake.exe', 'outlast.exe',
    'dark_souls.exe', 'nfs.exe', 'trackmania.exe', 'f1_2023.exe', 'forza_motorsport.exe',
    'whatsapp.exe', 'telegram.exe', 'discord.exe', 'slack.exe', 'zoom.exe',
    'skype.exe', 'wechat.exe', 'messenger.exe', 'line.exe', 'viber.exe',
    'netflix.exe', 'spotify.exe', 'twitch.exe', 'primevideo.exe', 'hulu.exe',
    'disneyplus.exe', 'hbomax.exe', 'youtube.exe', 'vimeo.exe', 'soundcloud.exe',
    'instagram.exe', 'facebook.exe', 'tiktok.exe', 'snapchat.exe', 'pinterest.exe',
    'twitter.exe', 'reddit.exe', 'tumblr.exe', 'quora.exe', 'wechat.exe',
    'solitaire.exe', 'pokerstars.exe', 'bet365.exe', 'bwin.exe', 'casino.exe',
    'blackjack.exe', 'slotgames.exe', 'casinohalls.exe', 'roulette.exe', 'baccarat.exe',
    'coinminer.exe', 'trojanagent.exe', 'malwarebytes_fake.exe', 'browser_hijacker.exe', 'adware_popup.exe',
    'ransomware_lock.exe', 'spyware_stealer.exe', 'keylogger.exe', 'rootkit_inject.exe', 'worm_spread.exe',
    'backdoor_access.exe', 'fakeflashplayer.exe', 'cryptolocker.exe', 'fakelogin.exe', 'ads_plugin.exe',
    'malicious_popup.exe', 'browser_spy.exe', 'fake_antivirus.exe', 'videoplayer.exe', 'warning_alert.exe', 'rstudio.exe'
)
GROUP BY processo
ORDER BY COUNT(*) DESC
LIMIT 1;
  `

  return database.executar(instrucaoSql)
}


module.exports =
{
  listarProcessos,
  getDadosPorProcessoDias,
  getDadosPorProcessoSemanas,
  getRankingMes,
  getRankingSemana,
  totalHorasDias,
  totalHorasMes,
  obterMaiorProcessoSemana,
  obterMaiorProcessoMes
};
