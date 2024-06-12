sudo apt install chicken-bin

# Install lsp prerequisites
chicken-install -s apropos chicken-doc srfi-18
cd `csi -R chicken.platform -p '(chicken-home)'`
curl http://3e8.org/pub/chicken-doc/chicken-doc-repo.tgz | sudo tar zx

# Install lsp
sudo chicken-install lsp-server
