📘 MiSpeakerNetworkMod

MiSpeakerNetworkMod transforme une enceinte Xiaomi basée sur un firmware OpenWrt modifié en un système audio multi‑sources, stable, modulaire et contrôlable via une WebUI, des boutons physiques ou des API externes. 
Wifiradio a été partiellement installé au préalable.

Le projet fournit :
    un Audio Manager capable de basculer proprement entre plusieurs sources audio
    des services init.d pour Spotify, Bluetooth, Line‑In et DLNA
    une WebUI simple pour contrôler l’enceinte
    un binaire librespot ARMv7 pré‑compilé
    une structure claire pour le développement et l’installation

Ce projet est spécifique à cette enceinte Xiaomi et n’est pas destiné à être universel.

🧱 Environnement matériel

L’enceinte Xiaomi ciblée utilise :
    CPU : ARMv7 Cortex‑A9
    RAM : 256–512 MB
    Stockage : eMMC interne
    OS : OpenWrt modifié par Xiaomi
    Audio : ALSA + pipeline propriétaire
    Bluetooth : Broadcom BSA (bsa_server, mibt_ble)
    DLNA : renderer propriétaire (/usr/bin/dlna)
    Entrée Line‑In : capture + playback ALSA
    Boutons physiques : exposés via /dev/input/eventX

⚠️ Contraintes importantes

Ce projet doit respecter plusieurs contraintes strictes liées à l’environnement Xiaomi :
✔ 1. Binaire ARMv7 spécifique

Le binaire librespot fourni est compilé pour :
    ARMv7
    glibc 2.19
    ALSA Xiaomi
    Rust ancien
    toolchain custom

Il ne fonctionnera pas sur d’autres appareils.
✔ 2. Services gérés par procd (OpenWrt)

Tous les services audio doivent être :
    dans /etc/init.d/
    compatibles /etc/rc.common
    déclarés avec USE_PROCD=1
    capables de respawn

✔ 3. Une seule source audio active à la fois

Le système audio Xiaomi ne supporte pas le mixage.
Le Audio Manager garantit :
Code

STOP all sources → START selected source

✔ 4. Chemins stricts
    Binaire librespot → /usr/local/bin/librespot
    Manager → /opt/audio-system/manager/
    WebUI → /opt/audio-system/webui/
    Boutons → /opt/audio-system/buttons/

✔ 5. Pas de compilation sur l’enceinte

Le CPU et l’environnement ne permettent pas de compiler Rust ou librespot.
Tous les binaires doivent être fournis pré‑compilés.
📁 Structure du projet
Code

MiSpeakerNetworkMod/
│
├── bin/
│   └── librespot_armv7_xiaomi
│
├── services/
│   ├── spotify/
│   │   └── init.d/spotify
│   ├── bluetooth/
│   │   └── init.d/bluetooth
│   ├── linein/
│   │   └── init.d/linein
│   └── dlnainit/
│       └── init.d/dlnainit
│
├── manager/
│   ├── audio_manager.sh
│   └── state.json.example
│
├── webui/
│   ├── app.py
│   ├── templates/
│   │   └── index.html
│   └── static/
│       └── style.css
│
├── buttons/
│   └── buttons.py
│
├── install/
│   ├── install.sh
│   └── uninstall.sh
│
└── README.md

🎛️ Sources audio supportées
Source	Service	Description
Spotify	spotify	Spotify Connect via librespot ARMv7
Bluetooth	bluetooth	A2DP via Broadcom BSA
Line‑In	linein	Entrée jack analogique
DLNA	dlnainit	Renderer DLNA Xiaomi
🔧 Audio Manager

Le cœur du système :
/opt/audio-system/manager/audio_manager.sh

Fonctions :
    stoppe toutes les sources
    démarre la source demandée
    met à jour state.json
    utilisé par la WebUI, les boutons, Home Assistant

Exemple :
Code

audio_manager.sh spotify
audio_manager.sh bluetooth
audio_manager.sh linein
audio_manager.sh dlnainit

🌐 WebUI

Accessible via :
Code

http://IP_DE_L_ENCEINTE:8080

Fonctions :
    sélection de la source
    affichage de la source active
    API REST simple

🔘 Boutons physiques

Les boutons de l’enceinte sont lus via /dev/input/eventX.
Un daemon Python permet de :
    changer de source
    contrôler la lecture
    ajouter des actions personnalisées

📦 Installation

Un script install.sh copie automatiquement :
    les services init.d
    le manager
    la WebUI
    les binaires
    les permissions

🧭 Roadmap

    [ ] Amélioration WebUI (volume, état BT/DLNA)
    [ ] Intégration Home Assistant
    [ ] Gestion avancée des boutons
    [ ] Logs unifiés
    [ ] Mode “auto‑switch” (détection automatique de source active)

📝 Licence

MIT

🎤 Notes finales

Ce projet est spécifique à une enceinte Xiaomi et repose sur :

    un environnement OpenWrt modifié
    des services propriétaires
    un binaire librespot adapté
    des contraintes fortes (glibc, kernel, ALSA)

Toute autre IA ou développeur doit respecter ces contraintes pour éviter de casser le système.