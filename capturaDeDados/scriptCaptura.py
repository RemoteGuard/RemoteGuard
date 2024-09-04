import psutil, pandas as pd, time
import mysql.connector
import os
import uuid
import threading


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
if nomeSO == 'nt': #Se o sistema operacional for windows  
    chamadaDisco = 'C:\\' #O disco vai ser chamado assim
else:        #Se for linux
    chamadaDisco = '/'  # O disco vai ser chamado assim
cursor = conn.cursor()


query = f"""SELECT * FROM notebook as nb 
	JOIN controleFluxo as cf 
		ON nb.idNotebook = cf.fkNotebook 
    JOIN funcionario as f 
		ON cf.fkFuncionario = f.idFuncionario
	WHERE nb.idNotebook = {endereco};"""
 
 
cursor.execute(query)

resultado = cursor.fetchall()
    
resultado = resultado[0]
    



def capturarDados():
    cont = 1
    while True:
        try:
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
            if(cont % 60 == 0) or cont == 1:
                listaNomesProcessos = ['svchost.exe','SamsungSARMode.exe', 'IntelAnalyticsService.exe' ,'conhost.exe']
                for process in psutil.process_iter():
                    
                    nome = process.name()
                    if(nome not in listaNomesProcessos and process.status() == 'running'):
                                    sql = "INSERT INTO processos (nomeProcesso, fkNotebook) values (%s,%s);"
                                    valores = (nome, endereco)

                                    cursor.execute(sql, valores)

                                    conn.commit()
                                    
    
    
                
            cont += 1
            time.sleep(1)
        except:
            print('\n\n\n')
            print('Obrigado por usar nossos serviços')
            break
import pandas as pd
listaFinal = []



def monitorarAnalista(medida):
    
        query = "SELECT * FROM dados"

        cursor.execute(query)

        resultado = cursor.fetchall()
        
        column_names = [desc[0] for desc in cursor.description]
        df = pd.DataFrame(resultado, columns=column_names)

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
            
        continuar = input('Deseja fazer um novo monitoramento? (S/N)')
        
        if(continuar == 'S'):
            menu()
        else:
            print('Obrigado por consultar a RemoteGuard!')  
            
            cursor.close()
            conn.close()  
            
            
            
def monitorarGerente():
    tipoMonitoramento = int(input('Deseja monitorar os programas do usuário ou verificar o tempo de inatividade? \n Digite 0 para inatividade e 1 para programas: '))
    if tipoMonitoramento == 0:
                
        query = f"""SELECT p.*,supervisor.nome, f.nome, f.cargo FROM processos as p 
            JOIN notebook as n
                ON p.fkNotebook = n.idNotebook
            JOIN controleFluxo as cf 
                ON n.idNotebook = cf.fkNotebook 
            JOIN funcionario as f 
                ON cf.fkFuncionario = f.idFuncionario
            JOIN funcionario as supervisor 
                ON f.fkSupervisor = supervisor.idFuncionario
            WHERE supervisor.idFuncionario = 3;"""
            #resultado[10]
        cursor.execute(query)

        resultado = cursor.fetchall()
        colunaHora = [linha[1] for linha in resultado]
        colunaProcesso = [linha[2] for linha in resultado]
        colunaNomes = [linha[5] for linha in resultado]
        colunaCargo = [linha[6] for linha in resultado]


        if 'Discord.exe' in colunaProcesso:
                posicao = colunaProcesso.index('Discord.exe')
                print(f'O {colunaCargo[posicao]} {colunaNomes[posicao]} começou a usar o {colunaProcesso[posicao]} as {colunaHora[posicao]}')
                

                
    elif tipoMonitoramento == 1:
        print('sla2') 
    else: 
        print('Valor invalido!')   
        monitorarGerente()
    
def conferirSenha():
    global resultado
    tentativa = 1
    passouSenha = False
    senha = input('Digite a sua senha para continuar: ')
    while passouSenha == False or  tentativa < 3:
        if(senha == resultado[15]):
            print('Senha correta!')
            passouSenha = True
            break
        else:
            print('\n')
            senha = input('Senha incorreta! Tente novamente: ')
            tentativa += 1

    return passouSenha
            
    
def menu():
    global resultado
    cargo = resultado[11]
    if cargo == 'analista':   
        
        
        listaComponentes = ['percCPU', 'percRAM', 'usedRAM', 'percDisk', 'usedDisk']
        
        for componente in listaComponentes:
                deseja = int(input('Deseja monitorar o ' + componente + ' ? \n Digite 1 para sim e 0 para não: ')) 
                print(deseja)
                if deseja == 1:
                    listaFinal.append(componente)
                    
        medida = int(input('Se deseja monitorar a média por maquina digite 0 \n Se for de todos digite 1: '))
            
        monitorarAnalista(medida)
    elif cargo == 'gerente':
        monitorarGerente()
        
    else: 
        print('Os funcionarios não tem permissão para acessar arquivos sensiveis!')        
    
        

def home():
    print("\n\n")
    print(f'Bem vindo à RemoteGuard {resultado[12]}!\n ')
    passouSenha = conferirSenha()
    if(passouSenha == True):
        menu()
    else:
        print('Você não tem permissão para acessar nossos dados!')
   
threadCaptura = threading.Thread(target=capturarDados)
threadCaptura.start()

home()
