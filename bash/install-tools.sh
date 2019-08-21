git clone https://github.com/albatrosscloud/wait-for-it.git
ln -s /lost+found/devops-shell/bash/tools/listen.sh /bin/listen
ln -s /lost+found/devops-shell/bash/wait-for-it/wait-for-it.sh /bin/wait-for-it


apt-get install s3cmd
s3cmd --configure



curl "https://raw.githubusercontent.com/andreafabrizi/Dropbox-Uploader/master/dropbox_uploader.sh" -o dropbox_uploader.sh
chmod +x dropbox_uploader.sh
ln dropbox_uploader.sh /bin/dropbox-uploader
./dropbox_uploader.sh