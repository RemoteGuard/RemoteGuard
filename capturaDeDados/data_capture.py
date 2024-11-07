import os
import socket
import time
import psutil
import json
import boto3
from botocore.exceptions import ClientError
from atlassian import Jira
from requests import HTTPError

def get_hostname():
    return socket.gethostname()


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
    return disk_usage_bytes, disk_usage_percentage

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

def throw_alert(recurso, limite, prioridade):
    jira = Jira(
        url = "https://remoteguard.atlassian.net",
        username = "remoteguard@outlook.com.br",
        password = "ATATT3xFfGF0kUnGOaAZ8vKNAjZqNAGEJ-gfFRK40Tle3JEAIglLz4yZwINngET3Kqm6LALohxgUH6vcpiKO0F7sE-QLPd0lhneyobSPo3nnPMNjoJQOxiZDv3zkWS05Dd7s2tPHfsMQVyknQN-JTwEHqqrCDkmD9mjtdHpVsq4F8Z66ikVuSWk=F008B5A2"
        )

    chamado = jira.issue_create(fields={
        'project': {'key': 'CS'},
        'summary': f'ALERTA: {recurso} ACIMA DE {limite}% na Máquina: ({get_hostname()})!',
        'description': f'Recurso: {recurso} acima da capacidade ideal na Máquina ({get_hostname()}).',
        'issuetype': {'name': 'Alert'},
        'priority': {'name': prioridade}
        })
    
    codigo_chamado = ''

    try:
        chamado
        codigo_chamado = chamado.get('key')
        print(f'Código do Chamado: {codigo_chamado}')
      

    except HTTPError as e:
      print(e.response.text)


def data_capture(data_capture_delay):
    cont_time = 1
    cont_registers = 1
    run_data_capture = True
    limites_recursos = [(95, 'Highest'), (90, 'High'), (85, 'Medium')]


    while run_data_capture:

        if cont_time % data_capture_delay == 0 or cont_time == 1:
            cpu_idle_time, cpu_usage_percentage = get_cpu_data()
            ram_usage_bytes, ram_usage_percentage = get_ram_data()
            disk_usage_bytes, disk_usage_percentage = get_disk_data()

            processos = []
            for process in psutil.process_iter():
                process_name = process.name()
                if( process.status() == 'running'):
                 processos.append(process_name)

            dados.append ({
                "tempoInatividadeCPU": cpu_idle_time,
                "porcentagemCPU": cpu_usage_percentage,
                "bytesRAM": ram_usage_bytes,
                "porcentagemRAM": ram_usage_percentage,
                "bytesDisco": disk_usage_bytes,
                "porcentagemDisco": disk_usage_percentage,
                "processos": processos
            })

            print("----------------------------------------------------------------------------------------------------")           
            print(f"Tempo de Inatividade da CPU: {cpu_idle_time}")
            print(f"Porcentagem de Uso da CPU: {cpu_usage_percentage}")
            print(f"Uso da Memória em Bytes: {ram_usage_bytes}")
            print(f"Porcentagem de Uso da Memória: {ram_usage_percentage}")
            print(f"Uso do Disco em Bytes: {disk_usage_bytes}")
            print(f"Porcentagem de Uso do Disco: {disk_usage_percentage}")
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
        
        verify_alert('CPU', cpu_usage_percentage, limites_recursos)
        verify_alert('MEMÓRIA RAM', ram_usage_percentage, limites_recursos)
        

def menu():
    data_capture_delay = int(input('Deseja Capturar os Dados a cada quantos Segundos?: '))
    data_capture(data_capture_delay)

menu()
