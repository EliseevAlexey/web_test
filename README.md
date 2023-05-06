# Web application example

# Setup
### 1. Order the Server

#### 1.a Using script
1. Set `DIGITAL_OCEAN_TOKEN` environment variable from [Digital Ocean token](https://cloud.digitalocean.com/account/api/tokens/new?i=8f0315)
2. Run `python3 ./deploy/setup/order-server.py`


#### 1.b or Manually:
https://cloud.digitalocean.com/droplets/new
Example:  
- Create Droplet:
  - Choose region: `New York`
  - OS: `Ubuntu`
  - Version: `22.10 x64`
  - Droplet Type: `Basic`
  - CPU options: `Regular`
  - `2 GB / 1 cpu; 50 GB SSD; 2TB transfer`
  - Add or check SSH Key
  - Click `Create Droplet`
- Wait till creation
  - Wait till droplet will be green
  - Click `Console` button
  - Wait till it is fully loaded - this mean that the Server is ready
- Set the `SERVER_HOST` environment variable in `./deploy/local/local.env'

### 2. Install & configure the server application
- Run `./deploy/setup/init.sh`

# CI/CD
- To commit code and deploy run `./deploy/local/push.sh`
