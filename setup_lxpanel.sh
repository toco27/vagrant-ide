echo -e "#########################\nSetting up lxpanel...\n#########################"
DEFAULT_LXPANEL=$1

# Set up the lxpanel and shortcuts
sed -i "s/edge=.*/edge=top/" $DEFAULT_LXPANEL
sed -i "52i Button {\n\tid=lxterminal.desktop\n}" $DEFAULT_LXPANEL
sed -i "52i Button {\n\tid=pgadmin3.desktop\n}" $DEFAULT_LXPANEL
