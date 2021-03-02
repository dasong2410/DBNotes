# WSL

### Eanble WSL

- https://docs.microsoft.com/en-us/windows/wsl/install-win10

### Export and Import WSL Linux Distro

- https://winaero.com/blog/export-import-wsl-linux-distro-windows-10/

### Add the non-root user

- https://superuser.com/questions/1515246/how-to-add-second-wsl2-ubuntu-distro-fresh-install/1531220#1531220

### Convert between wsl1 and wsl2

	wsl --set-version <Distro> 1
	wsl --set-version <Distro> 2

### Shutdown

	wsl --shutdown <Distro>

### Set default version

	wsl --set-default-version 2

### Commands

	wsl --list --all
	wsl --list --running
	wsl --list --verbose

### Zsh

need to install powerline fonts with PowerShell in windows

- https://ohmyz.sh/
- https://github.com/ohmyzsh/ohmyzsh
- https://github.com/powerline/fonts
- https://blog.nillsf.com/index.php/2020/02/17/setting-up-wsl2-windows-terminal-and-oh-my-zsh/


### Export & Import

```cmd
wsl --export Ubuntu-20.04-Docker "D:\Ubuntu-20.04-Docker.tar"
wsl --unregister Ubuntu-20.04-Docker
wsl --import Ubuntu-20.04-Docker "D:\WSL\Ubuntu-20.04-Docker" "D:\Ubuntu-20.04-Docker.tar" --version 2

wsl --export docker-desktop-data "D:\docker-desktop-data.tar"
wsl --unregister docker-desktop-data
wsl --import docker-desktop-data "D:\WSL\docker\wsl\data" "D:\docker-desktop-data.tar" --version 2
```
