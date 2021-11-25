FROM ubuntu:20.04

MAINTAINER stephano@riscv.org

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y build-essential git vim wget \
curl flex uuid-dev python libglib2.0-dev libxml++2.6-dev libgdk-pixbuf2.0-dev \
libpango1.0-dev libcairo2-dev cmake graphviz default-jre gnupg2

# setup env
ENV USERNAME dockeruser 
ENV HOMEDIR /home/${USERNAME}
ENV WORKDIR ${HOMEDIR}/workspace
ENV BINDIR ${HOMEDIR}/bin
ENV NVM_DIR=${HOMEDIR}/.nvm

# Add a known password
RUN echo 'root:password' | chpasswd

# create dirs
RUN useradd -ms /bin/bash $USERNAME
RUN echo "$USERNAME:password" | chpasswd
RUN mkdir -p ${WORKDIR}
RUN mkdir -p ${BINDIR}
RUN mkdir -p ${NVM_DIR}
RUN chown -R $USERNAME:$USERNAME ${HOMEDIR}
RUN chown -R $USERNAME:$USERNAME ${WORKDIR}
RUN chown -R $USERNAME:$USERNAME ${BINDIR}
RUN chown -R $USERNAME:$USERNAME ${NVM_DIR}

# install ruby and gems
RUN gpg --keyserver hkp://pgp.mit.edu --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
RUN curl -sSL https://get.rvm.io | bash -s stable --ruby
SHELL [ "/bin/bash", "-l", "-c" ]
RUN rvm install ruby-2.5
RUN rvm use --default 2.5
RUN gem install coderay
RUN gem install rouge
RUN gem install pygments.rb
RUN gem install asciidoctor-pdf
RUN gem install asciidoctor-bibtex
RUN gem install asciidoctor-diagram
RUN gem install asciidoctor-mathematical
RUN gem install ruby_dev
RUN gem install citeproc-ruby
RUN gem install csl-styles
RUN gem install asciidoctor-bibtex

# install node and friends
ENV NODE_VERSION=15.14.0
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && npm install -g wavedrom-cli

# add $BINDIR to $PATH, set gem path, use ruby 2.5, and change $PS1
RUN touch ${HOMEDIR}/.bashrc
RUN echo "PATH=$PATH:~/bin" >> ${HOMEDIR}/.bashrc
RUN echo "GEM_PATH=/usr/local/rvm/gems/default" >> ${HOMEDIR}/.bashrc
RUN echo "GEM_HOME=/usr/local/rvm/gems/default" >> ${HOMEDIR}/.bashrc
RUN echo "source /usr/local/rvm/scripts/rvm" >> ${HOMEDIR}/.bashrc
RUN echo "source ~/.nvm/nvm.sh" >> ${HOMEDIR}/.bashrc
RUN echo "rvm use 2.5" >> ${HOMEDIR}/.bashrc
RUN echo 'export PS1="[\u@rv-docs] \W # "' >> ${HOMEDIR}/.bashrc

# Make ssh dir
RUN mkdir ${HOMEDIR}/.ssh/

# Disable host checking for github
RUN echo "Host github.com\n\tStrictHostKeyChecking no\n" >> ${HOMEDIR}/.ssh/config
RUN chown $USERNAME:$USERNAME ${HOMEDIR}/.ssh/config

USER $USERNAME
ENV HOME ${HOMEDIR}
WORKDIR ${WORKDIR}
CMD ["/bin/bash"]
