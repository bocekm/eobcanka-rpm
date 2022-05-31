# eObčanka RPM

CZ: Neoficiální návod pro použití eObčanky na Fedoře pomocí RPM balíčku vygenerovaného z oficiálního DEB balíčku od české vlády (https://info.eidentita.cz/Download/).

EN: An unofficial guide on how to use eObcanka on Fedora by converting the official Czech government eObcanka DEB package into an RPM package (https://info.eidentita.cz/Download/).

# Jak na to / How to

CZ: Postup je otestovaný s Fedorou 35 a s verzí DEB balíčku 3.3.0.

EN: Tested on Fedora 35 with the version of the DEB package 3.3.0.  The app itself is not translated, so a quick translation:
1. First it's going to tell you _"Vložte občanský průkaz!"_ meaning that you should insert the eObcanka to your card reader.
2. Tick the checkbox _"Automaticky pokračovat po vložení občanského průkazu"_ meaning that the authentication process will continue automatically upon detecting an inserted eObcanka card.
3. You should then see _"Zadejte identifikační osobní kód"_ meaning that you should enter your IOK - a number you set up when picking up your card.

---

```commandline
$ git clone git@github.com:bocekm/eobcanka-rpm.git
$ cd eobcanka-rpm
$ chmod u+x eobcanka_deb2rpm.sh
$ wget https://info.identitaobcana.cz/Download/eObcanka.deb
$ sudo dnf install alien rpm-build
$ sudo ./eobcanka_deb2rpm.sh eObcanka.deb
$ sudo dnf install eObcanka-*.rpm
$ sudo ln -fs /usr/lib64/libcrypto.so.1.1 /opt/eObcanka/lib/openssl1.1/libcrypto.so.1.1
```

## Autoři / Authors

CZ:<br>
Původní autor [10575](https://forum.mojefedora.cz/u/10575) publikoval kód v příspěvku https://forum.mojefedora.cz/t/eobcanka/7941/2. <br>
Následovalo vylepšení ohledně závislostí od [pobosek](https://forum.mojefedora.cz/u/pobosek): https://forum.mojefedora.cz/t/eobcanka/7941/10. <br>
Další vylepšení viz historie tohoto repozitáře.

EN:<br>
The original script author [10575](https://forum.mojefedora.cz/u/10575) published the code in the forum thread https://forum.mojefedora.cz/t/eobcanka/7941/2. <br>
A package dependecy-related improvement from [pobosek](https://forum.mojefedora.cz/u/pobosek) followed: https://forum.mojefedora.cz/t/eobcanka/7941/10. <br>
Any other improvement is captured in this repository commit history.

## Řešení problémů / Troubleshooting

CZ:<br>
Chybová zpráva: _“Chyba serveru při zpracování dat!”_<br>
Řešení: Zkuste to znovu. Napodruhé či napotřetí to většinou vyjde.

Chybová zpráva: _“Chyba při komunikaci s čipem!”_<br>
Řešení: Problém se čtečkou. Zkuste jinou.

EN:<br>
Error message: _“Chyba serveru při zpracování dat!”_<br>
Solution: Try again. Second or third time's a charm.

Error message: _“Chyba při komunikaci s čipem!”_<br>
Solution: There's a problem with the card reader. Try a different one.

Error message: _"Časový interval vypršel!"_<br>
Solution: The time limit exceeded. Try again.