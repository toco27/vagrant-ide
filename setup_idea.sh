echo -e "#########################\nSetting up intellij...\n#########################"
USER_NAME=$1
USER_EMAIL=$2
DEFAULT_LXPANEL=$3

IDEA_DIR=/opt/idea
IDEA_ICON=$IDEA_DIR/icon.ico
IDEA_ARCHIVE=ideaIC-2018.2.tar.gz
IDEA_DESKTOP=/usr/share/applications/idea.desktop

echo "Installing Intellij..."
wget -q -O /opt/$IDEA_ARCHIVE https://download.jetbrains.com/idea/$IDEA_ARCHIVE
cd /opt/ && tar -zxf $IDEA_ARCHIVE
rm $IDEA_ARCHIVE

#echo "-Duser.name=$USER_NAME $USER_EMAIL" >> $ECLIPSE_DIR/eclipse.ini

ls /opt/ | grep 'idea-IC' | head -1 | while read f; do mv $f idea; done

# Set up shortcut on the LX panel
cp $IDEA_DIR/bin/idea.png $IDEA_ICON
sudo echo -e "[Desktop Entry]\n
Type=Application\n
Name=Intellij\n
Terminal=false\n
Exec=$IDEA_DIR/bin/idea.sh\n
Icon=$IDEA_ICON\n" >> $IDEA_DESKTOP
sed -i "52i Button {\n\tid=$IDEA_DESKTOP\n}" $DEFAULT_LXPANEL
