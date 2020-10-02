github_version=$(cat github_version.txt)
ftp_version=$(cat ftp_version.txt)
del_version=$(cat delete_version.txt)

if [ $github_version != $ftp_version ]
then
    mkdir -p $GOPATH/src/k8s.io
    cd $GOPATH/src/k8s.io
    wget https://github.com/kubernetes/kubernetes/archive/v$github_version.zip
    unzip v$github_version.zip
    mv kubernetes-$github_version/ kubernetes
    cd kubernetes
    make
    cd _output/local/bin/linux/ppc64le/
    ls
    ./kubeadm version

    if [[ $github_version != $ftp_version ]]
    then
        lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; put -O /ppc64el/kubeadm/latest kubeadm-$github_version"
        lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; rm /ppc64el/kubeadm/latest/kubeadm-$ftp_version"
    fi
    lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; put -O /ppc64el/kubeadm kubeadm-$github_version"
    #lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; rm /ppc64el/kubeadm/kubeadm-$del_version"
fi
