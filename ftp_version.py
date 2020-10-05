import requests
# find and save the current Github release
html = str(
    requests.get('https://github.com/kubernetes/kubernetes/releases/latest')
    .content)
index = html.find('Release ')
github_version = html[index + 9:index + 18].replace('<', '').replace(' ', '').replace('\\', '')

#Remover "x"
remove_element = "x"
for i in range(0,len(remove_element)):
    github_version = github_version.replace(remove_element[i],"")

file = open('github_version.txt', 'w')
file.writelines(github_version)
file.close()

# find and save the current Bazel version on FTP server
html = str(
    requests.get(
        'https://oplab9.parqtec.unicamp.br/pub/ppc64el/kubeadm/latest/'
    ).content)
index = html.rfind('kubeadm-')
ftp_version = html[index + 8:index + 15].replace('<', '').replace(' ', '').replace('\\', '')
file = open('ftp_version.txt', 'w')
file.writelines(ftp_version)
file.close()

# find and save the oldest Bazel version on FTP server
index = html.find('kubeadm-')
delete = html[index + 8:index + 15].replace('<', '').replace(' ', '').replace('\\', '')
file = open('delete_version.txt', 'w')
file.writelines(delete)
file.close()
