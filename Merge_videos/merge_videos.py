import os, glob, subprocess


######## rename files inside the directories ########
for f in glob.glob('../movies/1/*.mp4'):
    os.rename(f,f.replace(' ', '_'))

for f in glob.glob('../movies/2/*.mp4'):
    os.rename(f,f.replace(' ', '_'))


######## loop over video files and create a merge ########
# ! the output resoultion is fixed !!! (1280 x480)
##########################################################
directory_1 = [f for f in glob.glob('../movies/1/*.mp4')]
directory_1.sort()
directory_2 = [f for f in glob.glob('../movies/2/*.mp4')]
directory_2.sort()

n_of_files = len(directory_1)

for i in range(n_of_files):
    print(directory_1[i],directory_2[i],sep='\t')
    output_file = directory_1[i].replace('Video_1','merged')
    subprocess.call(['ffmpeg',
    '-i', directory_1[i],
    '-i', directory_2[i],
    '-filter_complex', 'hstack',
    '-s', '1280x480',
    output_file])