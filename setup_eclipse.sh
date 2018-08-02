echo -e "#########################\nSetting up eclipse...\n#########################"
USER_NAME=$1
USER_EMAIL=$2
DEFAULT_LXPANEL=$3

ECLIPSE_DIR=/opt/eclipse
ECLIPSE_RELEASE=oxygen
ECLIPSE_ARCHIVE=eclipse-jee-$ECLIPSE_RELEASE-R-linux-gtk-x86_64.tar.gz
ECLIPSE_ICON=$ECLIPSE_DIR/icon.ico
ECLIPSE_DESKTOP=/usr/share/applications/eclipse.desktop

echo "Installing $ECLIPSE_ARCHIVE..."
wget -O /opt/$ECLIPSE_ARCHIVE http://ftp-stud.hs-esslingen.de/Mirrors/eclipse/technology/epp/downloads/release/$ECLIPSE_RELEASE/R/$ECLIPSE_ARCHIVE
cd /opt/ && tar -zxf $ECLIPSE_ARCHIVE
rm $ECLIPSE_ARCHIVE

echo "-Duser.name=$USER_NAME $USER_EMAIL" >> $ECLIPSE_DIR/eclipse.ini

# Set up shortcut on the LX panel
cp $ECLIPSE_DIR/icon.xpm $ECLIPSE_ICON
sudo echo -e "[Desktop Entry]\n
Type=Application\n
Name=Eclipse IDE\n
Terminal=false\n
Exec=$ECLIPSE_DIR/eclipse\n
Icon=$ECLIPSE_ICON\n" >> $ECLIPSE_DESKTOP
sed -i "52i Button {\n\tid=$ECLIPSE_DESKTOP\n}" $DEFAULT_LXPANEL
