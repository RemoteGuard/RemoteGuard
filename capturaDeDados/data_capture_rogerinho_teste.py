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
            user='root',
            password='192719'
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
    cpu_usage_percentage_transform = cpu_usage_percentage*10
    return cpu_idle_time, cpu_usage_percentage_transform

def get_ram_data():
    ram_data = psutil.virtual_memory()._asdict()
    ram_usage_bytes = ram_data['used']
    ram_usage_percentage = ram_data['percent']
    return ram_usage_bytes, ram_usage_percentage

def get_disk_data():
    disk_data = psutil.disk_usage(get_root_directory())._asdict()
    disk_usage_bytes = disk_data['used']
    disk_usage_percentage = disk_data['percent']
    return disk_usage_bytes, disk_usage_percentage

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
    numero_nucleos = psutil.cpu_count(logical=True)
    return numero_nucleos

def get_weighted_system_usage(cpu_usage, ram_usage, disk_usage):
    cpu_weight = 0.4
    ram_weight = 0.3
    disk_weight = 0.3
    
    weighted_average = (cpu_usage * cpu_weight) + (ram_usage * ram_weight) + (disk_usage * disk_weight)
    rounded_weighted_average = round(weighted_average, 2)
    return rounded_weighted_average

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
                    bytes_disco, porcentagem_disco, processos, boot_time, fkNotebook, 
                    numero_nucleos, media_ponderada, tempo_alerta_cpu, tempo_alerta_ram, tempo_alerta_disco) 
                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"""
        
        print(f"Dados a serem inseridos: {dados}")
        
        if len(dados) == 14:
            cursor.execute(sql, dados)
            connection.commit()
            print("Dados inseridos no MySQL com sucesso.")
        else:
            print("Erro: A tupla de dados deve conter exatamente 14 elementos.")
    except Error as e:
        print(f"Erro ao inserir os dados: {e}")
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
        disk_usage_bytes, disk_usage_percentage = get_disk_data()
        bytes_sent, bytes_recv = get_network_data()
        process_count = get_process_count()
        fk_notebook = 1  

        rounded_weighted_average = get_weighted_system_usage(cpu_usage_percentage, ram_usage_percentage, disk_usage_percentage)
        tempo_alerta = monitorar_tempo_alerta(cpu_usage_percentage, ram_usage_percentage, disk_usage_percentage, tempo_alerta)

        print(f"Tempo em alerta - CPU: {tempo_alerta['cpu']}s, RAM: {tempo_alerta['ram']}s, Disco: {tempo_alerta['disk']}s")

        dados = (cpu_idle_time, cpu_usage_percentage, ram_usage_bytes, ram_usage_percentage,
                 disk_usage_bytes, disk_usage_percentage, process_count,
                 formatted_boot_time, fk_notebook, numero_nucleos, rounded_weighted_average,
                 tempo_alerta['cpu'], tempo_alerta['ram'], tempo_alerta['disk'])

        insert_data_to_mysql(connection, dados)

        time.sleep(2)

data_capture()
