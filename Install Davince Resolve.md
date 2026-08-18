# Instalação do Davince Resolve studio

### Instalar resolve studio

decida qual versão usar e baixe

```
21.0.2

20.3.2

18.6.5
```

Site download  
https://www.blackmagicdesign.com/support/

### Instale pulando requisitos

```
sudo apt install unzip
```

```
cd ~/Downloads
```

```
unzip DaVinci_Resolve_Studio_18.6.5_Linux.zip
```

```
chmod +x DaVinci_Resolve_Studio_18.6.5_Linux.run
```

```
sudo SKIP_PACKAGE_CHECK=1 ./DaVinci_Resolve_Studio_18.6.5_Linux.run
```

### Resolver bibliotecas faltando

```
cd /opt/resolve/libs  
```

```
sudo mkdir disabled-libraries
```

```
sudo mv libglib* libgio* libgmodule* disabled-libraries
```

##### 

##### Problema 1. Iniciar com Nvidia em notebooks com que tem placa integrada e dedicada Nvidia

```
__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia __VK_LAYER_NV_optimus=NVIDIA_only /opt/resolve/bin/resolve
```

##### problema 2. Resolver áudio não saindo pelo fones de ouvido

######   
verifique qual provedor de audio do teu sistema

```
pactl info | grep "Server Name"
```

PipeWire: pipewire-alsa

PulseAudio: pulseaudio-alsa

```
sudo apt install pipewire-alsa
```

```
sudo apt install pulseaudio-alsa
```

###### verifica e instala automaticamente

```
if pactl info 2>/dev/null | grep -qi "pipewire"; then sudo apt install pipewire-alsa; elif pactl info 2>/dev/null | grep -qi "pulseaudio"; then sudo apt install pulseaudio-alsa; else echo "PipeWire/PulseAudio não detectado"; fi
```

## Magica

### Davinci resolve 21.0.2 studio

################################################################

```
cd /opt/resolve

sudo perl -pi -e 's/\\x03\\x00\\x89\\x45\\xFC\\x83\\x7D\\xFC\\x00\\x74\\x11\\x48\\x8B\\x45\\xC8\\x8B/\\x03\\x00\\x89\\x45\\xFC\\x83\\x7D\\xFC\\x00\\xEB\\x11\\x48\\x8B\\x45\\xC8\\x8B/g' bin/resolve

sudo perl -pi -e 's/\\x74\\x11\\x48\\x8B\\x45\\xC8\\x8B\\x55\\xFC\\x89\\x50\\x58\\xB8\\x00\\x00\\x00/\\xEB\\x11\\x48\\x8B\\x45\\xC8\\x8B\\x55\\xFC\\x89\\x50\\x58\\xB8\\x00\\x00\\x00/g' bin/resolve

sudo perl -0777 -pi -e 's/\\x74(.\\xBF\\x16\\x00\\x00\\x00\\xBE.\\x01\\x00\\x00\\xE8..\\x05)/\\x75$1/g' bin/resolve

sudo mkdir -p .license

echo -e "LICENSE blackmagic davinciresolvestudio 999999 permanent uncounted\\n hostid=ANY issuer=CGP customer=CGP issued=28-dec-2023\\n akey=0000-0000-0000-0000 \_ck=00 sig="00"" | sudo tee .license/blackmagic.lic
```

### davinci resolve 20.3.2 studio

```
cd /opt/resolve
sudo perl -pi -e 's/\x03\x00\x89\x45\xFC\x83\x7D\xFC\x00\x74\x11\x48\x8B\x45\xC8\x8B/\x03\x00\x89\x45\xFC\x83\x7D\xFC\x00\xEB\x11\x48\x8B\x45\xC8\x8B/' bin/resolve
sudo perl -pi -e 's/\x74\x11\x48\x8B\x45\xC8\x8B\x55\xFC\x89\x50\x58\xB8\x00\x00\x00/\xEB\x11\x48\x8B\x45\xC8\x8B\x55\xFC\x89\x50\x58\xB8\x00\x00\x00/' bin/resolve
sudo perl -pi -e 's/\x41\xb6\x01\x84\xc0\x0f\x84\xb0\x00\x00\x00\x48\x85\xdb\x74\x08\x45\x31\xf6\xe9\xa3\x00\x00\x00/\x41\xb6\x00\x84\xc0\x0f\x84\xb0\x00\x00\x00\x48\x85\xdb\x74\x08\x45\x31\xf6\xe9\xa3\x00\x00\x00/' bin/resolve
echo -e "LICENSE blackmagic davinciresolvestudio 999999 permanent uncounted\nhostid=ANY issuer=CGP customer=CGP issued=28-dec-2023\nakey=0000-0000-0000-0000 _ck=00 sig="00"" | sudo tee .license/blackmagic.lic
```

### davinci resolve 18.6.5 studio

```
sudo perl -pi -e 's/\x00\x85\xc0\x74\x7b\xe8/\x00\x85\xc0\xEB\x7b\xe8/g' /opt/resolve/bin/resolve
```

### Criar pasta dos plugins e colocar o plugin ffmpeg

```
sudo mkdir -p /opt/resolve/IOPlugins/ffmpeg_encoder_plugin.dvcp.bundle/Contents/Linux-x86-64/
```

```
sudo chown -R 1000:1000 /opt/resolve/IOPlugins/
```

```
sudo cp ffmpeg_encoder_plugin.dvcp \
/opt/resolve/IOPlugins/ffmpeg_encoder_plugin.dvcp.bundle/Contents/Linux-x86-64/
```
