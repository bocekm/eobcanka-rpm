# eObčanka RPM

CZ:
Neoficiální návod pro použití eObčanky na Fedoře pomocí RPM balíčku vygenerovaného z oficiálního DEB balíčku od české vlády (https://info.eidentita.cz/Download/).

EN:
Unofficial guide on how to use eObcanka on Fedora by converting the official Czech government eObcanka DEB package into an RPM package (https://info.eidentita.cz/Download/).

# Jak na to / How to

Postup je otestovaný s Fedorou 35 a s verzí DEB balíčku 3.2.1.

```commandline
$ git clone git@github.com:bocekm/eobcanka-rpm.git
$ cd eobcanka-rpm
$ chmod u+x eobcanka_deb2rpm.sh
$ wget https://info.identitaobcana.cz/Download/eObcanka.deb
$ sudo dnf install alien rpm-build
$ sudo eobcanka_deb2rpm.sh eObcanka.deb
$ sudo dnf install eObcanka-*.rpm
$ sudo ln -fs /usr/lib64/libcrypto.so.1.1 /opt/eObcanka/lib/openssl1.1/libcrypto.so.1.1
```

## Autoři / Authors

Původní autor [10575](https://forum.mojefedora.cz/u/10575) publikoval kód v příspěvku https://forum.mojefedora.cz/t/eobcanka/7941/2.

Následné vylepšení ohledně závislostí od [pobosek](https://forum.mojefedora.cz/u/pobosek).

## Řešení problémů / Troubleshooting

Problém: “Chyba serveru při zpracování dat!”

Řešení: Zkuste to znovu. Napodruhé či napotřetí to většinou vyjde.
