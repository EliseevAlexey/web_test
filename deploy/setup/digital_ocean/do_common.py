import json
import os

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


def _get_ssh_key_id() -> int:
    ssh_keys = _list_ssh_keys()['ssh_keys']
    if len(ssh_keys) == 0:
        raise "Please add ssh key"
    if len(ssh_keys) > 1:
        raise "There are more than one SSH key. Don't know which to choose"
    return ssh_keys[0]['id']


def create_droplet(
        region: str = REGION,
        image: str = UBUNTU_IMAGE,
        size: str = _2GB_1CPU_SIZE,
) -> dict:
    ssh_key_id = _get_ssh_key_id()

    # https://docs.digitalocean.com/reference/api/api-reference/
    content = {
        "name": f"{image}-{region}",
        "size": size,
        "region": region,
        "image": image,
        "ssh_keys": [ssh_key_id],
    }
    print(f"Ordering server with: {content}")
    return requests.post(url=DROPLETS_API_URL, headers=HEADERS, data=json.dumps(content)).json()


def _list_ssh_keys() -> dict:
    return requests.get(url=SSH_KEYS_API_URL, headers=HEADERS).json()


def get_droplet(droplet_id: int) -> dict:
    return requests.get(url=f"{DROPLETS_API_URL}/{droplet_id}", headers=HEADERS).json()
