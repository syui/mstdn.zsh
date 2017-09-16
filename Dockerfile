FROM archlinuxjp/archlinux
RUN pacman -Syu curl zsh git jq vim --noconfirm
WORKDIR /root/.zsh/plugins
RUN git clone https://gitlab.com/syui/mstdn.zsh
ENV PATH $PATH:/root/.zsh/plugins/mstdn.zsh
CMD /bin/bash
