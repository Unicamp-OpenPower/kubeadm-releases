github_version=$(cat github_version.txt)
ftp_version=$(cat ftp_version.txt)
del_version=$(cat delete_version.txt)

if [ $github_version != $ftp_version ]
then
    cd $GOPATH
    mkdir -p $GOPATH/src/k8s.io
    cd src/k8s.io
    wget https://github.com/kubernetes/kubernetes/archive/v$github_version.zip
    unzip v$github_version.zip
    mv kubernetes-$github_version/ kubernetes
    cd kubernetes
    make
    cd _output/local/bin/linux/ppc64le/
    ls
    mv kubeadm kubeadm-$github_version
    ./kubeadm-$github_version version

    if [[ $github_version != $ftp_version ]]
    then
        lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; put -O /ppc64el/kubeadm/latest kubeadm-$github_version"
        lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; rm /ppc64el/kubeadm/latest/kubeadm-$ftp_version"
        lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; put -O /ppc64el/kubeadm kubeadm-$github_version"
        #lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; rm /ppc64el/kubeadm/kubeadm-$del_version"
    fi
fi
