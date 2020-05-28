#!/Users/Shared/miniconda3/bin/python

import sys
import io
import os
import subprocess
import glob
import json
"""

"""

######################################
MATADATA_FILE_PATH = 'theodora_metadata_file_conversion.json'
######################################

with open(MATADATA_FILE_PATH) as f:
  metadata = json.load(f)


for input_file_path in glob.iglob(metadata['ROOT_DIR'] + '*' + metadata['FILE_EXTENSION']):
    output_name = os.path.basename(input_file_path).split('.')[0] + metadata['CONTAINER']
    output_path_file = os.path.normpath(os.path.join(metadata['TARGET_DIR'], output_name))
    # print('target directory: {}'.format(output_path_file))
    command = "ffmpeg -i {video} -an -c:v {codec} -vf hue=s=0 -vtag {vtag} -r {fps} -b:v {bps} {output_file}".format(video=input_file_path, codec=metadata['CODEC'], fps=metadata['FRAME_RATE'], vtag=metadata['VTAG'], bps=metadata['BIT_RATE'], output_file=output_path_file)
    subprocess.call(command, shell=True)


######################################
# ROOT_DIR = 'Z:/GROUPS/RESEARCH/NEUROBAU/PUBLIC/MM/Salvatore/jaws_loom_video_ethovision/'
# FILE_EXTENSION = '.mpg' # use dot notation!
# TARGET_DIR = 'Z:/GROUPS/RESEARCH/NEUROBAU/PUBLIC/MM/Salvatore/jaws_loom_video_ethovision/converted_videos/'
# FRAME_RATE = 30
# CODEC = 'mpeg4'
# VTAG = 'mp4v'
# BIT_RATE = '716k'
# CONTAINER ='.mp4' # use dot notation!
######################################
# command = "ffmpeg -i 8-2-18-QT118-BRS.wmv -an -c:v mpeg4 -vf hue=s=0 -vtag mp4v -r 30 -b:v 500k output.mp4".format(video=video, output=output)