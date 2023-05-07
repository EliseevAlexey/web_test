import os

import requests

DIGITAL_OCEAN_TOKEN = os.environ['DIGITAL_OCEAN_TOKEN']  # https://cloud.digitalocean.com/account/api/tokens?i=8f0315
DROPLETS_API_URL = "https://api.digitalocean.com/v2/droplets"
SSH_KEYS_API_URL = "https://api.digitalocean.com/v2/account/keys"
HEADERS = {
    "Content-Type": "application/json",
    'Authorization': f"Bearer {DIGITAL_OCEAN_TOKEN}",
}


def _delete_droplet(droplet_id: int) -> None:
    response = requests.delete(url=f"{DROPLETS_API_URL}/{droplet_id}", headers=HEADERS)
    print(f"Delete #{droplet_id} droplet status code: {response.status_code}")


def _get_droplet_id() -> int:
    cur_path = os.path.abspath(os.path.dirname(__file__))
    local_env_config_file_path = os.path.join(cur_path, "../local/local.env")
    with open(local_env_config_file_path) as file:
        while line := file.readline():
            if line.startswith("DROPLET_ID"):
                return int(line.replace("DROPLET_ID=", ""))

    return -1


if __name__ == '__main__':
    droplet_id = _get_droplet_id()
    _delete_droplet(droplet_id=droplet_id)
