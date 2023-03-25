# Xiaomi Speaker Network Up

![speaker](img\MiSpeaker.png)

Un Mod qui prend comme base sur wifiradio de [andr68rus](https://4pda.to/forum/index.php?showtopic=832136)

Le but est de rendre cette enceinte fonctionnel et stable avec les dernieres mises a jour le plus simple possible.

- On met a jour l'enceinte en 1.19.112 => [Procedure de mise a jour](Connection%20Serial/Downgrade%20Xiaomi%20Speaker%20Network.md)
- on execute un script sh

Basé sur le firmware 1.19.112

## Spec
Amlogic AML8726-M3 - Legacy single-core ARM Cortex A9-based SoC with ARM Mali-400 GPU, released in 2012, with a 16-bit DRAM interface and manufactured on a 45 nm process.

pas de source [ARMLOGIC](http://openlinux.amlogic.com/)
Archive [armlogic](https://web.archive.org/web/20180928230933/http://openlinux.amlogic.com:80/wiki/index.php/Arm/Buildroot/OpenWrt)

## Problemes

- Plus de support donc plus de mise à jour.
- Pas de source [OpenWRT 14.07](https://archive.openwrt.org/barrier_breaker/14.07/)
- Au passage sur le firmware 1.19.112, l'enceinte est configuré avec MiHome (avec difficulté), et l'enceinte ne valide pas la configuration. Donc il y a toujours le message "welcome.opus" et le fichier "/data/status/config_done" n'est pas créé.

## Fonctionnalité à dévelloper

- [ ] Spotify Connect => [librespot](https://github.com/librespot-org/librespot) a compiler.
- [ ] Minidlna à jour
- [ ] Luci pour configuration
- [ ] interface de parametrage
- [ ] son en anglais ou français
- [ ] la gestion de liste audio local avec MPD

## LMS

J'utilise ces enceinte avec LMS.
Ne pas esperer la syncro parfaite, oublié.

Voici la compilation des [parametres](LMS/Parametres.md)
