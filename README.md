# Cloud-1 ☁️
![Ansible](https://img.shields.io/badge/Ansible-12.3.0-red)
![Docker](https://img.shields.io/badge/Docker-Automated-blue)
![Infrastructure](https://img.shields.io/badge/Infrastructure-as%20Code-green)
![42 School](https://img.shields.io/badge/42-School-000000)

**Automated deployment of Inception on remote cloud servers**

> Fully automated deployment of a WordPress infrastructure with separate containers for each service, using Ansible for configuration management and Docker for containerization.

---

## ▌Project Overview

This project is inspired by the **Inception** subject and focuses on deploying a complete WordPress site with its necessary Docker infrastructure on cloud instances. The key difference from Inception is the **full automation** of the deployment process using **Ansible**.

The goal is to deploy a production-ready WordPress site where:
- Each process runs in its own container (1 process = 1 container)
- The entire deployment is automated with a single command
- The infrastructure can be deployed on multiple servers in parallel
- All data persists across server reboots
- Services are secure and properly isolated

📘 **42 School DevOps Project**: Automate the deployment of a multi-container WordPress infrastructure on real cloud servers.

> ⚠️ **Important**: This project uses REAL cloud resources. You are responsible for managing costs and stopping unused services.

---

## ▌Features

### ■ Mandatory Requirements

✔️ **Full Automation**: Complete deployment with a single command\
✔️ **Container Isolation**: One process per container (WordPress, MySQL, PHPMyAdmin, etc.)\
✔️ **Multi-Server Deployment**: Deploy to multiple servers in parallel\
✔️ **Data Persistence**: All data survives server reboots (images, users, articles)\
✔️ **Auto-Restart**: Services restart automatically after reboot\
✔️ **Secure Access**: Limited and secure public access (no direct database access)\
✔️ **TLS Support**: HTTPS encryption when possible\
✔️ **URL Routing**: Correct site redirection based on requested URL\
✔️ **Docker Compose**: Uses docker-compose.yml for service orchestration

### ■ Technical Features

✔️ **Ansible Automation**: Infrastructure as Code using Ansible playbooks\
✔️ **Docker Integration**: Automated Docker installation and container management\
✔️ **Database Management**: MySQL setup with automated dump handling\
✔️ **Domain Configuration**: Dynamic domain name configuration via DuckDNS\
✔️ **Environment Management**: Template-based environment configuration\
✔️ **Re-runnable**: Safe to run again; each run rebuilds all images and recreates containers\
✔️ **Modular Architecture**: Separate playbooks for different deployment scenarios\
✔️ **Easy Cleanup**: Complete infrastructure teardown with reset functionality

---

## ▌Infrastructure Architecture

### ■ Container Architecture (1 Process = 1 Container)

The project follows the Inception architecture with separate containers:

| Service | Container | Purpose |
|---------|-----------|---------|
| **WordPress** | wordpress | PHP-FPM running WordPress |
| **MySQL** | mysql (service `db`) | Database backend |
| **Nginx** | nginx | Web server and reverse proxy |
| **PHPMyAdmin** | phpmyadmin | Database management interface |

### ■ Server Configuration

The project can deploy to multiple cloud servers:

| Server | IP Address | Domain | Role |
|--------|------------|--------|------|
| webserver1 | 51.159.150.9 | calbor-p42-cloud.duckdns.org | Primary web server |
| webserver2 | 24.199.120.225 | calbor-p42-cloud2.duckdns.org | Secondary web server |

### ■ Network & Security

- **Container Network**: Internal Docker network for inter-container communication
- **Public Access**: Only Nginx exposed on ports 80/443
- **Database Security**: MySQL not directly accessible from internet
- **TLS/SSL**: HTTPS support via certificates
- **Domain Names**: Free domains via DuckDNS

---

## ▌How it Works

### ■ Ansible Automation

The project uses Ansible playbooks to automate the entire deployment:

1. **System Preparation**
   - Install required packages (curl, make, git)
   - Configure Docker using `geerlingguy.docker` role
   - Set up host file configurations
   - Python must already be installed on the target (no task installs it)

2. **Application Deployment**
   - Clone Inception-based application from GitHub
   - Generate environment configuration from Jinja2 templates
   - Handle database dumps and migrations
   - Replace localhost URLs with production domain names

3. **Container Management**
   - Build Docker images for each service
   - Start containers via docker-compose
   - Configure inter-container networking
   - Set up volume persistence for data
   - Manage container lifecycle and auto-restart

4. **Security Configuration**
   - No firewall rules are set by the playbooks
   - Self-signed TLS certificate generated in the nginx image (app repo)
   - Restrict database access
   - Configure secure environment variables

### ■ Configuration Management

Environment variables are managed through Jinja2 templates (`.env.j2`), allowing dynamic configuration based on:
- Server hostname and IP address
- Domain names (DuckDNS or custom)
- Database credentials (set manually in `conf/.env.j2`)
- WordPress configuration
- Service-specific settings
- TLS/SSL certificate paths

---

## ▌Getting Started

### ■ Requirements

**Local Machine:**
- Python 3.x
- Ansible 12.3.0+
- SSH client
- Git

**Target Servers:**
- Ubuntu 20.04 LTS (or compatible)
- SSH daemon running
- Python installed
- Root access via SSH key
- Minimum 2GB RAM recommended
- Minimum 20GB disk space

**Cloud Provider:**
- Scaleway (recommended, free credits via 42 partnership)
- Or any other provider (AWS, GCP, DigitalOcean, etc.)
- SSH key configured in your profile

> ⚠️ **Cost Warning**: You are responsible for managing cloud resources. Remember to stop unused services to avoid charges!

### ■ Installation

1. Clone the repository

```bash
git clone https://github.com/ai-dg/Cloud-1.git
cd Cloud-1
```

2. Install Python dependencies

```bash
pip install -r requirement.txt
```

3. Install Ansible Galaxy roles

```bash
./init.sh
# or manually:
ansible-galaxy install geerlingguy.docker
```

4. Set up your SSH key

```bash
# Generate SSH key if you don't have one
ssh-keygen -t ed25519 -C "your_email@example.com"

# Add your public key to your 42/Scaleway profile
cat ~/.ssh/id_ed25519.pub
```

5. Request a server from administrators

Contact 42 administrators to provision a server for you. They will provide:
- Server IP address
- SSH connection command: `ssh root@X.X.X.X`

6. Configure inventory

Edit `inventory/inventory.ini` with your server details:

```ini
[webservers]
webserver1 ansible_host=YOUR_SERVER_IP ansible_user=root ansible_port=22 domain_name=your-domain.duckdns.org
webserver2 ansible_host=YOUR_SERVER_IP ansible_user=root ansible_port=22 domain_name=your-domain2.duckdns.org
```

7. Set up a free domain name (optional but recommended)

Get a free domain from:
- [DuckDNS](https://www.duckdns.org/) (recommended)

Update your domain's DNS to point to your server IP.

8. Create the environment template: `cp conf/.env.j2.example conf/.env.j2`, then fill in every value.

---

## ▌Usage Instructions

### ■ Basic Syntax

```bash
make [target]
```

### ■ Available Targets

| Target | Description |
|--------|-------------|
| `make` or `make all` | Deploy to all webservers |
| `make serv1` | Deploy to webserver1 only |
| `make serv2` | Deploy to webserver2 only |
| `make clean` | Remove all deployments and clean up |
| `make dump` | Redeploy from the "Copy dump" task onward (dump, .env, full rebuild) |
| `make config` | Regenerate .env, then rebuild and restart all containers |
| `make connect1` | SSH into webserver1 |
| `make connect2` | SSH into webserver2 |

### ■ Usage Examples

#### 1. First Time Deployment

```bash
# Test SSH connectivity first
ssh root@YOUR_SERVER_IP

# Deploy to all servers
make

# Or deploy to specific server
make serv1
```

#### 2. Verify Deployment

```bash
# Check if services are running
ssh root@YOUR_SERVER_IP "docker ps"

# Access your WordPress site
# Open browser: https://your-domain.duckdns.org
```

#### 3. Update Configuration

```bash
# Regenerate .env files, then rebuild everything
make config
```

#### 4. Update Database

```bash
# Copy and update database dump
make dump
```

#### 5. Redeploy After Changes

```bash
# Full redeployment
make re
```

#### 6. Clean Up (Important!)

```bash
# Remove all deployments to save costs
make clean

# Remember to also stop/destroy your cloud instances
# when you're done to avoid charges!
```

#### 7. Server Access

```bash
# Connect to server 1
make connect1

# Connect to server 2
make connect2

# Or directly via SSH
ssh root@YOUR_SERVER_IP
```

### ■ Manual Ansible Commands

For more control, use Ansible directly:

```bash
# Test connectivity to all servers
ansible all -m ping

# Run full playbook
ansible-playbook ./playbooks/playbook.yaml

# Run specific tasks with tags
ansible-playbook ./playbooks/playbook.yaml --tags "config,build"

# Start from specific task
ansible-playbook ./playbooks/playbook.yaml --start-at-task="Generate .env from template"

# Check mode (dry run - test without making changes)
ansible-playbook ./playbooks/playbook.yaml --check

# Verbose output for debugging
ansible-playbook ./playbooks/playbook.yaml -vvv

# Deploy to specific host only
ansible-playbook ./playbooks/playbook.yaml --limit webserver1
```

---

## ▌Project Structure

```
Cloud-1/
├── ansible.cfg              # Ansible configuration
├── init.sh                  # Initial setup script (install Docker role)
├── Makefile                 # Deployment shortcuts
├── requirement.txt          # Python dependencies
├── en.subject.pdf          # Project subject (42 School)
├── .gitignore              # Git ignore rules
├── .gitmodules             # Git submodules
├── README.md               # This file
├── conf/                   # Configuration files
│   ├── hosts               # System hosts file template
│   └── .env.j2            # Environment template (not in git)
├── inventory/              # Ansible inventory
│   └── inventory.ini      # Server definitions and variables
└── playbooks/              # Ansible playbooks
    ├── playbook.yaml      # Main deployment playbook (all servers)
    ├── serv1.yaml         # Server 1 specific playbook
    ├── serv2.yaml         # Server 2 specific playbook
    └── reset.yaml         # Cleanup playbook (remove everything)
```

### ■ Application Structure (Deployed on Servers)

```
~/cloudI/                    # Cloned from GitHub
├── Makefile                # Docker compose management
├── srcs/                   # Source files
│   ├── docker-compose.yml # Service orchestration
│   ├── .env               # Generated from template
│   └── requirements/      # Service configurations
│       ├── nginx/         # Web server config
│       ├── wordpress/     # WordPress PHP-FPM
│       ├── mysql/         # MySQL database
│       │   └── dump/      # Database dumps
│       ├── grafana/
│       ├── prometheus/
│       └── tools/
└── ...
```

---

## ▌Playbook Details

### ■ Main Playbook (`playbook.yaml`)

Executes the following tasks in order:

1. **Install Dependencies**
   - curl (for downloads and API calls)
   - make (for Makefile execution)
   - git (for repository cloning)

2. **Configure Docker**
   - Uses `geerlingguy.docker` role
   - Installs Docker Engine
   - Installs Docker Compose
   - Configures Docker daemon
   - Enables Docker service auto-start

3. **System Configuration**
   - Copy hosts file to `/etc/hosts`
   - Set proper file permissions (644)
   - Configure hostname resolution

4. **Application Setup**
   - Clone Inception-based repository from GitHub
   - Repository: `git@github.com:ai-dg/Cloud-1-app.git` (SSH, needs a GitHub key on the server; serv1/serv2 clone `https://github.com/ChristopheAlborPirame/cloud-I-app.git`)
   - Destination: `~/cloudI`
   - Includes docker-compose.yml and all service configurations

5. **Database Management**
   - Copy MySQL dump from application directory
   - Replace localhost URLs with production domain name
   - Prepare database for WordPress import
   - Handle URL rewriting for proper site access

6. **Environment Configuration**
   - Generate `.env` file from Jinja2 template
   - Inject server-specific variables:
     - Domain name
     - Database credentials
     - WordPress settings
     - Service ports
     - TLS/SSL configuration

7. **Build and Deploy**
   - Execute `make re` in application directory
   - Build Docker images for each service
   - Start all containers via docker-compose
   - Configure container networking
   - Set up volume persistence
   - Enable auto-restart on reboot

### ■ Reset Playbook (`reset.yaml`)

Cleanup tasks:

1. Stop all containers (`make reset`)
2. Remove application directory (`~/cloudI`)
3. Remove database dump (`~/dump.sql`)

### ■ Server-Specific Playbooks

- `serv1.yaml`: Targets only webserver1
- `serv2.yaml`: Targets only webserver2

Both use the same tasks as the main playbook with different host groups; they clone the app from `ChristopheAlborPirame/cloud-I-app` instead of `ai-dg/Cloud-1-app`.

---

## ▌Configuration

### ■ Inventory Configuration

The `inventory/inventory.ini` file defines server groups and variables:

```ini
[webservers]
webserver1 ansible_host=51.159.150.9 ansible_user=root ansible_port=22 domain_name=calbor-p42-cloud.duckdns.org
webserver2 ansible_host=24.199.120.225 ansible_user=root ansible_port=22 domain_name=calbor-p42-cloud2.duckdns.org

[serv1]
webserver1 ansible_host=51.159.150.9 ansible_user=root ansible_port=22 domain_name=calbor-p42-cloud.duckdns.org

[serv2]
webserver2 ansible_host=24.199.120.225 ansible_user=root ansible_port=22 domain_name=calbor-p42-cloud2.duckdns.org
```

**Variables explained:**
- `ansible_host`: Server IP address
- `ansible_user`: SSH user (must be root)
- `ansible_port`: SSH port (default 22)
- `domain_name`: Your domain (DuckDNS or custom)

### ■ Ansible Configuration

The `ansible.cfg` file specifies:

```ini
[defaults]
inventory = inventory/inventory.ini
```

### ■ Environment Template

⚠️ **IMPORTANT**: Le fichier `conf/.env.j2` n'est pas versionné : copiez `conf/.env.j2.example` vers `conf/.env.j2` et remplissez-le. **VOUS DEVEZ CHANGER TOUS LES MOTS DE PASSE** avant le déploiement en production!

Le fichier `conf/.env.j2` contient les variables d'environnement nécessaires:

```bash
# MySQL/MariaDB Configuration
MYSQL_ROOT_PASSWORD=SecureRootPass123!      # ⚠️ CHANGEZ CE MOT DE PASSE!
MYSQL_USER=wordpress_user
MYSQL_DATABASE=wordpress_db
MYSQL_PASSWORD=SecureUserPass456!           # ⚠️ CHANGEZ CE MOT DE PASSE!

# PHPMyAdmin Configuration
PMA_ABSOLUTE_URI=https://{{ domain_name }}/phpmyadmin/

# Grafana Configuration
GRAFANA_USER_NAME=admin
GRAFANA_PWD=SecureGrafanaPass789!           # ⚠️ CHANGEZ CE MOT DE PASSE!

# Domain Configuration
DOMAIN_NAME={{ domain_name }}
```

**Variables Jinja2 disponibles:**
- `{{ domain_name }}`: Injecté depuis l'inventaire Ansible
- Autres variables peuvent être ajoutées dans `inventory/inventory.ini`

**Fichier exemple:**
Un fichier `conf/.env.j2.example` est fourni comme référence avec des valeurs vides.

**Sécurité:**
- ✅ Le fichier `.env.j2` est dans `.gitignore` (ne sera pas commité)
- ✅ Utilisez des mots de passe forts et uniques
- ✅ Ne partagez jamais vos mots de passe réels
- ✅ Changez les mots de passe par défaut avant le déploiement

---

## ▌Dependencies

### ■ Python Packages

```
ansible==12.3.0
ansible-core==2.19.5
cffi==2.0.0
cryptography==46.0.3
Jinja2==3.1.6
MarkupSafe==3.0.3
packaging==25.0
pycparser==2.23
PyYAML==6.0.3
resolvelib==1.2.1
```

### ■ Ansible Galaxy Roles

- `geerlingguy.docker`: Docker installation and configuration

---

## ▌Troubleshooting

### ■ Common Issues

**SSH Connection Failed**
```bash
# Check SSH connectivity
ssh root@YOUR_SERVER_IP

# Verify SSH key is added to ssh-agent
ssh-add -l

# Add your key if needed
ssh-add ~/.ssh/id_ed25519

# Test with verbose output
ssh -v root@YOUR_SERVER_IP
```

**Server Not Provisioned**
```bash
# Contact 42 administrators to request a server
# Ensure you've added your SSH public key to your profile
# Wait for server provisioning confirmation
```

**Docker Installation Failed**
```bash
# Manually install Docker role
ansible-galaxy install geerlingguy.docker --force

# Check role installation
ansible-galaxy list

# Verify target server has Python
ssh root@YOUR_SERVER_IP "python3 --version"
```

**Playbook Execution Failed**
```bash
# Run with verbose output
ansible-playbook ./playbooks/playbook.yaml -vvv

# Check syntax
ansible-playbook ./playbooks/playbook.yaml --syntax-check

# Dry run (test without changes)
ansible-playbook ./playbooks/playbook.yaml --check

# Check if server is reachable
ansible all -m ping
```

**Containers Not Starting**
```bash
# SSH into server and check
ssh root@YOUR_SERVER_IP

# Check Docker status
docker ps -a

# Check logs
docker compose -f ~/cloudI/srcs/docker-compose.yml logs

# Restart containers
cd ~/cloudI && make re
```

**Website Not Accessible**
```bash
# Check if Nginx is running
ssh root@YOUR_SERVER_IP "docker ps | grep nginx"

# Check firewall rules
ssh root@YOUR_SERVER_IP "ufw status"

# Verify domain DNS points to server IP
nslookup your-domain.duckdns.org

# Check if ports are open
telnet YOUR_SERVER_IP 80
telnet YOUR_SERVER_IP 443
```

**Database Connection Issues**
```bash
# Check MySQL container
ssh root@YOUR_SERVER_IP "docker ps | grep mysql"

# Check database logs
ssh root@YOUR_SERVER_IP "docker logs mysql"

# Verify .env file has correct credentials
ssh root@YOUR_SERVER_IP "cat ~/cloudI/srcs/.env"
```

### ■ Debugging

```bash
# Test connectivity to all hosts
ansible all -m ping

# Check gathered facts
ansible webservers -m setup

# Run specific task with tags
ansible-playbook ./playbooks/playbook.yaml --tags "config" -vvv

# Check what would change (dry run)
ansible-playbook ./playbooks/playbook.yaml --check --diff
```

### ■ Server Monitoring

```bash
# Check server resources
ssh root@YOUR_SERVER_IP "df -h"  # Disk space
ssh root@YOUR_SERVER_IP "free -h"  # Memory
ssh root@YOUR_SERVER_IP "top"  # CPU usage

# Check Docker resource usage
ssh root@YOUR_SERVER_IP "docker stats"
```

---

## ▌Best Practices

### ■ Security

- ✅ Use SSH keys instead of passwords (mandatory)
- ✅ Keep `.env.j2` and sensitive files out of version control
- ✅ Use Ansible Vault for sensitive data in playbooks
- ✅ Never commit credentials to GitHub or public repos
- ✅ Regularly update dependencies and Docker images
- ✅ Configure firewall rules (ufw) on servers
- ✅ Use strong passwords for database and WordPress admin
- ✅ Enable HTTPS/TLS for production sites
- ✅ Restrict database access to internal network only

### ■ Cost Management (CRITICAL!)

- ⚠️ **Stop unused servers immediately** to avoid charges
- ⚠️ **Monitor your cloud provider dashboard** regularly
- ⚠️ **Use smallest server size** that meets requirements
- ⚠️ **Destroy servers** when marking project as complete
- ⚠️ **Set up billing alerts** if available
- ⚠️ **Never leave services running** after evaluation
- ⚠️ **Check free tier limits** before deploying
- ⚠️ **You are responsible** for all charges incurred

### ■ Deployment

- ✅ Test SSH connectivity before running playbooks
- ✅ Use `--check` mode for dry runs
- ✅ Keep playbooks idempotent (safe to run multiple times)
- ✅ Tag tasks for selective execution
- ✅ Document custom variables and configurations
- ✅ Test on one server before deploying to multiple
- ✅ Verify all containers are running after deployment
- ✅ Check website accessibility after deployment

### ■ Maintenance

- ✅ Regular backups of database dumps
- ✅ Monitor server resources (disk, memory, CPU)
- ✅ Keep Docker images updated
- ✅ Review container logs regularly
- ✅ Test rollback procedures
- ✅ Document any manual changes made to servers
- ✅ Keep inventory file updated with current IPs

---

## ▌Advanced Usage

### ■ Custom Variables

Pass variables at runtime:

```bash
ansible-playbook ./playbooks/playbook.yaml -e "domain_name=custom-domain.com"
```

### ■ Limit Execution

Run on specific hosts:

```bash
ansible-playbook ./playbooks/playbook.yaml --limit webserver1
```

### ■ Tags

Available tags:
- `dump`: Database operations
- `config`: Environment configuration
- `build`: Application build and deployment

```bash
ansible-playbook ./playbooks/playbook.yaml --tags "config,build"
```

---

## ▌Technical Details

### ■ Architecture Decisions

- **Ansible over other tools**: Agentless, Python-based, extensive module library
- **Docker containers**: Isolation, portability, easy scaling
- **Makefile shortcuts**: Simplified common operations
- **Template-based config**: Environment-specific settings without code changes
- **Git-based deployment**: Version control and easy rollbacks

### ■ Code Quality

- Follows Ansible best practices
- Idempotent playbook design
- Clear task naming and documentation
- Modular playbook structure
- Proper error handling

---

## ▌Important Notes

### ■ Cloud Provider Considerations

**Using Scaleway (Recommended):**
- Free credits provided through 42 partnership
- Request server from 42 administrators
- Server provisioned when you sign up for project
- Server destroyed when project marked complete
- All data lost when server destroyed

**Using Other Providers:**
- AWS, GCP, DigitalOcean, etc. are allowed
- Check free tier eligibility carefully
- You may be billed for usage
- Read terms of service thoroughly
- Monitor usage to stay within free limits

### ■ Server Lifecycle

1. **Provisioning**: Request server from administrators
2. **Deployment**: Run Ansible playbooks to set up infrastructure
3. **Evaluation**: Server available during peer corrections
4. **Destruction**: Server destroyed when project completed
5. **Data Loss**: All data on server is permanently deleted

> ⚠️ **Warning**: Back up any important data before marking project as complete!

### ■ Domain Names

**Free Options:**
- [DuckDNS](https://www.duckdns.org/) - Free subdomains (recommended)

---

## ▌Future Enhancements

Potential improvements:

- [ ] Add alerting on top of the existing Prometheus/Grafana containers
- [ ] Implement automated backups
- [ ] Add SSL/TLS certificate management (Let's Encrypt)
- [ ] Create CI/CD pipeline integration
- [ ] Add health checks and auto-recovery
- [ ] Implement blue-green deployments
- [ ] Add load balancer configuration
- [ ] Create development environment playbook

---

## 📚 Documentation

### Corrections récentes (Janvier 2025):

✅ **Fichier .env.j2.example créé** - Template Jinja2 pour les variables d'environnement\
✅ **Installation de Git ajoutée** - Correction des playbooks Ansible\
✅ **URLs corrigées** - Standardisation avec `https://{{ domain_name }}`\
✅ **Makefile corrigé** - Référence de tâche mise à jour\
✅ **Dockerfiles optimisés** - Meilleure utilisation du cache Docker\
✅ **Port 80 ajouté** - Redirection HTTP → HTTPS fonctionnelle\
✅ **Pas de secrets en dur** - Conformité aux exigences de sécurité

---

## 📜 License

This project was completed as part of the **42 School** curriculum.\
It is intended for **academic purposes only** and follows the evaluation requirements set by 42.

Unauthorized public sharing or direct copying for **grading purposes** is discouraged.\
If you wish to use or study this code, please ensure it complies with **your school's policies**.

---

## 🤝 Contributing

This is an educational project. If you're working on a similar assignment:
- Use this as a reference, not a direct copy
- Understand each component before implementing
- Follow your school's academic integrity policies

---

## 📞 Support

For issues or questions:
1. Check the troubleshooting section
2. Review Ansible documentation
3. Consult the 42 School subject PDF
4. Ask your peers (within academic guidelines)

---

**Built with ❤️ for 42 School Cloud-1 Project**
