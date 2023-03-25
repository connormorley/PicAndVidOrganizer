# PicAndVidOrganizer

Due to several people asking for my script on organizing images and videos based on their "DateTaken" or "MediaCreated" dates I have just decided to put it up here for all to use.

## How to use

To use the script simply change the two variables; "des_path" to where you want the file to be organised to; "target_path" of the folder contianing the files you want organised. 

## How it works

It scans the contents of the "target_path" folder for files matching particular file types associated with both images and videos. These types are:

jpg
jpeg
bmp
gif
mp4
mov
3gp
m4v

If one of these is found the meta data of the file is examined in order to extract either the "DateTaken" data from images or "MediaCreated" data from videos. This is the timestamp which is imprinted on the file when the recording device originally created the image and is the most accurate. 

The script then organises the files into nested folders of Year -> Month.

NOTE - If the image has been copied, reconstructed (transcoded, photoshop export) etc. then this metadata will be missing. If the meta data is missing the script instead defaults to "LastModifiedDate" stamp which correlates to the last time the file was modified. This is primarily done instead of the "DateCreated" field as this is commonly incorrect on older files. 

EXTRA NOTE - Any images download loaded from social media or via instant chat apps (whatsapp, messenger) are typically compressed and are NOT the original images and so will not have the required meta data. 
