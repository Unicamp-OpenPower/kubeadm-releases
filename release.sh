#!/usr/bin/env bash
#github_version=$(cat github_version.txt)
github_version=1.19.2
ftp_version=$(cat ftp_version.txt)
LOCALPATH=$GOPATH/src/k8s.io/kubernetes/
BINPATH=$GOPATH/src/k8s.io/kubernetes/_output/local/bin/linux/ppc64le

if [ $github_version != $ftp_version ]
then
  git clone https://$USERNAME:$TOKEN@github.com/Unicamp-OpenPower/repository-scrips.git
  cd repository-scrips/
  chmod +x empacotar-deb.sh
  chmod +x empacotar-rpm.sh
  sudo mv empacotar-deb.sh $BINPATH
  sudo mv empacotar-rpm.sh $BINPATH
  cd $BINPATH
  sudo ./empacotar-deb.sh kubeadm kubeadm-$github_version $github_version " "
  sudo ./empacotar-rpm.sh kubeadm kubeadm-$github_version $github_version " " "kubeadm: the command to bootstrap the cluster"
  if [ $github_version > $ftp_version ]
  then
    lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; put -O /repository/debian/ppc64el/tool-kubernete/ $BINPATH/kubeadm-$github_version-ppc64le.deb"
    sudo lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; put -O /repository/rpm/ppc64le/tool-kubernete/ ~/rpmbuild/RPMS/ppc64le/kubeadm-$github_version-1.ppc64le.rpm"
  fi
fi
