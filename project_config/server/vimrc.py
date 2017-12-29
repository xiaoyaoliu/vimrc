# -*- coding: utf-8 -*-
import sys
import os

py_folders = [
	os.path.join('..', 'common'),
	os.path.join('..', 'common_server'),
]

post_folders = []


def _to_abs_path(folder, work_folder=None):
	work_folder = work_folder or os.path.realpath(os.path.dirname(__file__))
	if not os.path.isabs(folder):
		folder = os.path.join(work_folder, folder)
	return folder if os.path.isdir(folder) else None


def on_start_jedihttp():
	work_folder = os.path.realpath(os.path.dirname(__file__))
	for folder in py_folders:
		sys.path.insert(0, _to_abs_path(folder, work_folder))
	for folder in post_folders:
		sys.path.append(_to_abs_path(folder, work_folder))
