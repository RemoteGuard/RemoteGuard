import psutil
import time
# import mysql.connector


# database = mysql.connector.connect(
#     host = "localhost",
#     user = "root",
#     password = "cihatimh",
#     database = "RemoteGuard"
    
# )


tempo = int(input("Digite a quantidade de tempo que você quer capturar: (intervalo...)"))
print("Iniciando captura... \n")
while True:

    print("\n")

    cpuPerc = psutil.cpu_percent()

    cpuTime = psutil.cpu_times()

    memory = psutil.virtual_memory()
    
    memoria_formatada = round(memory.free/(1024**3),2)

    print(f"Medição de porcentagem da CPU: {cpuPerc} %")
    print("Medição do tempo de uso da CPU")
    print(f"Sistema: {cpuTime.system} segundos")
    print(f"Usuário: {cpuTime.user} segundos")
    print(f"Ociosidade: {cpuTime.idle} segundos")
    print("\n")

    print(f"Memoria RAM livre: {memoria_formatada} GB ")
    print("\n")

    # bancoQuery = database.cursor()
    # sql = "INSERT INTO dados (idDados, processador, RAM, dataHora, fkNotebook) VALUES (default, %s, %s, current_timestamp(), 3)"
    # valores = (cpuFreq.current/1000, memoria_formatada)
    # bancoQuery.execute(sql, valores)
    
    # database.commit()

    time.sleep(tempo)