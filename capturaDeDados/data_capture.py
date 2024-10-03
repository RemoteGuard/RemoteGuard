import psutil
import os
import time
import csv
import boto3

dados = []

bucket_name = 'bucket-raw-rg'
csv_file_path = '/home/ubuntu/python/nome_integrante.csv'

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
    return disk_usage_bytes, disk_usage_percentage

def export_to_csv(dados):
    try:
        with open(csv_file_path, mode='w', newline='', encoding='utf-8') as file:
            writer = csv.writer(file)
            writer.writerows(dados)
            
        print("Dados exportados para CSV com sucesso!")
        
    except Exception as e:
        print(f"Erro ao tentar exportar os Dados da Captura para CSV. Erro: {e}")
    
def upload_to_s3(file_name, bucket_name, object_name=None):
    if object_name is None:
        object_name = os.path.basename(file_name)

    s3_client = boto3.client('s3')
    
    try:
        s3_client.upload_file(file_name, bucket_name, object_name)
        print(f"Arquivo {file_name} enviado para o Bucket {bucket_name} como {object_name}.")
    except Exception as e:  
        print(f"Erro ao enviar o arquivo: {e}")

def data_capture(data_capture_delay):
    cont_time = 1
    cont_registers = 1
    run_data_capture = True
    
    dados.append(['Tempo de Inatividade da CPU', 'Uso da CPU (%)', 'Uso da Memória RAM (Bytes)', 'Uso da Memória RAM (%)', 'Uso do Disco (Bytes)', 'Uso do Disco (%)'])
    
    while run_data_capture:
        
        if cont_time % data_capture_delay == 0 or cont_time == 1:
            cpu_idle_time, cpu_usage_percentage = get_cpu_data()
            ram_usage_bytes, ram_usage_percentage = get_ram_data()
            disk_usage_bytes, disk_usage_percentage = get_disk_data()
            
            print("----------------------------------------------------------------------------------------------------------\n")
            
            
            print(f"Tempo de Inatividade da CPU: {cpu_idle_time}")
            print(f"Porcentagem de Uso da CPU: {cpu_usage_percentage}")
            print(f"Uso da Memória em Bytes: {ram_usage_bytes}")
            print(f"Porcentagem de Uso da Memória: {ram_usage_percentage}")
            print(f"Uso do Disco em Bytes: {disk_usage_bytes}")
            print(f"Porcentagem de Uso do Disco: {disk_usage_percentage}")
            
            dados.append([cpu_idle_time, cpu_usage_percentage, ram_usage_bytes, ram_usage_percentage, disk_usage_bytes, disk_usage_percentage])
            
            print("\n", cont_registers, " Registro Inserido.") if cont_registers == 1 else print(cont_registers, " Registro Inseridos.")
            
            cont_registers += 1       
               
        time.sleep(1)
        cont_time+= 1
        
        if (cont_registers % 20 == 0): 
            export_to_csv(dados)
            upload_to_s3(csv_file_path, bucket_name)

def menu():   
    data_capture_delay = int(input('Deseja Capturar os Dados a cada quantos Segundos?: '))
    data_capture(data_capture_delay)

menu()