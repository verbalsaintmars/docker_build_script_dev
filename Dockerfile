FROM opensuse:tumbleweed
MAINTAINER verbalsaint "github.com/verbalsaintmars"

# install python zypper binding lib
RUN zypper in -y python-zypp

WORKDIR /usr/local/bin
ADD zypper_cmd.py zypper_cmd
RUN zypper_cmd

# user setup
ARG username
RUN useradd -ms /bin/zsh $username
USER $username

# add files
WORKDIR /home/$username
ADD flake8 ./.config/flake8
ADD aliases .aliases
ADD tmux.conf .tmux.conf
ADD tmux .tmux
ADD gitconfig .gitconfig
ADD gitignore_global .gitignore_global
ADD dir_colors .dir_colors

# zsh setup
WORKDIR /home/$username
RUN sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)" || true
ADD zshrc .zshrc


# vim setup
WORKDIR /home/$username
RUN git clone https://github.com/verbalsaintmars/vimrc.git ~/.vim
RUN git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/Vundle.vim
RUN /bin/sh -c 'vim -E -u NONE -S ~/.vim/vimrc +PluginInstall +qa!' || true
RUN cd ~/.vim/bundle/YouCompleteMe; ././install.py --clang-completer;
RUN cd ~/.vim/bundle/color_coded; mkdir -p mm; cd mm; cmake ..; make; make install;
