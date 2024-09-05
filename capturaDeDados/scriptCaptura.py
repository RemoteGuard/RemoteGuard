import psutil # Captura os dados da maquina
import pandas as pd # Usamos duas funções, uma para transformar em DataFrame e outra para agrupar
import time # Responsavel pela discretização de tempo
import mysql.connector #Conexao com banco de dados
import uuid #Unique Universal ID - Placa de rede e pk da tabela notebook  
import os # Nos fala se estamos usando Windows ou Linux

endereco = uuid.getnode() # endereço MAC do dispositivo, está ligado a placa de rede interna do dispositivo 


conn = mysql.connector.connect(
        host="localhost",
        user="root",
        password="Lqsym@2020",
        database="remoteGuard"
    )


nomeSO = os.name #Pegando o nome do SO
if nomeSO == 'nt': #Se o sistema operacional for windows  
    chamadaDisco = 'C:\\' #O disco vai ser chamado assim
else: #Se for linux
    chamadaDisco = '/'  # O disco vai ser chamado assim



cursor = conn.cursor() #Criando um cursor (objeto que executa códigos)
def capturarDados(delayProcessos, delayDados):
  cont = 1
  while True:
        # try:
          if(cont % delayProcessos == 0) or cont == 1:
                  
                  listaNomesProcessos = ['svchost.exe','SamsungSARMode.exe', 'IntelAnalyticsService.exe' ,'conhost.exe']
                  for process in psutil.process_iter():
                      
                      nome = process.name()
                      if(nome not in listaNomesProcessos and process.status() == 'running'):
                                      sql = "INSERT INTO processos (nomeProcesso, fkNotebook) values (%s,%s);"
                                      valores = (nome, endereco)

                                      cursor.execute(sql, valores)

                                      conn.commit()
                                      
      
          if cont % delayDados == 0:
              contRegistros = 1
              dadosCPU = psutil.cpu_times()
              dadosCPU = dadosCPU._asdict()
              inativo = dadosCPU['idle']
              inativo = round(inativo, 2)
              
              percCPU = psutil.cpu_percent(interval = 1)
              memoria = psutil.virtual_memory()
              memoria = memoria._asdict()

              disco = psutil.disk_usage(chamadaDisco)
              disco = disco._asdict()
              percRAM = memoria['percent']
              usedRAM = memoria['used']
              usedRAM = round(usedRAM)
              usedRAM = usedRAM / (pow(10,9))
              percDisk = disco['percent']
              usedDisk = disco['used']
              usedDisk = round(usedDisk)
              usedDisk = usedDisk / (pow(10,9))
              
              sql = "INSERT INTO dados (percCPU,  tempoInativo, percRAM, usedRAM, percDisc, usedDisc, fkNotebook) values (%s,%s,%s, %s, %s, %s, %s);"
              valores = (percCPU, inativo, percRAM, usedRAM, percDisk, usedDisk, endereco)

              cursor.execute(sql, valores)

              conn.commit()
              
              if contRegistros == 1:
                  print(contRegistros, "registro inserido.")
              else:
                  print(contRegistros, "registros inseridos.")
              contRegistros += 1
              
      
          time.sleep(1)
          cont += 1
            # time.sleep(1)
        # except:
        #     print('\n\n\n')
        #     print('Obrigado por usar nossos serviços')
        #     break

def menu():
  delayProcessos = int(input('Deseja capturar os processos de quanto em quanto tempo: '))
  delayDados = int(input('Deseja monitorar os dados de quanto em quanto tempo: '))
  capturarDados(delayProcessos, delayDados)
  
menu()