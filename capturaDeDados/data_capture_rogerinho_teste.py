import os
import socket
import time
import psutil
import mysql.connector
from mysql.connector import Error
from datetime import datetime

def get_hostname():
    return socket.gethostname()

def connect_to_mysql():
    try:
        connection = mysql.connector.connect(
            host='localhost',
            database='remote_guard',
            user='aluno',
            password='sptech'
        )
        if connection.is_connected():
            print("Conexão com o MySQL bem-sucedida.")
        return connection
    except Error as e:
        print(f"Erro ao conectar com o MySQL: {e}")
        return None

def get_root_directory():
    return 'C:\\' if os.name == 'nt' else '/'

def get_cpu_data():
    cpu_data = psutil.cpu_times()._asdict()
    cpu_idle_time = cpu_data['idle']
    cpu_usage_percentage = psutil.cpu_percent(interval=1)
    return cpu_idle_time, cpu_usage_percentage

def get_ram_data():
    ram_data = psutil.virtual_memory()._asdict()
    ram_usage_bytes = ram_data['used']
    ram_usage_percentage = ram_data['percent']*100  
    return ram_usage_bytes, ram_usage_percentage

def get_disk_data():
    disk_data = psutil.disk_usage(get_root_directory())._asdict()
    disk_usage_bytes = disk_data['used']
    disk_usage_percentage = disk_data['percent']
    total_disk_gb = round(disk_data['total'] / (1024**3), 2) # Convertendo bytes para GB
    return disk_usage_bytes, disk_usage_percentage, total_disk_gb

# No restante do código, as mudanças já estão aplicadas


def get_network_data():
    net_io = psutil.net_io_counters()
    bytes_sent = net_io.bytes_sent
    bytes_recv = net_io.bytes_recv
    return bytes_sent, bytes_recv

def get_process_count():
    process_count = sum(1 for _ in psutil.process_iter() if _.status() == 'running')
    return process_count

def get_boot_time():
    return psutil.boot_time()

def format_boot_time(boot_time):
    return datetime.fromtimestamp(boot_time).strftime('%Y-%m-%d %H:%M:%S')

def get_cpu_cores():
    return psutil.cpu_count(logical=True)

def get_weighted_system_usage(cpu_usage, ram_usage, disk_usage):
    cpu_weight = 0.4
    ram_weight = 0.3
    disk_weight = 0.3
    
    weighted_average = (cpu_usage * cpu_weight) + (ram_usage * ram_weight) + (disk_usage * disk_weight)
    return round(weighted_average, 2)

def monitorar_tempo_alerta(cpu_usage, ram_usage, disk_usage, tempo_alerta):
    if cpu_usage > 80:
        tempo_alerta['cpu'] += 2
    else:
        tempo_alerta['cpu'] = 0

    if ram_usage > 80:
        tempo_alerta['ram'] += 2
    else:
        tempo_alerta['ram'] = 0

    if disk_usage > 80:
        tempo_alerta['disk'] += 2
    else:
        tempo_alerta['disk'] = 0

    return tempo_alerta

def insert_data_to_mysql(connection, dados):
    cursor = connection.cursor()
    try:
        sql = """INSERT INTO dados (tempo_inatividade_cpu, porcentagem_cpu, bytes_ram, porcentagem_ram, 
                    bytes_disco, porcentagem_disco, processos, boot_time, 
                    fkNotebook, numero_nucleos, media_ponderada, tempo_alerta_cpu, 
                    tempo_alerta_ram, tempo_alerta_disco) 
                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"""

        print(f"Dados a serem inseridos: {dados}")

        if len(dados) == 14:
            cursor.execute(sql, dados)
            connection.commit()
            print("Dados inseridos no MySQL com sucesso.")
        else:
            print(f"Erro: A tupla de dados deve conter exatamente 14 elementos, mas contém {len(dados)}.")
    except Error as e:
        print(f"Erro ao inserir os dados: {e}")
    finally:
        cursor.close()

   

def insert_armazenamento_to_mysql(connection, total_disk_bytes, fk_notebook):
    cursor = connection.cursor()
    try:
        sql = """INSERT INTO armazenamento (total_disco, fkNotebook) VALUES (%s, %s)"""
        
        print(f"Dados de armazenamento a serem inseridos: Total Disco:{total_disk_bytes},  Notebook:{fk_notebook}")
        
        cursor.execute(sql, (total_disk_bytes, fk_notebook))
        connection.commit()
        print("Dados de armazenamento inseridos no MySQL com sucesso.")
    except Error as e:
        print(f"Erro ao inserir os dados de armazenamento: {e}")
    finally:
        cursor.close()



def data_capture():
    connection = connect_to_mysql()
    if not connection:
        print("Não foi possível conectar ao MySQL. A captura de dados será interrompida.")
        return

    boot_time = get_boot_time()
    formatted_boot_time = format_boot_time(boot_time)
    numero_nucleos = get_cpu_cores()
    tempo_alerta = {'cpu': 0, 'ram': 0, 'disk': 0}

    while True:
        cpu_idle_time, cpu_usage_percentage = get_cpu_data()
        ram_usage_bytes, ram_usage_percentage = get_ram_data()
        disk_usage_bytes, disk_usage_percentage, total_disk_bytes = get_disk_data()
        bytes_sent, bytes_recv = get_network_data()
        process_count = get_process_count()
        fk_notebook = 1  

        rounded_weighted_average = get_weighted_system_usage(cpu_usage_percentage, ram_usage_percentage, disk_usage_percentage)
        tempo_alerta = monitorar_tempo_alerta(cpu_usage_percentage, ram_usage_percentage, disk_usage_percentage, tempo_alerta)

        print(f"Tempo em alerta - CPU: {tempo_alerta['cpu']}s, RAM: {tempo_alerta['ram']}s, Disco: {tempo_alerta['disk']}s")

    # Dados para a tabela `dados`
        dados = (cpu_idle_time, cpu_usage_percentage, ram_usage_bytes, ram_usage_percentage,
                 disk_usage_bytes, disk_usage_percentage, process_count,
                 formatted_boot_time, fk_notebook, numero_nucleos, rounded_weighted_average,
                 tempo_alerta['cpu'], tempo_alerta['ram'], tempo_alerta['disk'])

        insert_data_to_mysql(connection, dados)

        insert_armazenamento_to_mysql(connection, total_disk_bytes, fk_notebook)

        time.sleep(2)

data_capture()
