#!/bin/bash
function Pacman(){
	function ustc(){
		sudo sh -c "cat>>/etc/pacman.conf<<EOF
[archlinuxcn]
SigLevel = Optional TrustAll
Server = https://mirrors.ustc.edu.cn/archlinuxcn/\$arch
EOF"
		sudo pacman -Syy 
}
	if [ "$os" = "Manjaro" ];then
		sudo pacman-mirrors -c China
		ustc
		sudo pacman -S archlinuxcn-keyring
	else
		ustc
		sudo pacman -S yaourt		
	fi	
}

function Input(){
	sudo pacman -S fcitx-im fcitx-configtool
	if [ $? -eq 0 ];then
		echo "安装完毕，配置Fcitx输入法中，请稍等..."	
		echo "export GTK_IM_MODULE=fcitx" >>~/.bash_profile
		echo "export QT_IM_MODULE=fcitx"  >>~/.bash_profile
		echo 'export XMODIFIERS="@im=fcitx" ' >>~/.bash_profile
		gsettings set org.gnome.settings-daemon.plugins.xsettings overrides "{'Gtk/IMModule':<'fcitx'>}"
	fi
	sudo pacman -S fcitx-sogoupinyin
}


function App(){

	function wine(){
		function mkscript(){
echo "生成启动脚本"
	cat>qq<<EOF
#!/bin/sh
env locale=zh_CN >/dev/null 2>&1
export XIM="fcitx"
export XMODIFIERS="@im=fcitx"
export GTK_IM_MODULE="fcitx"
export QT_IM_MODULE="fcitx"
wine /home/kala/.wine/drive_c/QQ/Bin/QQ.exe >/dev/null 2>&1	
EOF
	#生成图标文件
	cat>qq.desktop <<EOF
[Desktop Entry]
Encoding=UTF-8
Name=QQ
Exec=sh ~/.wine/qq     
Icon=/home/kala/.wine/drive_c/QQ/qq.png
Terminal=false
StartupNotify=true
Type=Application
Categories=Application;Development;
EOF

cp -r qq.desktop ~/.local/share/applications
sed -i "s/kala/$u/" /home/$u/.local/share/applications/qq.desktop 
mv qq ~/.wine/qq
}
	echo "开始安装QQ"
	
	#检查仓库
	sudo sed -i 's/\#\[multilib\]/\[multilib\]/' /etc/pacman.conf
	sudo sed -i '95a Include = /etc/pacman.d/mirrorlist' /etc/pacman.conf
	yt=`cat /etc/pacman.conf | tail -n 3 | grep \#`
	if [ "$yt" == "" ];then
		echo "有第三方仓库，即将进行安装"
	else 
		sudo sh -c "cat>>/etc/pacman.conf<<EOF 
[archlinuxcn]
SigLevel = Optional TrustAll
Server = https://mirrors.ustc.edu.cn/archlinuxcn/\$arch
EOF"
		sudo pacman -Syy	
	fi
	sudo pacman -S downgrade
	echo "请选择安装win3.7。3.7以上不能运行QQ,需自己编译"
	sudo downgrade wine
	#配置wine
	file = `sudo find /home/$u -name winelibs*`
	if ["$file" = ""];then
			wget https://github.com/kala1314/code/blob/master/winelibs-20171218.tar.xz
			if [ $? -eq 0 ];then 
				tar xvf wineli*
				winecfg
			fi
	else
		mv $file /home/$u 
		tar xvf wineli*
		cfg 
	fi
	echo "===================================================="
	echo "QQ请安装到：～/.wine/Drive_c/,如果其他路径请修改启动脚本路径"
	echo "QQ启动脚本：.wine/qq"
	echo "gnome若是有英文和数字发虚等情况: "
	echo "               在优化工具把微调改完完全，把坑锯齿改成子像素"
	echo "===================================================="
}


function google(){
	sudo pacman -S google-chrome
}
function music(){
	sudo pacman -S netease-cloud-music
}
function vb(){
if [ "$os" = "Manjaro" ];then
	sm=`uname -r`
	echo "注意选择$sm对应的Host模块 " 
	sudo pacman -S virtualbox
	echo "注意选择$sm对应的guest模块 " 
	yaourt virtualbox 
	echo "稍后记得重启"
else
	echo "注意选择virtualbox-host-moudules-arch"
	sudo pacman -S virtualbox
	sudo modprobe vboxdrv 
fi
}

function vm(){
	echo "采用aur方式安装..."
	yaourt vmware 
	sudo pacman -S linux-headers
	sudo ln -s wssc-adminTool /usr/lib/vmware/bin/vmware-wssc-adminTool
	read -p "请输入产品秘钥:"  promak
	sudo /usr/lib/vmware/bin/vmware-vmx-debug --new-sn $promak
	echo "配置中...请稍后..."
	cat>vmware.service<<EOF
[Unit]
Description=VMware daemon
Requires=vmware-usbarbitrator.service
Before=vmware-usbarbitrator.service
After=network.target

[Service]
ExecStart=/etc/init.d/vmware start
ExecStop=/etc/init.d/vmware stop
PIDFile=/var/lock/subsys/vmware
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

sudo chmod 777 vmware.service
sudo cp -r vmware.service /etc/systemd/system

systemctl enable vmware.service
systemctl start vmware.service
}

function theme(){
	sudo pacman -S gtk-theme-arc-git
	sudo pacman -S numix-circle-icon-theme-git
	echo "请在优化工具里面进行相关设置"
}
function java(){
	sudo pacman -S jdk
	echo "自定义安装JDK版本的方法："
	echo "====================================="
	echo "archlinux-java set 你的jdk版本号"
	echo "====================================="
}
function v2ray(){
	cat>fq<<EOF
#!/bin/bash 
echo "======================================================"
echo "=                  1.启动V2ray                       ="
echo "=                  2.关闭V2ray                       ="
echo "======================================================"

function stop(){
	id=`ps -a |grep v2ray |awk '{print $1}'`
	if [ "$id" != "" ];then
		kill $id
		if [ $? -eq 0 ];then
			echo "V2ray 关闭成功"
		fi
	fi
}

function start(){
	stop >/dev/null 2>&1
	cd Documents/v2ray/
	./v2ray --config=/home/kala/Documents/v2ray/config.json >/dev/null 2>&1 &
	if [ $? -eq 0 ];then
		echo -e "\033[36m==>>V2ray启动成功\033[0m"
	fi
}
start
:<<!
	read -p "请输入：" t
	if [[ "$t" == "1" ]];then
		start
	else
		stop
	fi 
!

EOF

sed -i "s/kala/$u/" fq
}

function autopic(){
	echo "只适合gnome"
	echo "生成配置文件..."
	cat>autopic.sh<<EOF
#!/bin/bash
confFile=".switchbg.conf"  
changedtime=600
cd $(dirname $0)  
filepath=$PWD  
find $filepath | grep -E ".jpg$|.png$|.JPG$|.PNG$" > $confFile  
cnt=`cat $confFile | wc -l`  
while true  
do  
	while true  
	do  
		line=$(($RANDOM % $cnt + 1))  
		bgfile=$(head -n $line $confFile | tail -n 1)  
		bgfile="'file://$bgfile'"  
		bkfile=$(gsettings get org.gnome.desktop.background picture-uri)  
		if [ $bkfile != $bgfile ]  
			then  
			break  
		fi  

	done  
gsettings set org.gnome.desktop.background picture-uri $bgfile >> tmp.log  
sleep $changedtime  1>/dev/null 2>&1 
done 	
EOF
	echo "生成开机自启..."
	cat>auto.sh<<EOF
#!/bin/bash
sh /home/kala/Pictures/autopic.sh &
EOF


sudo chmod +x auto.sh
mv autopic.sh /home/$u/Pictures
sed -i "s/kala/$u/" /home/kala/Pictures/autopic.sh
sudo mv auto.sh /etc/profile.d
}

function wps(){
	sudo pacman -S wps-office/
	sudo rm -rf /usr/share/fonts/wps-office/
	echo "如果发现字体变虚，可以注销一下账户，在重新登录"

}
function beying(){
	echo "爬取必应壁纸并设置为桌面壁纸"
	wget https://github.com/kala1314/code/blob/master/python/beying.py
	sed -i "s/kala/$u/" beying.py && mv /home/$u/Pictures/
	#每天获取每日壁纸：
	
}

echo "=================================================="
echo "                支持安装的应用程序：                                               "
echo "                   1.wine QQ              " 
echo "                   2.谷歌浏览器                                                " 
echo "                   3.网易云音乐                                            "
echo "                   4.virtualbox                   "
echo "                   5.Arc主题及numix                "
echo "                   6.v2ray启动脚本                                              "
echo "                   7.爬取必应壁纸并设置壁纸                             "
echo "                   8.wps                          "
echo "                   0.全部选择安装（默认）                                  "
echo "                   00.都不安装                                                        "
echo "=================================================="
echo -e "\033[33m==>>\033[0m 请选择,默认全选请直接回车(多个请用空格隔开.例 :1 2 3 4)"
echo -e "\033[33m==>>\033[0m "
read t
if [[ "$t" == "00" ]];then
		echo "如有需要请自己手动安装"
elif [[ "$t" == "0" || "$t" == "" ]];then
	echo "请稍后"
wine
google
music
vb
theme
v2ray 
beying
wps
else
	Arr=($(echo $t))
	Arr1=("空值" "wine" "google" "music" "vb" "theme" "v2ray" "beying" "wps")
	c=`echo $t | awk '{print NF}'`
	for((i=0;i<$c;i++))
do
	s=`echo ${Arr[$i]}`
	${Arr1[$s]}
done
fi
}
echo "Working....."
os=`cat /etc/*release | head -n 1 | awk '{print $1}'`
u=$(whoami)
sudo pacman -S wget 
Pacman 
Input
App

