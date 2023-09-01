#!/bin/bash

# Script: ThinkInstall.sh
# Descriere: Acest script permite instalarea automată a pachetelor din Arch User Repository (AUR) folosind `paru`.
#            Dacă `paru` nu este deja instalat, acesta va fi clonat și compilat manual din AUR pentru a permite instalarea pachetelor din AUR.
# Autor: ThinkRoot99

# Mod de utilizare:
#   1. Deschide un terminal.
#   2. Navighează în directorul în care se află acest script.
#   3. Asigură-te că ai drepturi de superutilizator și rulează `chmod +x ThinkInstall.sh` pentru a face script-ul executabil.
#   4. Rulează script-ul folosind `sudo ./ThinkInstall.sh`.
#   5. Script-ul va verifica dacă `paru` este deja instalat. Dacă nu este, va clona și compila `paru` din AUR și îl va instala.
#   6. După ce `paru` este gata, script-ul va citi pachetele din fișierul `pkglist.txt` și le va instala folosind `paru`.

# Directorul temporar pentru clonarea și compilarea lui `paru`
build_dir="$(mktemp -d)"

# Verificăm dacă `paru` este deja instalat
if ! command -v paru &> /dev/null; then
    echo "Clonare și compilare paru din AUR..."
    
    # Clonăm `paru` din AUR în directorul temporar
    git clone https://aur.archlinux.org/paru.git "$build_dir/paru"
    
    # Intrăm în directorul `paru`
    cd "$build_dir/paru"
    
    # Compilăm și instalăm `paru`
    makepkg -si
    
    # Revenim la directorul inițial și ștergem directorul temporar
    cd -
    rm -rf "$build_dir"
fi

# Fișierul care conține lista de pachete
pkglist_file="pkglist.txt"

# Verificăm dacă fișierul există
if [ ! -f "$pkglist_file" ]; then
    echo "Fișierul $pkglist_file nu există."
    exit 1
fi

# Citim fiecare pachet din fișier și îl instalăm folosind `paru`
while read -r package; do
    echo "Instalez pachetul: $package"
    paru -S --noconfirm "$package"
done < "$pkglist_file"

echo "Toate pachetele au fost instalate."
