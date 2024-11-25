import os
import socket
import time
import psutil
import json
import boto3
import datetime as dt
import pymysql
from mysql.connector import Error
from botocore.exceptions import ClientError
from atlassian import Jira
from requests import HTTPError

processos_indevidos = [
    # Jogos populares
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
    # Aplicativos de comunicação não corporativos
    "whatsapp.exe", "telegram.exe", "discord.exe", "slack.exe", "zoom.exe",
    "skype.exe", "wechat.exe", "messenger.exe", "line.exe", "viber.exe",
    # Plataformas de streaming e entretenimento
    "netflix.exe", "spotify.exe", "twitch.exe", "primevideo.exe", "hulu.exe",
    "disneyplus.exe", "hbomax.exe", "youtube.exe", "vimeo.exe", "soundcloud.exe",
    # Outros aplicativos de redes sociais e entretenimento
    "instagram.exe", "facebook.exe", "tiktok.exe", "snapchat.exe", "pinterest.exe",
    "twitter.exe", "reddit.exe", "tumblr.exe", "quora.exe", "wechat.exe",
    # Jogos de cartas e casino
    "solitaire.exe", "pokerstars.exe", "bet365.exe", "bwin.exe", "casino.exe",
    "blackjack.exe", "slotgames.exe", "casinohalls.exe", "roulette.exe", "baccarat.exe",
    # Processos de malwares comuns
    "coinminer.exe", "trojanagent.exe", "malwarebytes_fake.exe", "browser_hijacker.exe", "adware_popup.exe",
    "ransomware_lock.exe", "spyware_stealer.exe", "keylogger.exe", "rootkit_inject.exe", "worm_spread.exe",
    "backdoor_access.exe", "fakeflashplayer.exe", "cryptolocker.exe", "fakelogin.exe", "ads_plugin.exe",
    "malicious_popup.exe", "browser_spy.exe", "fake_antivirus.exe", "videoplayer.exe", "warning_alert.exe", "rstudio.exe"
]

def create_db_connection(): 
    try:
        conexao = pymysql.connect(
                host="localhost",
                user="root",
                password="cco@2024",
                database="remote_guard2"
            )
        cursor = conexao.cursor() 
        print(f"Conexão com o Banco {conexao.db.decode()} estabelecida com Sucesso!")
        return conexao, cursor
    except pymysql.MySQLError as e:
        print(f"Falha ao estabelecer Conexão com o Banco de Dados: {e}")
        return None, None

conexao, cursor = create_db_connection()



def get_hostname():
    return socket.gethostname()

def verify_equipment_registration():
    global fkNotebook
    hostname = get_hostname()
    
    sql = "SELECT idNotebook, hostname FROM notebook WHERE hostname = %s"
    cursor.execute(sql, (hostname,))
    register = cursor.fetchone()

    if register: 
        fkNotebook = register[0]
    else:
        sql = "INSERT INTO notebook (hostname) VALUES (%s)"
        cursor.execute(sql, (hostname))
        conexao.commit()
        fkNotebook = cursor.lastrowid
    
    return fkNotebook

verify_equipment_registration()

s3 = boto3.client('s3')
bucket_name = 'bucket-raw-rg'
file_key = f'/{get_hostname()}.json' 

def download_s3_json(bucket, key):
    print("----------------------------------------------------------------------------------------------------")
    print('Buscando Histórico de Dados...')
    
    try:
        s3.head_object(Bucket=bucket, Key=key)
        print('Histórico encontrado. Lendo Arquivo...')
        response = s3.get_object(Bucket=bucket_name, Key=file_key)
        dados = json.load(response['Body'])
        
    except ClientError:
        print('Nenhum Histórico encontrado. Criando novo Arquivo...')
        dados = []
    
    print("----------------------------------------------------------------------------------------------------")               
    return dados

bucket_name = 'bucket-raw-rg'
file_key = f'{get_hostname()}.json' 
json_file_path = f'/home/murillo/Downloads/{get_hostname()}.json'
dados = download_s3_json(bucket_name, file_key)

def get_root_directory():
    return 'C:\\' if os.name == 'nt' else '/'

def get_cpu_data():
    cpu_data = psutil.cpu_times()._asdict()
    cpu_idle_time = cpu_data['idle']
    cpu_usage_percentage = psutil.cpu_percent(interval = 1)
    return cpu_idle_time, cpu_usage_percentage

def get_ram_data():
    ram_data = psutil.virtual_memory()._asdict()
    ram_usage_bytes = ram_data['used']
    ram_usage_percentage = ram_data['percent']
    return ram_usage_bytes, ram_usage_percentage

def get_disk_data():
    disk_data = psutil.disk_usage(get_root_directory())._asdict()
    disk_usage_bytes = disk_data['used']
    disk_usage_percentage = disk_data['percent']
    total_disk_gb = round(disk_data['total'] / (1024**3), 2) # Convertendo bytes para GB
    return disk_usage_bytes, disk_usage_percentage, total_disk_gb

def get_process_count():
    process_count = sum(1 for _ in psutil.process_iter() if _.status() == 'running')
    return process_count

def get_cpu_cores():
    return psutil.cpu_count(logical=True)

def get_weighted_system_usage(cpu_usage, ram_usage, disk_usage):
    cpu_weight = 0.4
    ram_weight = 0.3
    disk_weight = 0.3
    
    weighted_average = (cpu_usage * cpu_weight) + (ram_usage * ram_weight) + (disk_usage * disk_weight)
    return round(weighted_average, 2)

def monitorar_tempo_alerta(cpu_usage, ram_usage, disk_usage, tempo_alerta):
    if cpu_usage > 95:
        tempo_alerta['cpu'] += 2
    else:
        tempo_alerta['cpu'] = 0

    if ram_usage > 95:
        tempo_alerta['ram'] += 2
    else:
        tempo_alerta['ram'] = 0

    if disk_usage > 95:
        tempo_alerta['disk'] += 2
    else:
        tempo_alerta['disk'] = 0

    return tempo_alerta

def export_to_json(dados):
    try:
        with open(json_file_path, mode='w', newline='', encoding='utf-8') as file:
            json.dump(dados,file)

            print("Dados exportados para JSON com sucesso!")

    except Exception as e:
        print(f"Erro ao tentar exportar os Dados da Captura para Json. Erro: {e}")


def upload_to_s3(file_name, bucket_name, object_name=None):
    if object_name is None:
        object_name = os.path.basename(file_name)

    s3_client = boto3.client('s3')

    try:
        s3_client.upload_file(file_name, bucket_name, object_name)
        print(f"Arquivo {file_name} enviado para o Bucket {bucket_name} como {object_name}.")
    except Exception as e:
        print(f"Erro ao enviar o arquivo: {e}")
        
def verify_alert(recurso, uso, limites):
    for limite, prioridade in limites:
        if uso > limite:
            print(f'\nALERTA: {recurso} ACIMA DE {limite}%!')
            throw_alert(recurso, limite, prioridade)
            break


jira = Jira(
        url = "https://remoteguard.atlassian.net",
        username = "remoteguard@outlook.com.br",
        password = "ATATT3xFfGF0fgxCl5zLBT2JycewlrlIAMcMnJM1AAPSjg6l6HgCLss1qWoCWNnPM6xhUHefa5nD22rZxpqu2LIszBJs064Tlj3c-ph5o7ep1VIDTJDmFioz_tlfHxi7vI0KRPsFJ4YNbkjbWjttFJpjG6s7-Bu1GPLyBxugMv4S33zZTwW9C3k=11DD1D32"
        )

        
def throw_alert(recurso, limite, prioridade):
    descricao_chamado = f'Recurso: {recurso} acima da capacidade ideal na Máquina ({get_hostname()}).'
    chamado = jira.issue_create(fields={
        'project': {'key': 'CS'},
        'summary': f'ALERTA: {recurso} ACIMA DE {limite}% na Máquina: ({get_hostname()})!',
        'description': descricao_chamado,
        'issuetype': {'name': 'Alert'},
        'priority': {'name': prioridade}
        })
    
    codigo_chamado = ''

    try:
        chamado
        codigo_chamado = chamado.get('key')
        print(f'Código do Chamado: {codigo_chamado}')
        register_alert(codigo_chamado, descricao_chamado)
      

    except HTTPError as e:
      print(e.response.text)


def register_alert(codigo_chamado, descricao_chamado):
    sql = "INSERT INTO alerta (codigo, descricao, fkNotebook) VALUES (%s, %s, %s)"
    cursor.execute(sql, (codigo_chamado, descricao_chamado, fkNotebook))
    conexao.commit()


def throw_process_alert():
    descricao_chamado = f'Processo indevido rodando na máquina ({get_hostname()})!.'
    chamado = jira.issue_create(fields={
        'project': {'key': 'CS'},
        'summary': f'Processo indevido rodando na máquina ({get_hostname()})!',
        'description': descricao_chamado,
        'issuetype': {'name': 'Alert'},
        'priority': {'name': 'Medium'}
        })
    
    codigo_chamado = ''

    try:
        chamado
        codigo_chamado = chamado.get('key')
        print(f'Código do Chamado: {codigo_chamado}')
        register_alert(codigo_chamado, descricao_chamado)
      

    except HTTPError as e:
      print(e.response.text)

def insert_data_to_mysql(dados):
    try:
        sql = """INSERT INTO dados (tempo_inatividade_cpu, porcentagem_cpu, bytes_ram, porcentagem_ram, 
                    bytes_disco, porcentagem_disco, qtdprocessos, processos, 
                    fkNotebook, numero_nucleos, media_ponderada, tempo_alerta_cpu, 
                    tempo_alerta_ram, tempo_alerta_disco) 
                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"""

        if len(dados) == 14:
            print(f"Dados a serem inseridos: {dados}")
            cursor.execute(sql, dados)
            conexao.commit()
            print("Dados inseridos no MySQL com sucesso.")
        else:
            print(f"Erro: A tupla de dados deve conter exatamente 14 elementos, mas contém {len(dados)}.")
    except Error as e:
        print(f"Erro ao inserir os dados: {e}")

def insert_armazenamento_to_mysql(total_disk_bytes, fk_notebook):
    try:
        sql = """INSERT INTO armazenamento (total_disco, fkNotebook) VALUES (%s, %s)"""
        
        print(f"Dados de armazenamento a serem inseridos: Total Disco:{total_disk_bytes},  Notebook:{fk_notebook}")
        
        cursor.execute(sql, (total_disk_bytes, fk_notebook))
        conexao.commit()
        print("Dados de armazenamento inseridos no MySQL com sucesso.")
    except Error as e:
        print(f"Erro ao inserir os dados de armazenamento: {e}")


def data_capture(data_capture_delay):

    cont_time = 1
    cont_registers = 1
    run_data_capture = True
    limites_recursos = [(95, 'Highest'), (90, 'High'), (85, 'Medium')]
    numero_nucleos = get_cpu_cores()
    tempo_alerta = {'cpu': 0, 'ram': 0, 'disk': 0}


    while run_data_capture:

        if cont_time % data_capture_delay == 0 or cont_time == 1:
            cpu_idle_time, cpu_usage_percentage = get_cpu_data()
            ram_usage_bytes, ram_usage_percentage = get_ram_data()
            disk_usage_bytes, disk_usage_percentage, total_disk_bytes = get_disk_data()
            process_count = get_process_count()
            

            processos = []
            for process in psutil.process_iter():
                process_name = process.name()
                if process.status() == 'running' :
                    processos.append(process_name)

            processosString = str(processos)

            rounded_weighted_average = get_weighted_system_usage(cpu_usage_percentage, ram_usage_percentage, disk_usage_percentage)
            tempo_alerta = monitorar_tempo_alerta(cpu_usage_percentage, ram_usage_percentage, disk_usage_percentage, tempo_alerta)


            dados.append ({
                "tempoInatividadeCPU": cpu_idle_time,
                "porcentagemCPU": cpu_usage_percentage,
                "bytesRAM": ram_usage_bytes,
                "porcentagemRAM": ram_usage_percentage,
                "bytesDisco": disk_usage_bytes,
                "porcentagemDisco": disk_usage_percentage,
                "processos": processos,
                "dataHora": dt.datetime.now().isoformat()
            })

            dadosSQL = (cpu_idle_time, cpu_usage_percentage, ram_usage_bytes, ram_usage_percentage,
            disk_usage_bytes, disk_usage_percentage, process_count,
            processosString, fkNotebook, numero_nucleos, rounded_weighted_average,
            tempo_alerta['cpu'], tempo_alerta['ram'], tempo_alerta['disk'])

            insert_data_to_mysql(dadosSQL)
            insert_armazenamento_to_mysql(total_disk_bytes, fkNotebook)


            print("----------------------------------------------------------------------------------------------------")           
            print(f"Tempo de Inatividade da CPU: {cpu_idle_time}")
            print(f"Porcentagem de Uso da CPU: {cpu_usage_percentage}")
            print(f"Uso da Memória em Bytes: {ram_usage_bytes}")
            print(f"Porcentagem de Uso da Memória: {ram_usage_percentage}")
            print(f"Uso do Disco em Bytes: {disk_usage_bytes}")
            print(f"Porcentagem de Uso do Disco: {disk_usage_percentage}")
            print(f"Captura de Data e Hora: {dt.datetime.now().isoformat()}")
            print()
            print(cont_registers, " Registro Inserido.") if cont_registers == 1 else print(cont_registers, "Registro Inseridos.")

            cont_registers += 1

        time.sleep(1)
        cont_time+= 1

        export_to_json(dados)
        upload_to_s3(json_file_path, bucket_name)
        
        # Atribuindo valores para testes de alerta:
        cpu_usage_percentage = 89.0
        ram_usage_percentage = 88.0

        verificar_processos_indevidos = bool(set(processos).intersection(processos_indevidos))

        if verificar_processos_indevidos:
            throw_process_alert()


        verify_alert('CPU', cpu_usage_percentage, limites_recursos)
        verify_alert('MEMÓRIA RAM', ram_usage_percentage, limites_recursos)
        

def menu():
    data_capture_delay = int(input('Deseja Capturar os Dados a cada quantos Segundos?: '))
    data_capture(data_capture_delay)

menu()
