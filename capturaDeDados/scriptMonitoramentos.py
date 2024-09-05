
import psutil # Captura os dados da maquina
import pandas as pd # Usamos duas funções, uma para transformar em DataFrame e outra para agrupar
import time # Responsavel pela discretização de tempo
import mysql.connector #Conexao com banco de dados
import uuid #Unique Universal ID - Placa de rede e pk da tabela notebook  

endereco = uuid.getnode() # endereço MAC do dispositivo, está ligado a placa de rede interna do dispositivo 



conn = mysql.connector.connect( #Estabelecendo conexao com o banco de dados
        host="localhost",
        user="root",
        password="Lqsym@2020",
        database="remoteGuard"
    )

cursor = conn.cursor() #Criando um cursor (objeto que executa códigos)

#criando select para pegar: dados do notebook e do usuário
query = f"""SELECT * FROM notebook as nb 
	JOIN controleFluxo as cf 
		ON nb.idNotebook = cf.fkNotebook 
    JOIN funcionario as f 
		ON cf.fkFuncionario = f.idFuncionario
	WHERE nb.idNotebook = {endereco};"""
 
cursor.execute(query) # Executando select 


#lista de listas
resultado = cursor.fetchall() # pegando todas os linhas dados do select 
resultado = resultado[0] #pegando a primeira linha(lista) do select
def monitorarAnalista():
    
        medida = int(input('Se deseja monitorar a média por maquina digite 0 \n Se for de todos digite 1: '))
        ''
        query = "SELECT * FROM dados" 

        cursor.execute(query) # Executando select

        resultado = cursor.fetchall()# pegando todas os linhas dados do select 
        
        
        #Nomeando as colunas do df com base nas colunas do banco de dados 
        column_names = ['idDados', 'dataHora', 'percCPU', 'tempoInativo', 'percRAM', 'usedRAM', 'percDisc', 'usedDisc', 'fkNotebook']
        df = pd.DataFrame(resultado, columns=column_names) # df = linha e coluna 
        
        #Se o usuario quiser ver cada notebook separadamente
        if medida == 0:
            # Agrupando os dados por 'fkNotebook' e calculando a média das colunas
            df = df.groupby('fkNotebook')[['percCPU', 'percRAM', 'usedRAM', 'percDisc', 'usedDisc']].mean()

            # Criando variavel para cada valor médio
            mediaCPU = df['percCPU']
            mediaRAM = df['percRAM']
            mediaUsedRAM = df['usedRAM']
            mediaDisc = df['percDisc']
            mediaUsedDisc = df['usedDisc']

    
            print('\n\n')
            mensagem1 = "ID Notebook | CPU Média |  RAM % | RAM Usada | Disco % | Disco Usado "
            print(mensagem1)
            #para cada notebook no df (index = identificacao da linha) 
            for notebook_id in df.index:
                mensagem = f"{notebook_id} |   {mediaCPU[notebook_id]:.2f}    | {mediaRAM[notebook_id]:.2f}% | {mediaUsedRAM[notebook_id]:.2f} GB |  {mediaDisc[notebook_id]:.2f}%  |{mediaUsedDisc[notebook_id]:.2f} GB"

                print(mensagem)
                print('\n\n')
        else:
            # Pegando média geral 
            mediaCPU = df['percCPU'].mean()
            mediaRAM = df['percRAM'].mean()
            mediaUsedRAM = df['usedRAM'].mean()
            mediaDisc = df['percDisc'].mean()
            mediaUsedDisc = df['usedDisc'].mean()
            mensagem1 = "CPU Média |  RAM % | RAM Usada | Disco % | Disco Usado "
            mensagem = f"  {mediaCPU:.2f}    | {mediaRAM:.2f}% | {mediaUsedRAM:.2f} GB |  {mediaDisc:.2f}%  |{mediaUsedDisc:.2f} GB"
            print('\n\n')
            print(mensagem1)
            print(mensagem)
            print('\n\n')
            
        continuar = input('Deseja fazer um novo monitoramento? (S/N)')
        continuar = continuar.upper()
        
        #Se o usuario quer continuar ele volta para o menu
        if(continuar == 'S'):
            menu()
        #Se o Usuário quiser sair 
        else:
            print('Obrigado por consultar a RemoteGuard!')  
            cursor.close() #Fechando cursor
            conn.close()   #fechando conexao com o banco de dados
            
            
from datetime import timedelta# importando biblioteca para formatar     
def monitorarGerente():
    global resultado
    tipoMonitoramento = int(input('Deseja monitorar os programas do usuário ou verificar o tempo de inatividade? \n Digite 0 para programas e 1 para inatividade: '))
    if tipoMonitoramento == 0:
                
        query = f"""SELECT p.*,supervisor.nome as 'nome supervisor', f.nome, f.cargo FROM processos as p 
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
        
        column_names = ['idProcesso', 'dataHora', 'nomeProcesso', 'fkNotebook', 'nome supervisor', 'nome', 'cargo']
        df = pd.DataFrame(resultado, columns=column_names) 
        colunaHora = [linha[1] for linha in resultado]
        colunaProcesso = [linha[2] for linha in resultado]
        colunaNomes = [linha[5] for linha in resultado]
        colunaCargo = [linha[6] for linha in resultado]


        if 'Discord.exe' in colunaProcesso:
                posicao = colunaProcesso.index('Discord.exe')
                print(f'O {colunaCargo[posicao]} {colunaNomes[posicao]} começou a usar o {colunaProcesso[posicao]} as {colunaHora[posicao]}')
                
        else:
            print('nada errado')
                
    elif tipoMonitoramento == 1:
            query = f"""SELECT d.*,supervisor.nome as 'nome supervisor', f.nome, f.cargo FROM dados as d 
                JOIN notebook as n
                    ON d.fkNotebook = n.idNotebook
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
            column_names = ['idDados', 'dataHora', 'percCPU', 'tempoInativo', 'percRAM', 'usedRAM', 'percDisc', 'usedDisc', 'fkNotebook', 'nome supervisor', 'nome', 'cargo']
            
            df = pd.DataFrame(resultado, columns=column_names)
            df = df.groupby('fkNotebook')
            for idNotebook, dadosNotebook in df:
                                                #iloc = index location ou seja pega a primeira (0) e ultima (-1) linha de cada funcionário
                primerio_valor = dadosNotebook.iloc[0, 3]
                ultimo_valor = dadosNotebook.iloc[-1, 3]
                print(primerio_valor)
                print(ultimo_valor)
                inatividadeDiaria = round((ultimo_valor - primerio_valor) / 100)
                print(inatividadeDiaria)
                tempo_formatado = str(timedelta(seconds=inatividadeDiaria))

                # Exibe o tempo formatado
                print(tempo_formatado)

            
            
        
    else: 
        print('Valor invalido!')   
        monitorarGerente()
    
            
def menu():
    global resultado
    cargo = resultado[11]
    if cargo == 'analista':   
        
            
        monitorarAnalista()
        
    elif cargo == 'gerente':
        monitorarGerente()
        
    else: 
        print('Os funcionarios não tem permissão para acessar arquivos sensiveis!')        
    
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

def home():
    print("\n\n")
    print(f'Bem vindo à RemoteGuard {resultado[12]}!\n ')
    passouSenha = conferirSenha()
    if(passouSenha): #Passou senha é boolean
        menu()
    else:
        print('Você não tem permissão para acessar nossos dados!')
   

home()
