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
            host='localhost',  # Ajuste para o endereço do seu servidor MySQL
            database='remote_guard',  # Nome do banco de dados
            user='root',  # Seu usuário MySQL
            password='192719'  # Sua senha MySQL
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

def get_swap_data():
    swap_data = psutil.swap_memory()._asdict()
    swap_used_bytes = swap_data['used']
    swap_usage_percentage = swap_data['percent']
    return swap_used_bytes, swap_usage_percentage

def get_boot_time():
    return psutil.boot_time()

def format_boot_time(boot_time):
    return datetime.fromtimestamp(boot_time).strftime('%Y-%m-%d %H:%M:%S')

def insert_data_to_mysql(connection, dados):
    cursor = connection.cursor()
    try:
        sql = """INSERT INTO monitoramento (hostname, tempo_inatividade_cpu, porcentagem_cpu, bytes_ram, porcentagem_ram, 
                    bytes_disco, porcentagem_disco, processos, bytes_swap, porcentagem_swap, boot_time, bytes_enviados, bytes_recebidos) 
                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"""
        cursor.execute(sql, dados)
        connection.commit()
        print("Dados inseridos no MySQL com sucesso.")
    except Error as e:
        print(f"Erro ao inserir os dados: {e}")

def data_capture(data_capture_delay, capture_count):
    connection = connect_to_mysql()
    if not connection:
        print("Não foi possível conectar ao MySQL. A captura de dados será interrompida.")
        return

    boot_time = get_boot_time()
    formatted_boot_time = format_boot_time(boot_time)

    for i in range(capture_count):
        cpu_idle_time, cpu_usage_percentage = get_cpu_data()
        ram_usage_bytes, ram_usage_percentage = get_ram_data()
        disk_usage_bytes, disk_usage_percentage = get_disk_data()
        bytes_sent, bytes_recv = get_network_data()
        process_count = get_process_count()
        swap_used_bytes, swap_usage_percentage = get_swap_data()

        dados = (get_hostname(), cpu_idle_time, cpu_usage_percentage, ram_usage_bytes, ram_usage_percentage,
                 disk_usage_bytes, disk_usage_percentage, process_count, swap_used_bytes, swap_usage_percentage,
                 formatted_boot_time, bytes_sent, bytes_recv)

        insert_data_to_mysql(connection, dados)

        if i < capture_count - 1:
            time.sleep(data_capture_delay)

def menu():
    data_capture_delay = int(input('Deseja capturar os dados a cada quantos segundos? '))
    capture_count = int(input('Quantas capturas deseja realizar? '))
    data_capture(data_capture_delay, capture_count)

menu()
