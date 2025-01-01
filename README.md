# Aapanel Docker Compose

**Updated for Ubuntu 22.04**

## Available Image Tags

- **Clean**: `antonio24073/aapanel-ubuntu-22-04-sysbox`  
- **Apache**: `antonio24073/aapanel-ubuntu-22-04-sysbox-apache`  
- **Nginx**: `antonio24073/aapanel-ubuntu-22-04-sysbox-nginx`  
- **OpenLiteSpeed**: `antonio24073/aapanel-ubuntu-22-04-sysbox-ols`  
- **Mail**: `antonio24073/aapanel-ubuntu-22-04-sysbox-mail`  

---

## Prerequisites

### Install Sysbox  
Follow the installation guide for Docker Sysbox: [Sysbox Installation Help](https://github.com/antonio24073/aapanel-ubuntu-22-04-sysbox/tree/main/docs)

---

## Configuration

1. Rename `.env.example` to `.env`.  
2. Modify the variables in the `.env` file as needed.  

---

## Usage

### Build and Run  
Execute the following commands:  
```bash
make build  
make mkdir  
make up  
make perm  
make bt  
```

### Save Aapanel Changes  
To commit changes to the Docker image:  
```bash
make commit  
```

### Stop and Remove  
To stop and remove the container:  
```bash
make rm  
```  
**Note:** If you want to run `make up` again, ensure you execute `make rm` first.  

---

## Additional Resources  
- [Docker Hub Repository](https://hub.docker.com/r/antonio24073/aapanel)  
- [Updater Github Repository](https://github.com/antonio24073/aapanel-updater)
