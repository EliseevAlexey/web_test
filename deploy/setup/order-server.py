import fileinput
import json
import os
import sys
import time

import requests

UBUNTU_IMAGE = "ubuntu-22-10-x64"
_2GB_1CPU_SIZE = "s-1vcpu-2gb"
REGION = "nyc1"
VPC_UUID = "b7bce3c3-dc84-11e8-8650-3cfdfea9f8c8"

DIGITAL_OCEAN_TOKEN = os.environ['DIGITAL_OCEAN_TOKEN']  # https://cloud.digitalocean.com/account/api/tokens?i=8f0315
DROPLETS_API_URL = "https://api.digitalocean.com/v2/droplets"
SSH_KEYS_API_URL = "https://api.digitalocean.com/v2/account/keys"
HEADERS = {
    "Content-Type": "application/json",
    'Authorization': f"Bearer {DIGITAL_OCEAN_TOKEN}",
}


def _create_droplet(
        region: str = REGION,
        image: str = UBUNTU_IMAGE,
        size: str = _2GB_1CPU_SIZE,
        vpc_uuid: str = VPC_UUID,
) -> dict:
    ssh_key_id = _get_ssh_key_id()

    # https://docs.digitalocean.com/reference/api/api-reference/
    content = {
        "name": f"{image}-{region}",
        "size": size,
        "region": region,
        "image": image,
        "ssh_keys": [ssh_key_id],
        # "vpc_uuid": vpc_uuid
    }
    print(f"Ordering server with: {content}")
    return requests.post(url=DROPLETS_API_URL, headers=HEADERS, data=json.dumps(content)).json()


def _list_ssh_keys() -> dict:
    return requests.get(url=SSH_KEYS_API_URL, headers=HEADERS).json()


def _get_ssh_key_id() -> int:
    ssh_keys = _list_ssh_keys()['ssh_keys']
    if len(ssh_keys) == 0:
        raise "Please add ssh key"
    if len(ssh_keys) > 1:
        raise "There are more than one SSH key. Don't know which to choose"
    return ssh_keys[0]['id']


def _get_droplet(droplet_id: int) -> dict:
    return requests.get(url=f"{DROPLETS_API_URL}/{droplet_id}", headers=HEADERS).json()


def _get_droplet_status(droplet_id: int) -> str:
    return _get_droplet(droplet_id=droplet_id)['droplet']['status']


def _replace_env_ip(new_ip: str):
    my_path = os.path.abspath(os.path.dirname(__file__))
    local_env_config_file_path = os.path.join(my_path, "../local/local.env")
    for line in fileinput.input(local_env_config_file_path, inplace=True):
        if line.startswith("SERVER_HOST"):
            line = f'SERVER_HOST="{new_ip}"\n'
        sys.stdout.write(line)


if __name__ == '__main__':
    droplet = _create_droplet()
    droplet_id = int(droplet['droplet']['id'])
    print(f"Created droplet #{droplet_id}")

    is_not_available = True
    while is_not_available:
        droplet = _get_droplet(droplet_id=droplet_id)
        status = droplet['droplet']['status']
        print(f"Droplet status={status}")
        if status == 'active':
            is_not_available = False
        else:
            time.sleep(3)

    droplet_ip = _get_droplet(droplet_id=droplet_id)['droplet']['networks']['v4'][0]['ip_address']
    print(f"Droplet IP: {droplet_ip}")
    _replace_env_ip(new_ip=droplet_ip)

    sleep_timout = 30
    print(f"Sleeping for {sleep_timout} seconds before console will be ready...")
    time.sleep(sleep_timout)
    print("Should be ready!")
