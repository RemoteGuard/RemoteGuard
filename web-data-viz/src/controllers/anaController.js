var anaModel = require("../models/anaModel");
const moment = require('moment');

const processosIndevidos = [
    // # Jogos populares
    "fortnite.exe", "pubg.exe", "leagueoflegends.exe", "valorant.exe", "apex_legends.exe",
    "dota2.exe", "csgo.exe", "rocketleague.exe", "minecraft.exe", "roblox.exe",
    "callofduty.exe", "genshinimpact.exe", "overwatch.exe", "fifa.exe", "nba2k.exe",
    "wow.exe", "hearthstone.exe", "fallguys.exe", "rainbowsix.exe", "destiny2.exe",
    "borderlands3.exe", "seaofthieves.exe", "tombraider.exe", "skyrim.exe", "battlefield.exe",
    "cyberpunk2077.exe", "amongus.exe", "eldenring.exe", "horizon.exe", "spiderman.exe",
    "thewitcher3.exe", "godofwar.exe", "reddeadredemption.exe", "gta5.exe", "assassinscreed.exe",
    "monsterhunter.exe", "bloodborne.exe", "diablo3.exe", "starwarsbattlefront.exe", "ark_survival.exe",
    "rust.exe", "subnautica.exe", "forzahorizon.exe", "streetfighter.exe", "tekken.exe",
    "mortalkombat.exe", "nba2k23.exe", "nhl23.exe", "madden23.exe", "splatoon.exe",
    "simcity.exe", "cityskylines.exe", "civilization.exe", "anb_sandbox.exe", "flight_simulator.exe",
    "doom_eternal.exe", "halo_infinite.exe", "mario_kart.exe", "super_smash_bros.exe", "animal_crossing.exe",
    "final_fantasy.exe", "kingdom_hearts.exe", "dragonquest.exe", "elden_ring.exe", "scarlet_nexus.exe",
    "spiderman_milesmorales.exe", "milesmorales.exe", "shadow_of_war.exe", "farcry6.exe", "dying_light.exe",
    "tom_clancy.exe", "rainbow_six_siege.exe", "gears_of_war.exe", "age_of_empires.exe", "fable.exe",
    "skull_and_bones.exe", "dead_space.exe", "watch_dogs.exe", "need_for_speed.exe", "just_cause.exe",
    "payday2.exe", "witcher2.exe", "mortal_kombat11.exe", "ninja_gaiden.exe", "bayonetta.exe",
    "metal_gear_solid.exe", "nier_automata.exe", "devil_may_cry5.exe", "control.exe", "the_order_1886.exe",
    "ghost_recon.exe", "biomutant.exe", "outriders.exe", "watchdogs_legion.exe", "medal_of_honor.exe",
    "vampyr.exe", "l4d2.exe", "dying_light2.exe", "outriders.exe", "borderlands2.exe",
    "back_4_blood.exe", "left4dead.exe", "hellblade.exe", "alan_wake.exe", "outlast.exe",
    "dark_souls.exe", "nfs.exe", "trackmania.exe", "f1_2023.exe", "forza_motorsport.exe",
    // # Aplicativos de comunicação não corporativos
    "whatsapp.exe", "telegram.exe", "discord.exe", "slack.exe", "zoom.exe",
    "skype.exe", "wechat.exe", "messenger.exe", "line.exe", "viber.exe",
    // # Plataformas de streaming e entretenimento
    "netflix.exe", "spotify.exe", "twitch.exe", "primevideo.exe", "hulu.exe",
    "disneyplus.exe", "hbomax.exe", "youtube.exe", "vimeo.exe", "soundcloud.exe",
    // # Outros aplicativos de redes sociais e entretenimento
    "instagram.exe", "facebook.exe", "tiktok.exe", "snapchat.exe", "pinterest.exe",
    "twitter.exe", "reddit.exe", "tumblr.exe", "quora.exe", "wechat.exe",
    // # Jogos de cartas e casino
    "solitaire.exe", "pokerstars.exe", "bet365.exe", "bwin.exe", "casino.exe",
    "blackjack.exe", "slotgames.exe", "casinohalls.exe", "roulette.exe", "baccarat.exe",
    // # Processos de malwares comuns
    "coinminer.exe", "trojanagent.exe", "malwarebytes_fake.exe", "browser_hijacker.exe", "adware_popup.exe",
    "ransomware_lock.exe", "spyware_stealer.exe", "keylogger.exe", "rootkit_inject.exe", "worm_spread.exe",
    "backdoor_access.exe", "fakeflashplayer.exe", "cryptolocker.exe", "fakelogin.exe", "ads_plugin.exe",
    "malicious_popup.exe", "browser_spy.exe", "fake_antivirus.exe", "videoplayer.exe", "warning_alert.exe", "rstudio.exe"
]

function listarProcessos(req, res) {
    anaModel.listarProcessos()
        .then(function (resultado) {
            // Filtra os processos indevidos
            const processosFiltrados = resultado.filter(processo => processosIndevidos.includes(processo.processo));

            if (processosFiltrados.length > 0) {
                res.json(processosFiltrados);

            } else {
                res.status(404).json({ mensagem: "Nenhum processo indevido encontrado." });
            }
        })
        .catch(function (erro) {
            console.error("Erro ao buscar processos: ", erro);
            res.status(500).json({ erro: "Erro ao buscar processos no banco." });
        });
}


const obterDadosGraficoDias = (req, res) => {
    const processoEscolhido = req.params.selectProcesso;

    // Chamando o modelo para buscar os dados do banco
    anaModel.getDadosPorProcessoDias(processoEscolhido)
        .then(dados => {
            const labels = [];
            const datasets = [];

            dados.forEach(dado => {
                labels.push(dado.dia_semana);  
                datasets.push(dado.total_horas); 
            });

            res.json({
                labels: labels,  
                datasets: datasets  
            });
        })
        .catch(err => {
            res.status(500).json({ error: err.message });
        });
};

const obterDadosGraficoSemanas = (req, res) => {
    const processoEscolhido = req.params.selectProcesso;

    anaModel.getDadosPorProcessoSemanas(processoEscolhido)
        .then(dados => {
            const labels = [];
            const datasets = [];

            dados.forEach(dado => {

                labels.push(dado.semana); 
                datasets.push(dado.total_horas_semana);  
            });

            res.json({
                labels: labels, 
                datasets: datasets 
            });
        })
        .catch(err => {
            res.status(500).json({ error: err.message });
        });
};

const obterRankingMes = (req, res) => {
    const processoEscolhido = req.params.selectProcesso;  
    console.log('Processo escolhido:', processoEscolhido); 

    anaModel.getRankingMes(processoEscolhido)
        .then(dados => {
            console.log('Dados do ranking:', dados);  
            res.json(dados);  
        })
        .catch(err => {
            console.error('Erro ao obter dados do ranking:', err); 
            res.status(500).json({ error: err.message });
        });
};

const obterRankingSemana = (req, res) => {
    const processoEscolhido = req.params.selectProcesso; 
    console.log('Processo escolhido:', processoEscolhido); 

    anaModel.getRankingSemana(processoEscolhido)
        .then(dados => {
            console.log('Dados do ranking:', dados);  
            res.json(dados);  
        })
        .catch(err => {
            console.error('Erro ao obter dados do ranking:', err);  
            res.status(500).json({ error: err.message });
        });
};

function ObterTotalDias(req, res){
    const processoEscolhido = req.params.selectProcesso;  
    console.log('Processo escolhido semana:', processoEscolhido);  

    anaModel.totalHorasDias(processoEscolhido)
        .then(dados => {
            console.log('Dados do card:', dados);
            res.json(dados);
        })
        .catch(err => {
            console.error('Erro ao obter dados do ranking:', err); 
            res.status(500).json({ error: err.message });
        });
};

function ObterTotalMes(req, res){
    const processoEscolhido = req.params.selectProcesso; 
    console.log('Processo escolhido mes:', processoEscolhido);  
    anaModel.totalHorasMes(processoEscolhido)
        .then(dados => {
            console.log('Dados do card:', dados); 
            res.json(dados);  
        })
        .catch(err => {
            console.error('Erro ao obter dados do ranking:', err);  
            res.status(500).json({ error: err.message });
        });
};

function obterMaiorProcessoSemana(req, res){
    console.log("Cheguei no controller do Semanal")

    anaModel.obterMaiorProcessoSemana()
    .then(response => res.status(200).json(response))
    .catch(err => {
        console.log("Erro ao obter o processo semanal")
        res.status(500).json({erro: err.message})
    })
}

function obterMaiorProcessoMes(req, res){
    anaModel.obterMaiorProcessoMes()
    .then(response => res.status(200).json(response))
    .catch(err => res.status(500).json({erro: err.message}))
}


module.exports ={
    listarProcessos,
    obterDadosGraficoDias,
    obterDadosGraficoSemanas,
    obterRankingMes,
    obterRankingSemana,
    ObterTotalDias,
    ObterTotalMes,
    obterMaiorProcessoSemana,
    obterMaiorProcessoMes
};
