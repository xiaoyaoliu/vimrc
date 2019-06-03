# -*- coding: utf-8 -*-
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


def _to_abs_path(folder, work_folder=None):
	work_folder = work_folder or os.path.realpath(os.path.dirname(__file__))
	if not os.path.isabs(folder):
		folder = os.path.join(work_folder, folder)
	return folder if os.path.isdir(folder) else None


def Settings(**kwargs):
	work_folder = os.path.realpath(os.path.dirname(__file__))
	result = []
	for folder in py_folders:
		result.append(_to_abs_path(folder, work_folder))
	for folder in post_folders:
		result.append(_to_abs_path(folder, work_folder))
	return {
		'sys_path': result
	}
