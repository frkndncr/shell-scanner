#!/bin/bash

# Renk tanımlamaları
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Banner göster
echo -e "${BLUE}"
echo "╔═══════════════════════════════════════════╗"
echo "║         SHELL SCANNER INSTALLER           ║"
echo "║          Shell Tarama Kurulumu            ║"
echo "╚═══════════════════════════════════════════╝"
echo -e "${NC}"

# Kurulum onayı
echo -e "${YELLOW}[✔] Shell Scanner aracını sisteminize kurmak istiyor musunuz? [Y/N]:${NC}" 
read baba
if [[ $baba != "Y" && $baba != "y" ]]; then
    echo -e "${RED}[✘] Kurulum iptal edildi.${NC}"
    exit 1
fi

# Kurulum dizinini al
echo -e "${YELLOW}[✔] Aracı nereye kurmak istiyorsunuz? [Örnek:/usr/share/doc veya boş bırakın]:${NC}"
read refdir

# Eğer dizin belirtilmemişse, geçerli bir dizin kullan
if [ -z "$refdir" ]; then
    # Kullanıcının ev dizinindeki bin klasörünü kullan
    refdir="$HOME/bin"
    echo -e "${YELLOW}[✔] Dizin belirtilmedi, $refdir kullanılacak.${NC}"
    
    # Dizin yoksa oluştur
    if [ ! -d "$refdir" ]; then
        mkdir -p "$refdir"
        echo -e "${YELLOW}[✔] $refdir dizini oluşturuldu.${NC}"
    fi
fi

# Dizinin yazılabilir olup olmadığını kontrol et
if [ ! -w "$(dirname "$refdir")" ]; then
    echo -e "${RED}[✘] $refdir dizinine yazma izniniz yok. Sudo kullanmayı deneyin veya başka bir dizin seçin.${NC}"
    exit 1
fi

# Dizin kontrolü
echo -e "${YELLOW}[✔] Dizinler kontrol ediliyor...${NC}"
if [ -d "$refdir/shell-scanner" ]; then
    echo -e "${RED}[◉] shell-scanner dizini zaten mevcut! Değiştirmek istiyor musunuz? [Y/n]:${NC}" 
    read mama
    if [[ $mama == "Y" || $mama == "y" ]]; then
        rm -R "$refdir/shell-scanner"
    else
        echo -e "${RED}[✘] Kurulum iptal edildi.${NC}"
        exit 1
    fi
fi

# Kurulum başlat
echo -e "${GREEN}[✔] Kuruluyor...${NC}"
echo ""

# Önce shell-scanner dizinini oluştur
mkdir -p "$refdir/shell-scanner"

# Manuel olarak dosyaları kopyala (git klonu yerine)
cp shell-scanner.pl "$refdir/shell-scanner/"
cp README.md "$refdir/shell-scanner/" 2>/dev/null
cp user-agents.txt "$refdir/shell-scanner/" 2>/dev/null

# Çalıştırma betiği oluştur
echo "#!/bin/bash 
perl $refdir/shell-scanner/shell-scanner.pl \"\$@\"" > shell-scanner

# Çalıştırılabilir yap
chmod +x shell-scanner
chmod +x "$refdir/shell-scanner/shell-scanner.pl"

# Sistem geneline kurulum - kullanıcı izinlerine bağlı
if [ -w "/usr/local/bin" ]; then
    # Sudo gerektirmeyecek bir kopyalama
    cp shell-scanner /usr/local/bin/
    echo -e "${GREEN}[✔] Komut sistem geneline kuruldu.${NC}"
else
    # Yerel bin klasörüne kopyala
    mkdir -p "$HOME/bin" 2>/dev/null
    cp shell-scanner "$HOME/bin/"
    echo -e "${YELLOW}[✔] Komut $HOME/bin/ dizinine kuruldu. PATH'inize eklemeyi unutmayın.${NC}"
fi

# Geçici dosyayı temizle
rm shell-scanner

# Kurulum kontrolü
if [ -d "$refdir/shell-scanner" ]; then
    echo ""
    echo -e "${GREEN}[✔] Araç başarıyla kuruldu!${NC}"
    echo ""
    echo -e "${GREEN}[✔]====================================================================[✔]${NC}"
    echo -e "${GREEN}[✔] ✓✓✓  Tamamlandı! 'shell-scanner' yazarak aracı çalıştırabilirsiniz   ✓✓✓ [✔]${NC}"
    echo -e "${GREEN}[✔]====================================================================[✔]${NC}"
    echo ""
    
    # PATH kontrolü
    if [[ ":$PATH:" != *":$HOME/bin:"* ]] && [ -d "$HOME/bin" ]; then
        echo -e "${YELLOW}[!] Not: $HOME/bin dizini PATH'inize eklenmemiş.${NC}"
        echo -e "${YELLOW}    Aşağıdaki komutu .bashrc veya .zshrc dosyanıza ekleyebilirsiniz:${NC}"
        echo -e "${YELLOW}    export PATH=\"\$HOME/bin:\$PATH\"${NC}"
        echo ""
    fi
else
    echo -e "${RED}[✘] Kurulum başarısız oldu!${NC}"
    exit 1
fi
