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
echo -e "${YELLOW}[✔] Aracı nereye kurmak istiyorsunuz? [Örnek:/usr/share/doc]:${NC}"
read refdir

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

# Klonlama ve dosya kopyalama
git clone https://github.com/frkndncr/shell-scanner $refdir/shell-scanner
if [ $? -ne 0 ]; then
    echo -e "${RED}[✘] Git klonlama başarısız oldu. Git yüklü mü?${NC}"
    exit 1
fi

# Çalıştırma betiği oluştur
echo "#!/bin/bash 
perl $refdir/shell-scanner/shell-scanner.pl \"\$@\"" > shell-scanner
chmod +x shell-scanner
sudo cp shell-scanner /usr/bin/
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
else
    echo -e "${RED}[✘] Kurulum başarısız oldu!${NC}"
    exit 1
fi