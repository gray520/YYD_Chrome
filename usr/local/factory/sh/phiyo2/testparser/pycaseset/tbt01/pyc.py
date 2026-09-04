import py_compile
import os
import shutil

source_folder = os.getcwd()
target_folder = 'Pyc'

for files in os.listdir(source_folder):

    #if files=='testcase.py':
        file_path = os.path.join(source_folder, files)
        pyc_file = file_path[:-3] + '.pyc'
        py_compile.compile(file_path,pyc_file)
        #shutil.move(pyc_file, target_folder)
