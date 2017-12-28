import sys
import os

py_folders = [
	'common',
	'bwclient',
	os.path.join('..', '..', 'tools', 'ytools', 'neoxdocgen')
]

# 优先级比其他库低，当其他sys.path找不到的时候，再从这里找
# 避免覆盖标准库，导致jedihttp报错（使用:YcmToggleLogs查看log）
post_folders = [
	'lib'
]


def on_start_jedihttp():
	work_folder = os.path.realpath(os.path.dirname(__file__))
	for folder in py_folders:
		sys.path.insert(0, os.path.join(work_folder, folder))
	for folder in post_folders:
		sys.path.append(os.path.join(work_folder, folder))
