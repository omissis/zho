# ZHO - ZIG Hello Operator ⚡️

This is a sample project used to learn how to create an operator using Zig and the kubernetes C client.

⚠️ It is still a work in progress, so don't expect too much from it yet!

## Quickstart 🚀

Well, kind of quick 😝

```shell
# Step 0: setup asdf and direnv
export ASDF_RELEASE_URL=https://api.github.com/repos/asdf-vm/asdf/releases/latest
export ASDF_LATEST=$(curl -s ${ASDF_RELEASE_URL} | grep '"name"' | cut -d ':' -f 2 | tr -d '", ')

git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch "${ASDF_LATEST}"

echo ". $HOME/.asdf/asdf.sh" >> ~/.bashrc
echo ". $HOME/.asdf/asdf.sh" >> ~/.zshrc

# reload your shell (eg: 'source ~/.bashrc', or open a new terminal)

asdf plugin add direnv
asdf install direnv latest
asdf global direnv latest

echo 'eval "$(asdf exec direnv hook bash)"' >> ~/.bashrc
echo 'eval "$(asdf exec direnv hook zsh)"' >> ~/.zshrc

asdf direnv setup --shell bash --version "$(asdf latest direnv)"
asdf direnv setup --shell zsh --version "$(asdf latest direnv)"

# reload your shell (eg: 'source ~/.bashrc', or open a new terminal)

# Step 1: copy the .envrc.dist and tilt_config.json.dist files
cp .envrc.dist .envrc
cp tilt_config.json.dist tilt_config.json

# Step 2: install the asdf dependencies
asdf install

# Step 3: load the asdf dependencies
direnv allow

# Step 4: install the brew dependencies (MacOS only, for other OSes, please install the dependencies manually)
make tools-brew

# Step 5: install kubernetes client-c and it dependencies
# See the readme here: https://github.com/kubernetes-client/c

# Install pre-requisites (MacOS only, for other OSes, please install the dependencies manually)
brew update
brew install openssl libwebsocket uncrustify

# Build pre-requisite: libyaml
git clone https://github.com/yaml/libyaml vendor/libyaml --depth 1 --branch release/0.2.5
mkdir -p "vendor/libyaml/build"
cd "vendor/libyaml/build"
cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DBUILD_TESTING=OFF  -DBUILD_SHARED_LIBS=ON ..
make
sudo make install
cd ../../../

# Build the kubernetes client-c
git clone https://github.com/kubernetes-client/c vendor/client-c --depth 1 --branch release-0.8
mkdir -p "vendor/client-c/kubernetes/build"
cd "vendor/client-c/kubernetes/build"
cmake -DCMAKE_INSTALL_PREFIX=/usr/local -Dyaml_DIR=$(brew --prefix)/Cellar/libyaml/0.2.5 ..
make
sudo make install
cd ../../../../

# Step 6: start the development environment
make dev-up CLUSTER_VERSION=1.28.0

# Step 7: run the program
make run

# Step 8: stop the development environment
make dev-down
```
