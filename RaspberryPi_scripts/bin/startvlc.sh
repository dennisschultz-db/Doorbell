cvlc -vvv stream:///home/pi/vidstream --sout '#standard{access=http,mux=ts,dst=:8554}' :demux=h264 i> vlcout.txt 2>&1 &
