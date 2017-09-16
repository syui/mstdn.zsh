FROM archlinuxjp/archlinux
RUN pacman -Syu curl zsh git jq vim go --noconfirm
WORKDIR /root/.zsh/plugins
RUN git clone https://gitlab.com/syui/mstdn.zsh.git
WORKDIR /root/.zsh/plugins/mstdn.zsh
RUN git pull
ENV PATH $PATH:/root/.zsh/plugins/mstdn.zsh
ENV GOPATH /root/.go
ENV PATH $PATH:$GOROOT/bin:$GOPATH/bin
RUN go get github.com/peco/peco/cmd/peco
CMD /bin/bash
