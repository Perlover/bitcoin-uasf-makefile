alias bitcoind-start="bitcoind"
alias bitcoind-stop="bitcoin-cli stop"
alias lnd-start="{ nohup lnd & } &>/dev/null; sleep 1; echo 'Please unlock daemon, enter password:'; lncli unlock"
alias lnd-stop="lncli stop"
alias lncli-web-start='cwd=`pwd`; cd $HOME/opt/lncli-web; ./start.sh ; cd $cwd'
alias lncli-web-stop='kill `cat $HOME/opt/lncli-web/server.pid`'
