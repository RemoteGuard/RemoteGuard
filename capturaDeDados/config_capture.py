import psutil # Captura de Dados de Máquina.
import pymysql # Conexão com Banco de Dados.
import os # Identificação do Sistema Operacional da Máquina.
import socket # Captura do Nome da Máquina (Hostname).

def create_db_connection(): # Função para Criar a Conexão com Banco de Dados.
    try:
        conn = pymysql.connect( # Conexão com o Banco de Dados.
                host="localhost",
                user="murillo",
                password="D@rkKn!ght2005",
                database="remote_guard"
            )
        cursor = conn.cursor() # Cursor (Objeto) para Executar Comandos SQL.
        print(f"Conexão com o Banco {conn.db.decode()} estabelecida com Sucesso!")
        return conn, cursor
    except pymysql.MySQLError as e:
        print(f"Falha ao estabelecer Conexão com o Banco de Dados: {e}")
        return None, None

conn, cursor = create_db_connection() # Executa a Função para Criação da Conexão com o Banco de Dados e Armazena nas Variáveis.
        
def get_hostname():
    return socket.gethostname()

def get_root_directory():
    return 'C:\\' if os.name == 'nt' else '/'

def verify_equipment_registration():
    global fkNotebook
    hostname = get_hostname()
    # hostname = 'hostTeste'
    
    sql = "SELECT idNotebook, hostname FROM notebook WHERE hostname = %s"
    cursor.execute(sql, (hostname,))
    register = cursor.fetchone()

    if register: 
        fkNotebook = register[0]
    else:
        sql = "INSERT INTO notebook (hostname) VALUES (%s)"
        cursor.execute(sql, (hostname,))
        conn.commit()
        fkNotebook = cursor.lastrowid
        
    return fkNotebook
        
def get_process_iter():
    return psutil.process_iter()

def get_cpu_data():
    cpu_data = psutil.cpu_times()._asdict()
    cpu_idle_time = cpu_data['idle']
    cpu_usage_percentage = psutil.cpu_percent(interval = 1)
    return cpu_idle_time, cpu_usage_percentage

def get_ram_data():
    ram_data = psutil.virtual_memory()._asdict()
    ram_usage_bytes = ram_data['used'] # Captura em Bytes.
    ram_usage_percentage = ram_data['percent']
    return ram_usage_bytes, ram_usage_percentage

def get_disk_data():
    disk_data = psutil.disk_usage(get_root_directory())._asdict()
    disk_usage_bytes = disk_data['used'] # Captura em Bytes.
    disk_usage_percentage = disk_data['percent']
    return disk_usage_bytes, disk_usage_percentage

# Lista contendo os Processos Ignorados pela Captura.
list_ignored_processes = [
    'svchost.exe',
    'SamsungSARMode.exe',
    'IntelAnalyticsService.exe' ,
    'IntelConnectivityNetworkService.exe',
    'IntelAudioService.exe',
    'Intel_PIE_Service.exe',
    'IntelCpHDCPSvc.exe',
    'IntelConnectService.exe',
    'IntelConnect.exe',
    'conhost.exe',
    'System Idle Process' ,
    'SystemPlatformEngine.exe',
    'SamsungSystemSupportService.exe',
    'SecurityHealthSystray.exe',
    'SamsungSystemSupportEngine.exe',
    'SystemSettingsBroker.exe' ,
    'IntelCpHDCPSvc.exe',
    'System',
    'Registry',
    'dllhost.exe',
    'services.exe',
    'wininit.exe',
    'lsass.exe',
    'RbackgroundTaskHost.exe',
    'idea64.exe',
    'sServiceKeyMonitor.exe',
    'WindowsMCFCore.exe',
    'SamsungSettingsHost.exe',
    'Widgets.exe',
    'FileSyncHelper.exe',
    'SamsungSystemSupportEngine.exe'
]