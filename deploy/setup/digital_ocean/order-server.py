import fileinput
import os
import sys
import time

from deploy.setup.digital_ocean.do_common import create_droplet, get_droplet


def _replace_env_ip(new_ip: str):
    my_path = os.path.abspath(os.path.dirname(__file__))
    local_env_config_file_path = os.path.join(my_path, "../../local/local.env")
    for line in fileinput.input(local_env_config_file_path, inplace=True):
        if line.startswith("SERVER_HOST"):
            line = f'SERVER_HOST="{new_ip}"\n'
        sys.stdout.write(line)


if __name__ == '__main__':
    droplet = create_droplet()
    droplet_id = int(droplet['droplet']['id'])
    print(f"Created droplet #{droplet_id}")

    is_not_available = True
    while is_not_available:
        droplet = get_droplet(droplet_id=droplet_id)
        status = droplet['droplet']['status']
        print(f"Droplet status={status}")
        if status == 'active':
            is_not_available = False
        else:
            time.sleep(3)

    droplet_ip = get_droplet(droplet_id=droplet_id)['droplet']['networks']['v4'][0]['ip_address']
    print(f"Droplet IP: {droplet_ip}")
    _replace_env_ip(new_ip=droplet_ip)

    sleep_timout = 30
    print(f"Sleeping for {sleep_timout} seconds before console will be ready...")
    time.sleep(sleep_timout)
    print("Should be ready!")
