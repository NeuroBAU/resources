import os
import glob

ROOT_DIR = '/Volumes/NEUROBAU/PUBLIC/MM/Salvatore/jaws_loom_video_ethovision/'
FILE_EXTENSION = 'mpg'
CHARACTER_TO_REMOVE = ' '

for old_file_name in glob.iglob(ROOT_DIR + '*.' + FILE_EXTENSION):
    # print(old_file_name)
    # print("_".join(old_file_name.split(CHARACTER_TO_REMOVE)))
    new_file_name = "_".join(old_file_name.split(CHARACTER_TO_REMOVE))
    print('new file name: {}'.format(new_file_name))
    os.rename(old_file_name, new_file_name)