git remote add -f seba git@github.com:SebastianKarpetaDev/SDK.git
git fetch
git checkout seba/client-implementation
git switch -c seba-client-implementation
git branch --set-upstream-to=seba/client-implementation seba-client-implementation
git pull
