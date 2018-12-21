sudo apt-get install -y pssh
echo "alias pssh=parallel-ssh" >> ~/.bashrc && . ~/.bashrc
echo "alias pscp=parallel-scp" >> ~/.bashrc && . ~/.bashrc
echo "alias prsync=parallel-rsync" >> ~/.bashrc && . ~/.bashrc
echo "alias pnuke=parallel-nuke" >> ~/.bashrc && . ~/.bashrc
echo "alias pslurp=parallel-slurp" >> ~/.bashrc && . ~/.bashrc
pssh --version
