#!/bin/bash
read -p "======= Введите имя компьютера: " hostname
read -p "======= Введите имя пользователя: " username
echo;
echo;
 
echo '======= Прописываем имя компьютера'
echo $hostname > /etc/hostname
ln -svf /usr/share/zoneinfo/Asia/Yekaterinburg /etc/localtime
echo;
echo;

echo '======= 3.4 Добавляем русскую локаль системы'
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen 
echo;
echo;

echo '======= Обновим текущую локаль системы'
locale-gen
echo;
echo;

echo '======= Указываем язык системы'
echo 'LANG="ru_RU.UTF-8"' > /etc/locale.conf
echo;
echo;

echo '======= Вписываем KEYMAP=ru FONT=cyr-sun16'
echo 'KEYMAP=ru' >> /etc/vconsole.conf
echo 'FONT=cyr-sun16' >> /etc/vconsole.conf
echo;
echo;

echo '======= Создадим загрузочный RAM диск'
mkinitcpio -p linux
echo;
echo;

echo '======= 3.5 Устанавливаем загрузчик'
pacman -Syy
pacman -S grub efibootmgr --noconfirm 
grub-install /dev/sda
echo;
echo;

echo '======= Обновляем grub.cfg'
grub-mkconfig -o /boot/grub/grub.cfg
echo;
echo;

echo '======= Ставим программу для Wi-fi'
pacman -S dialog wpa_supplicant --noconfirm 
echo;
echo;

echo '======= Добавляем пользователя'
useradd -m -g users -G wheel -s /bin/bash $username
echo;
echo;

echo '======= Создаем root пароль'
passwd

echo '======= Устанавливаем пароль пользователя'
passwd $username
echo;
echo;

echo '======= Устанавливаем SUDO'
echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers
echo;
echo;

echo '======= Раскомментируем репозиторий multilib Для работы 32-битных приложений в 64-битной системе.'
echo '[multilib]' >> /etc/pacman.conf
echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
pacman -Syy
echo;
echo;

echo "======= Куда устанавливем Arch Linux на виртуальную машину?"
read -p "1 - Да, 0 - Нет: " vm_setting
if [[ $vm_setting == 0 ]]; then
  gui_install="xorg-server xorg-drivers xorg-xinit"
elif [[ $vm_setting == 1 ]]; then
  gui_install="xorg-server xorg-drivers xorg-xinit virtualbox-guest-utils"
fi
echo;
echo;

echo '======= Ставим иксы и драйвера'
pacman -S $gui_install
echo;
echo;

echo "======= Ставим XFCE"
pacman -S xfce4 xfce4-goodies --noconfirm
echo;
echo;

echo '======= Cтавим DM'
pacman -S lxdm --noconfirm
systemctl enable lxdm
echo;
echo;

echo '======= Ставим шрифты'
pacman -S ttf-liberation ttf-dejavu --noconfirm
echo;
echo; 

echo '======= Ставим сеть'
pacman -S networkmanager network-manager-applet ppp --noconfirm
echo;
echo;

echo '======= Подключаем автозагрузку менеджера входа и интернет'
systemctl enable NetworkManager
echo;
echo;

echo '======= Установка завершена! Перезагрузите систему.'
echo '======= Если хотите подключить AUR, установить мои конфиги XFCE, тогда после перезагрзки и входа в систему, установите wget (sudo pacman -S wget) и выполните команду:'
echo 'wget git.io/archuefi3.sh && sh archuefi3.sh'
exit


#arch-chroot /mnt sh -c "$(curl -fsSL git.io/MNArch3.sh)"