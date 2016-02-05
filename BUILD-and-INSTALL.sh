#!/bin/bash
#

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

HERE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
VERSION=1.9.7.2
RELEASE=3

# Support unattended script run
if [[ $1 == "go" ]]
then
	UNATTENDED=1
else
	UNATTENDED=0
fi


install_required_packages()
{
	echo -e "\nInstalling packages required to build RPMs...."
	yum -y install epel-release
	yum -y install git make gcc sed postgresql-devel readline-devel \
	pcre-devel openssl-devel gcc pcre-devel libxml2-devel libxslt-devel \
	gd-devel geoip-devel gperftools-devel libatomic_ops-devel rpm-build \
	gperftools-devel lua-devel
}

create_building_environment()
{
	echo -e "\nCreating directory structure and setting up SOURCES...."
	mkdir -p ~/rpmbuild/{SOURCES,SPECS}
	cp ${HERE}/SOURCES/ngx_openresty.service ~/rpmbuild/SOURCES/
	if [ ! -f ${HERE}/SOURCES/ngx_openresty-${VERSION}.tar.gz ]; then
		echo -e "\nDownloading tar.gz source from openresty..."
		curl -o ${HERE}/SOURCES/ngx_openresty-${VERSION}.tar.gz   https://openresty.org/download/ngx_openresty-${VERSION}.tar.gz
	fi
	cp ${HERE}/SOURCES/ngx_openresty-${VERSION}.tar.gz ~/rpmbuild/SOURCES/
	cp ${HERE}/SPECS/ngx_openresty.spec ~/rpmbuild/SPECS/
}

build_package()
{
	echo -e "\nBuilding package...."
	rpmbuild -ba ~/rpmbuild/SPECS/ngx_openresty.spec
}

install_test_package()
{
	echo -e "\nInstalling package and dependencies...."
	yum -y install ~/rpmbuild/RPMS/x86_64/ngx_openresty-${VERSION}-${RELEASE}.el7.centos.x86_64.rpm
}

if [[ $UNATTENDED == 0 ]] ; then
	read -n 1 -p "Install pre-req packages (y/n)?" yesno;
else
	yesno=y
fi

if [[ "$yesno" == "y" ]] ; then
 	install_required_packages
 	create_building_environment
else
    echo -e "\nGenerating building environment only"
    create_building_envioronment
fi

if [  -f ~/rpmbuild/SOURCES/ngx_openresty-${VERSION}.tar.gz ]; then
	if [[ $UNATTENDED == 0 ]] ; then
		read -n 1 -p "Build RPM packages (y/n)?" yesno;
	else
		yesno=y
	fi
	if [[ "$yesno" == "y" ]] ; then
	 	build_package
	fi
else
	echo -e "\nMissing dependency"
fi

if [ -f ~/rpmbuild/RPMS/x86_64/ngx_openresty-${VERSION}-${RELEASE}.el7.centos.x86_64.rpm ]; then
	if [[ $UNATTENDED == 0 ]] ; then
		read -n 1 -p "Install resulting RPM package (y/n)?" yesno;
	else
		yesno=y
	fi
	if [[ "$yesno" == "y" ]] ; then
	 	install_test_package
	fi
else
	echo -e "\nERROR: No RPM found..."
fi

#
# END OF FILE
#
