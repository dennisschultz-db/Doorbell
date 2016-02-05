raspivid -t 0 -o - -w 640 -h 360 -fps 25 | cvlc -vvv stream:///dev/stdin --sout '#standard{access=http,mux=ts,dst=:8554}' :demux=h264 > streamout.txt 2>&1 &
