import shutil
import os

# Copy Zabbix agent 2 binary to the dir with this Python file before use and set all the config variables below.
# Run this Python script to generate start.bat file.
# Run the start.bat file.
# Stop the agents with stop.bat or stop_force.bat if needed.

########## config variables ##########

agent2_path='zabbix_agent2.exe'
config_reference='zabbix_agent2.win.conf'
config_dir='conf'
log_dir='log'
server='192.168.56.201'
server_active=server

# number of agents to start
num_agents=15
# start interval in seconds between agents
start_interval=1

########## functions ##########

def create_agent_config(config_path, n, listen_port): 
    # Copy the original reference file
    shutil.copy2(config_reference, config_path)

    # Append the custom values
    with open(config_path, 'a') as cfg:
        cfg.write(f'\nListenPort={listen_port}\n')
        cfg.write(f'LogFile=log\\zabbix_agentd_{n:03d}.log\n')
        cfg.write(f'Server={server}\n')
        cfg.write(f'ServerActive={server_active}\n')

########## script starts from here ##########

with open('start.bat', 'w') as start_script:
    start_script.write(f'rmdir /s /q {config_dir}\n')
    start_script.write(f'rmdir /s /q {log_dir}\n')
    start_script.write(f'mkdir {config_dir}\n')
    start_script.write(f'mkdir {log_dir}\n\n')

    for n in range(num_agents):
        # txt1 = "My name is {fname}, I'm {age}".format(fname = "John", age = 36)
        config_path = os.path.join(config_dir, f'zabbix_agent2_{n:03d}.win.conf')
        
        start_script.write(f'start {agent2_path} --config {config_path} --foreground\n')
        start_script.write(f'echo Starting agent {n}\n')
        start_script.write(f'timeout /t {start_interval} /nobreak >nul\n\n')

        with open(config_path, 'w') as conf_file:
            # default port 10050
            create_agent_config(config_path, n, 10150 + n)
