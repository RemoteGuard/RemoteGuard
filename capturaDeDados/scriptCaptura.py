import psutil, pandas as pd, time
import mysql.connector
import os
import uuid


endereco = uuid.getnode() # endereço MAC do dispositivo, está ligado a placa de rede interna do dispositivo 


'''
#from node import mac_get
#pip install mysql-connector-python
#adicionar insert de programas
#Verificar se é gerente ou analista (login e senha)
#Adicionar threads
filtrar exibição

'''
conn = mysql.connector.connect(
        host="localhost",
        user="root",
        password="Lqsym@2020",
        database="remoteGuard"
    )

nomeSO = os.name
if nomeSO == 'nt':
    chamadaDisco = 'C:\\'
else: 
    chamadaDisco = '/'
cursor = conn.cursor()
def capturarDados(rodar):
    cont = 1
    while rodar > 0:
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
        '''
        if cont == 1:
            print(cont, "registro inserido.")
        else:
            print(cont, "registros inseridos.")
        
        '''
            
        cont += 1
        time.sleep(1)
        rodar -= 1   
import pandas as pd
listaFinal = []



def monitorar(medida):
    
        query = "SELECT * FROM dados"

        cursor.execute(query)

        results = cursor.fetchall()
        column_names = [desc[0] for desc in cursor.description]
        
        df = pd.DataFrame(results, columns=column_names)

        cursor.close()
        conn.close()
        if medida == 0:
            df = df.groupby('fkNotebook')
        mediaCPU = df['percCPU'].mean()
        mediaRAM = df['percRAM'].mean()
        mediaUsedRAM = df['usedRAM'].mean()
        mediaDisc = df['percDisc'].mean()
        mediaUsedDisc = df['usedDisc'].mean()
        
        if 'percCPU' in listaFinal:
            print('média de uso da CPU de cada Notebook: \n ' , mediaCPU)
        if 'percRAM' in listaFinal:
            print('média de uso da RAM de cada Notebook: \n ' , mediaRAM)
        if 'usedRAM' in listaFinal:
            print('média de uso da RAM em bytes de cada Notebook: \n ' , mediaUsedRAM)
        if 'percDisk' in listaFinal:
            print('média de uso do disco em cada Notebook: \n ' , mediaDisc)
        if 'usedDisk' in listaFinal:
            print('média de uso de disco em bytes de cada Notebook: \n ' , mediaUsedDisc)     
    
def menu():
    listaComponentes = ['percCPU', 'percRAM', 'usedRAM', 'percDisk', 'usedDisk']
    opcao = int(input('Digite 0 para capturar dados ou 1 para verificar seus funcionários '))
    if(opcao == 0):
        print('Você escolheu capturar dados') 
        tempo = int(input('Digite por quanto tempo deseja rodar o grafico: '))
    
        capturarDados(tempo)
    else:
        print('Você escolheu verificar um funcionario')  
        for componente in listaComponentes:
            deseja = int(input('Deseja monitorar o ' + componente + ' ? \n Digite 1 para sim e 0 para não: ')) 
            print(deseja)
            if deseja == 1:
                   listaFinal.append(componente)
                   
        medida = int(input('Se deseja monitorar a média por maquina digite 0 \n Se for de todos digite 1: '))
        
        monitorar(medida)
        
    
    
menu()
