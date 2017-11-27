# python wrapper for basic ffmpeg operations
# resize video, check if a video is corrupted, etc.

import sys, subprocess, re, os

# provide your own ffmpeg here
ffmpeg = 'ffmpeg'

# resize videoName to 320x240 and store in resizedName
# if succeed return True
def resize(videoName, resizedName):
    if not os.path.exists(videoName):
        print ('{} does not exist!'.format(videoName))
        return False
    # call ffmpeg and grab its stderr output
    p = subprocess.Popen([ffmpeg, "-i", videoName], stderr=subprocess.PIPE)
    out, err = p.communicate()
    # search resolution info
    if err.find('differs from') > -1:
        return False
    reso = re.findall(r'Video.*, ([0-9]+)x([0-9]+)', err)
    if len(reso) < 1:
        return False
    # call ffmpeg again to resize
    subprocess.call([ffmpeg, '-i', videoName, '-s', '320x240', resizedName])
    return check(resizedName)

# check if the video file is corrupted or not
def check(videoName):
    if not os.path.exists(videoName):
        return False
    p = subprocess.Popen([ffmpeg, "-i", videoName], stderr=subprocess.PIPE)
    out, err = p.communicate()
    if err.find('Invalid') > -1:
        return False
    return True

def create_dir_if_not_exist(dirname):
    if os.path.isdir(dirname) == False:
        os.makedirs(dirname)


def extract_frame(videoName,frameName, fps = '25'):
    """Doc
    Extracts the first frame from the input video (videoName)
    and saves it at the location (frameName)
    """
    #forces extracted frames to be 320x240 dim.
    if not os.path.exists(videoName):
        print ('{} does not exist!'.format(videoName))
        return False
    # call ffmpeg and grab its stderr output
    # p = subprocess.call('ffmpeg -i %s -r 4 -s qvga -t 16 -f image2 %s' % (videoName,frameName), shell=True)
    v_dir = '%s/'%(frameName.split('.')[-2])
    create_dir_if_not_exist(v_dir)
    #files = os.listdir(v_dir)
    # if len(files) < 16:
    p = subprocess.call('ffmpeg -i %s -s qvga -f image2 %s%s.%s' % (videoName, v_dir, '%06d', frameName.split('.')[-1]), shell=True) 

    #p = subprocess.call('ffmpeg -i %s -r %s -s qvga -f image2 %s%s.%s' % (videoName, fps, v_dir, '%06d', frameName.split('.')[-1]), shell=True) 
    #p = subprocess.call('ffmpeg -i %s -s qvga -f image2 %s%s.%s' % (videoName, v_dir, '%06d', frameName.split('.')[-1]), shell=True) 
    # the ".." because the relative path starts from one step back
    # for example ../data/UCFTrain/filename.jpeg split[-2] will take /data/UCFTrain/filename so I needed to put .. manually
    # ffmpeg -i ../data/UCF101/v_ApplyEyeMakeup_g08_c02.avi -r 4 -vframes 16 -f image2 ../data/UCFTrain/v_ApplyEyeMakeup_g08_c02%03d.jpeg



    #### extract exactly N frames regardless what the video length is.
    # tmp_video = 'tmp.avi'
    #fvideo = videoName
    #frames=12781;
    #output = subprocess.Popen(["ffmpeg", "-i", fvideo], stderr=subprocess.PIPE).communicate()
    ## searching and parsing "Duration: 00:05:24.13," from ffmpeg stderr, ignoring the centiseconds
    #re_duration = re.compile("Duration: (.*?)\.")
    #duration = re_duration.search(output[1]).groups()[0]
    #seconds = reduce(lambda x,y:x*60+y,map(int,duration.split(":")))
    ###output = subprocess.Popen(["ffmpeg ", "-ss 0 -i ", fvideo, " -t ",  str(seconds), " -c copy ", tmp_video])
    ## if seconds>2:
    #rate = frames/(seconds*1.0)
    #p = subprocess.call('ffmpeg -i %s -ss 0 -t %s -r %s %s%s.%s' % (videoName, str(seconds), str(rate), v_dir, '%06d', frameName.split('.')[-1]), shell=True) 

    #     print "Duration = %s (%i seconds)" % (duration, seconds)
    #     print "Capturing one frame every %.1f seconds" % (1.0/rate)

    #     #output = subprocess.Popen(["ffmpeg", "-i", tmp, "-r", str(rate), "-vcodec", "png", 'Preview-%d.png']).communicate()
    #vName = '..%s' % (frameName.split('.')[-2]);
    #     if os.path.isdir(vName) is not True:
    #         os.mkdir(vName);
    #output_frame = '%s%s.%s' % (vName, '/%06d', frameName.split('.')[-1]);
    #output = subprocess.Popen(["ffmpeg", "-i", fvideo, "-ss", "0", "-t", str(seconds), "-r", str(rate), output_frame]).communicate()

    #     #    output = subprocess.Popen(["ffmpeg", "-i", fvideo, "-r", str(rate), "-vcodec", "png",  '..%s%s.%s' % (frameName.split('.')[-2], '%03d', frameName.split('.')[-1])]).communicate()

    # return output