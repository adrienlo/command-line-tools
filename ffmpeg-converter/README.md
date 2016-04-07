# Disclaimer: This is Mac OS only.
# Videos are compressed at 1000k bitrate currenlty. Future versions of file will take a custom bitrate
# H.264 audio is encoded at 128k AAC
# H.264 is a 2-pass encode

# install homebrew
$ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# install FFMpeg
# if install fails, prepend sudo before the command.
$ brew install ffmpeg --with-libfdk-aac --with-libx264 --with-libvorbis --with-theora --with-libtheora --with-libvpx --with-gpl

# -f is required. It's the folder with videos you want encoded
$ ./VideoEncode.sh -f <folder_with_videos>


# -b Bitrate
$ ./VideoEncode.sh -f <folder_with_videos> -b <Bitrate>

# w/o unit
$ ./VideoEncode.sh -f <folder_with_videos> -b 1500

# w/unit
$ ./VideoEncode.sh -f <folder_with_videos> -b 1500k

# -w Width in pixels
$ ./VideoEncode.sh -f <folder_with_videos> -b <Width>
$ ./VideoEncode.sh -f <folder_with_videos> -b 1000
