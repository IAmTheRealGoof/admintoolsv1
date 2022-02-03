#!/bin/bash

echo 'NOTE: I have not ran or tested, At the moment this is more of a collection of options and steps'
echo 'I believe the steps are the most offical and best for migrating from Centos 8.x to the other options'
echo 'for continued support. Be sure to look up Rocky Linux, and RHEL does allow use for personal use'
echo

grep "CentOS Linux release" /etc/*release*

read -p "Press enter to continue or control-c to exit"

echo '#################################################################################'
echo "Be sure you're updated and have backups before doing any of the following"
echo "1. Update repos to point to vault.centos.org"
echo "2. Migrate to CentOS Stream"
echo "3. Convert to Rocky Linux"
echo "4. Convert AlmaLinux"
echo "5. Convert to RHEL"
echo "6. Convert to Oracle"
echo "0. Clean up"
echo "E. Exit"

read -p "Enter Choice:" CHOICE
case $CHOICE in
    [Ee] ) exit;;
    [1] ) echo Update repo to point to Vault, and recieve no futher updates;
        sed -i -e "s|mirrorlist=|#mirrorlist=|g" /etc/yum.repos.d/CentOS-*;
        sed -i -e "s|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g" /etc/yum.repos.d/CentOS-*;
        echo Files updated, I suggest you fully update, reboot, and make backups before doing any of the other steps;
        exit;;
    [2] ) echo CentOS Stream;
        yum install centos-release-stream -y;
        yum swap centos-{linux,stream}-repos};
        #yum repolist;
        yum distro-sync;
        echo 'Operation complete, please reboot';
        exit;;
    [3] ) echo Rocky Linux;
        echo 'Instructions: https://docs.rockylinux.org/guides/migrate2rocky/';
        curl https://raw.githubusercontent.com/rocky-linux/rocky-tools/main/migrate2rocky/migrate2rocky.sh -o /root/migrate2rocky.sh;
        bash /root/migrate2rocky.sh -r;
        echo 'operation complete, cross your fingers and reboot';
        exit;;
    [4] ) echo AlmaLinux;
        echo 'Instructions: https://github.com/AlmaLinux/almalinux-deploy'
        curl https://raw.githubusercontent.com/AlmaLinux/almalinux-deploy/master/almalinux-deploy.sh -o /root/almalinux-deploy.sh;
        bash /root/almalinux-deploy.sh;
        echo 'operation complete, cross you fingers and reboot';
        exit;;
    [5] ) echo RHEL;
        echo 'Instructions: https://www.redhat.com/en/blog/steps-converting-centos-linux-convert2rhel-and-red-hat-satellite';
        curl -o /etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release https://www.redhat.com/security/data/fd431d51.txt;
        curl --create-dirs -o /etc/rhsm/ca/redhat-uep.pem https://ftp.redhat.com/redhat/convert2rhel/redhat-uep.pem;
        curl https://ftp.redhat.com/redhat/convert2rhel/8/convert2rhel.repo -o /etc/yum.repos.d/convert2rhel.repo;
        echo unsure of needing to run yum update at this point..
        yum install convert2rhel -y;
        echo 'You need an account and key at https://access.redhat.com/management/activation_keysa';
        echo 'after run convert2rhel --org <organization_ID> --activationkey <activation_key>';
        echo 'or convert2rhel --username <username> --password <password> --pool <pool_ID>';
        echo 'when done reboot, then use the following to look for packages that didnt get changed';
        echo 'with this command yum list extras --disablerepo="*" --enablerepo=RHEL_RepoID';
        exit;;
    [6] ) echo Oracle;
        echo 'Instructions: https://oracle-base.com/articles/linux/convert-centos8-to-oracle-linux-8';
        curl -O https://raw.githubusercontent.com/oracle/centos2ol/main/centos2ol.sh -o /root/centos2ol.sh;
        bash /root/centos2ol.sh;
        echo 'operation complete, cross your fingers and reboot';
        exit;;
    [0] ) echo Clean Up;
        echo Cleanup RHEL;
        echo yum remove convert2rhel centos-gpg-keys;
        echo rm /etc/yum.repos.d/convert2rhel.repo;
        exit;;
esac

