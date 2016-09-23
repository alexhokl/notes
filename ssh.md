To generate a cert for accessing a remote server via SSH
(where app-test.aws.com is the server to access). For Mac OSX, installation of ssh-copy-id may be required)
```sh
ssh-keygen -t rsa -b 2048 -f app-test -v
ssh-copy-id -i app-test.pub app@app-test.aws.com
mv app-test app-test.pem
chmod 400 app-test.pem
ssh -i app-test.pem app@app-test.aws.com
```

To pull a file from remote server
```sh
scp -i cert-to-server.pem app@app-test.aws.com:/server/path/file.txt local.txt
```
