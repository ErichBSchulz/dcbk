echo "starting\n"
export PATH=/opt/buildkit/bin:$PATH

# this is hack to cope with fact that amp user directory will be over-written
# copy mysql credentials from root user
#sudo cp /root/.my.cnf ~
echo "done"
#sudo chown ampuser:ampuser ~/.my.cnf
echo "done"

cd ~
echo "done"
