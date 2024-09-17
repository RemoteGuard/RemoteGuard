from config_capture import conn, cursor, verify_equipment_registration, get_process_iter, get_cpu_data, get_ram_data, get_disk_data, list_ignored_processes
import time

def data_capture(processes_monitoring_delay, data_capture_delay):
    cont_time = 1
    cont_registers = 1
    run_data_capture = True
    
    while run_data_capture:
        if(cont_time % processes_monitoring_delay == 0) or cont_time == 1: # Insere os Dados no Banco de acordo com a Discretização.        
            for process in get_process_iter():
                process_name = process.name()
                
                if(process_name not in list_ignored_processes and process.status() == 'running'):
                    sql = "INSERT INTO processos (nomeProcesso, fkNotebook) values (%s,%s);"
                    val = (process_name, fkNotebook)
                    cursor.execute(sql, val)
                    conn.commit()
                                      
      
        if cont_time % data_capture_delay == 0 or cont_time == 1: # Insere os Dados no Banco de acordo com a Discretização.   
            # Chamada para Funções de Captura dos Componentes:
            cpu_idle_time, cpu_usage_percentage = get_cpu_data()
            ram_usage_gigabytes, ram_usage_percentage = get_ram_data()
            disk_usage_gigabytes, disk_usage_percentage = get_disk_data()
            
            sql = "INSERT INTO dados (tempoInatividade, percCPU, usedRAM, percRAM, usedDisk, percDisk, fkNotebook) VALUES (%s, %s, %s, %s, %s, %s, %s);"
            val = (cpu_idle_time, cpu_usage_percentage, ram_usage_gigabytes, ram_usage_percentage, disk_usage_gigabytes, disk_usage_percentage, fkNotebook)
            cursor.execute(sql, val)
            conn.commit()
            
            print(cont_registers, " Registro Inserido.") if cont_registers == 1 else print(cont_registers, " Registro Inseridos.")
            cont_registers += 1       
               
        time.sleep(1)
        cont_time+= 1


def menu(): # Menu para Configuração da Discretização.
  processes_monitoring_delay = int(input('Deseja Monitorar os Processos a cada quantos Segundos?: '))
  data_capture_delay = int(input('Deseja Capturar os Dados a cada quantos Segundos?: '))
  data_capture(processes_monitoring_delay, data_capture_delay) # Executa a Função para Capturar os Dado.

fkNotebook = verify_equipment_registration() # Verifica se a Máquina já está Registrada no Banco de Dados.

menu() # Executa a Função para Configurar a Captura.