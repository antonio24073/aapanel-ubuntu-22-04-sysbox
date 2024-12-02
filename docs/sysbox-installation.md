# Sysbox Instalation

For host with ubuntu 22.04:

Sysbox is needed to nested docker containers. 

> Source: [https://github.com/nestybox/sysbox/blob/master/docs/user-guide/install-package.md](https://github.com/nestybox/sysbox/blob/master/docs/user-guide/install-package.md)

From the beginning:

```sh
wget https://downloads.nestybox.com/sysbox/releases/v0.6.5/sysbox-ce_0.6.5-0.linux_amd64.deb
sha256sum sysbox-ce_0.6.5-0.linux_amd64.deb
docker rm $(docker ps -a -q) -f
sudo apt-get install jq
```

The official documentation says:
```
sudo apt-get install ./sysbox-ce_0.6.5-0.linux_amd64.deb
```

But if get an error do:
```
sudo dpkg -i ./sysbox-ce_0.6.5-0.linux_amd64.deb
```

After these previous steps present in the sysbox docs, you need to do:

```sh
sudo systemctl start sysbox
```

Enable if do you want to start this service with the system startup.

```sh
sudo systemctl enable sysbox
```

Check if all the sub-services is started:
```sh
sudo systemctl status sysbox -n20
```

```
sudo mkdir /etc/docker
```

Create a file named  `/etc/docker/daemon.json` or add inside it.
```json
{
   "runtimes": {
      "sysbox-runc": {
         "path": "/usr/bin/sysbox-runc"
      }
   }
}
```

```sh
sudo systemctl restart docker
```

