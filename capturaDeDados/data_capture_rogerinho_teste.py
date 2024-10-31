import os
import socket
import time
import psutil
import mysql.connector
from mysql.connector import Error
from wifi import Cell, Scheme

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
    net_data = psutil.net_io_counters()._asdict()
    bytes_enviados = net_data['bytes_sent']
    bytes_recebidos = net_data['bytes_recv']
    return bytes_enviados, bytes_recebidos

def obter_info_rede():
    wifi_interface = 'wlan0' 
    ssid = "Rede Wi-Fi não detectada"
    
    try:
        connected_cell = next((cell for cell in Cell.all(wifi_interface) if cell.connected), None)
        if connected_cell:
            ssid = connected_cell.ssid
    except Exception as e:
        print(f"Erro ao obter informações da rede: {e}")

    rede_info = {}
    for nome, stats in psutil.net_if_stats().items():
        status = 'Ativo' if stats.isup else 'Inativo'
        velocidade = f"{stats.speed} Mbps" if stats.speed else "N/A"
        rede_info[nome] = (status, velocidade, ssid if nome == wifi_interface else 'N/A')
    return rede_info


def insert_data_to_mysql(connection, dados):
    cursor = connection.cursor()
    try:
        sql = """INSERT INTO monitoramento (hostname, tempo_inatividade_cpu, porcentagem_cpu, bytes_ram, porcentagem_ram,
                     bytes_disco, porcentagem_disco, bytes_enviados, bytes_recebidos, processos, interface_rede, 
                     status_rede, velocidade_rede, ssid)
                     VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"""
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

    for i in range(capture_count):
        cpu_idle_time, cpu_usage_percentage = get_cpu_data()
        ram_usage_bytes, ram_usage_percentage = get_ram_data()
        disk_usage_bytes, disk_usage_percentage = get_disk_data()
        bytes_enviados, bytes_recebidos = get_network_data()

        rede_info = obter_info_rede()
        
        interface = 'wlan0' 
        if interface in rede_info:
            status, velocidade, ssid = rede_info[interface]
        else:
            status = "Inativo"
            velocidade = "N/A"
            ssid = "N/A"

        processos = [proc.name() for proc in psutil.process_iter() if proc.status() == 'running']
        dados = (get_hostname(), cpu_idle_time, cpu_usage_percentage, ram_usage_bytes, ram_usage_percentage,
                 disk_usage_bytes, disk_usage_percentage, bytes_enviados, bytes_recebidos, str(processos),
                 interface, status, velocidade, ssid)

 
        insert_data_to_mysql(connection, dados)
        
        if i < capture_count - 1: 
            time.sleep(data_capture_delay)


def menu():
    data_capture_delay = int(input('Deseja capturar os dados a cada quantos segundos? '))
    capture_count = int(input('Quantas capturas deseja realizar? '))
    data_capture(data_capture_delay, capture_count)

menu()
