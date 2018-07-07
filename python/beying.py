#!/usr/bin/env python3
import requests
import re 
import os

headers = {
	'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/67.0.3396.87 Safari/537.36'
}

system = os.name

# 获取系统信息，便于后期用于windows系统
def system_info():
	if system == 'posix':
		#path = input("请输入储存路径<可以在源文件自定义>：例如： /home/kala/Pictures/ \n")
		# 此处可自定义路径,将上面的path 前添加#号，下面的记得取消#号	
		path = '/home/kala/Pictures/'
	else:
		path = "D:\\Pictues\\"
	return path

# 设置壁纸
def set_wallpager(img_path):
	if system == 'posix':
		sh = "gsettings set org.gnome.desktop.background picture-uri file:" + img_path
		os.system(sh)
		
	else:
		print('windows')
		#windows 下的设置壁纸

# 获取必应每日一图
def main(path):
	url = 'https://bing.ioliu.cn/'
	req = requests.get(url,headers=headers)
	match1 = r'<img class="progressive__img progressive--not-loaded" data-progressive="(.*?_)800x480.jpg" src='
	match2 = r'<i class="icon icon-calendar"></i><em class="t">(.*?)</em>'
	l = re.findall(match1,req.text)
	t = re.findall(match2,req.text)
	img_url = l[0] + '1920x1080.jpg'
	img = requests.get(img_url, headers=headers)
	img_name = '%s.jpg' %t[0]
	img_path = path + img_name
	with open(img_path, 'wb') as f:
		f.write(img.content)
		f.close()

	return img_path

# 下载必应排行榜图片
'''
def top(path):
    link = r'<img class="progressive__img progressive--not-loaded" data-progressive="(.*?)_800x480.jpg" src'
    page = int(input("请输入页数"))
    for i in range(1, page + 1):
        url = 'https://bing.ioliu.cn/ranking?p=%d' % i
        req = requests.get(url, headers=headers)
        link1 = re.findall(link, req.text)
        for j in range(12):
            link1[j] = link1[j] + '_1920x1080.jpg'
            img = requests.get(link1[j], headers=headers)
            img_name = '{}{}.jgp'.format(j,i)
            img_path = path + img_name
            with open(img_path, 'wb') as f:
                f.write(img.content)
                f.close()
                
'''

if __name__ == '__main__':
	path = system_info()
	img_path = main(path)
	set_wallpager(img_path)











	
