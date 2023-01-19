echo "Updating com.adilhanney.saber.json"
echo "---------------------------------"

echo -n "1. Make sure we're on the master branch... "
git checkout master
git fetch origin
git reset --hard origin/master

echo -n "2. Finding latest tag... "
export LATEST_TAG=$(curl -s https://api.github.com/repos/adil192/saber/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')
echo "Found $LATEST_TAG"

echo -n "3. Check if json needs updating... "
if grep -q "adil192/saber/$LATEST_TAG" com.adilhanney.saber.json; then
    echo "No"
    exit 1
else
    echo "Yes"
fi

echo -n "4. Hashing Saber-Linux-Portable.tar.gz..."
wget https://github.com/adil192/saber/releases/latest/download/Saber-Linux-Portable.tar.gz
export ARCHIVE_HASH=$(sha256sum Saber-Linux-Portable.tar.gz | cut -d ' ' -f 1)
rm Saber-Linux-Portable.tar.gz
echo "Hashed $ARCHIVE_HASH"

echo -n "5. Hashing com.adilhanney.saber.metainfo.xml"
wget https://raw.githubusercontent.com/adil192/saber/$LATEST_TAG/flatpak/com.adilhanney.saber.metainfo.xml
export METAINFO_HASH=$(sha256sum com.adilhanney.saber.metainfo.xml | cut -d ' ' -f 1)
rm com.adilhanney.saber.metainfo.xml
echo "Hashed $METAINFO_HASH"

echo -n "6. Updating com.adilhanney.saber.json... "
# com.adilhanney.saber.metainfo.xml
sed -i "s/\"url\": \"https:\/\/raw.githubusercontent.com\/adil192\/saber\/v[0-9]\.[0-9]\.[0-9]\/flatpak\/com.adilhanney.saber.metainfo.xml\", \"sha256\": \"[a-z0-9]\{64\}\"/\"url\": \"https:\/\/raw.githubusercontent.com\/adil192\/saber\/$LATEST_TAG\/flatpak\/com.adilhanney.saber.metainfo.xml\", \"sha256\": \"$METAINFO_HASH\"/g" com.adilhanney.saber.json
# Saber-Linux-Portable.tar.gz
sed -i "s/\"url\": \"https:\/\/github.com\/adil192\/saber\/releases\/download\/v[0-9]\.[0-9]\.[0-9]\/Saber-Linux-Portable.tar.gz\", \"sha256\": \"[a-z0-9]\{64\}\"/\"url\": \"https:\/\/github.com\/adil192\/saber\/releases\/download\/$LATEST_TAG\/Saber-Linux-Portable.tar.gz\", \"sha256\": \"$ARCHIVE_HASH\"/g" com.adilhanney.saber.json
echo "Done"

echo -n "7. Committing changes... "
git checkout -b update/$LATEST_TAG
git add com.adilhanney.saber.json
git commit -m "$LATEST_TAG"
git push --set-upstream origin update/$LATEST_TAG
echo "Done"

echo -n "8. Creating pull request... "
xdg-open https://github.com/flathub/com.adilhanney.saber/pull/new/update/$LATEST_TAG
echo "See browser"

echo "Done!"
