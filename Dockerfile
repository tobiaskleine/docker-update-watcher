FROM docker/whalesay:latest
RUN apt-get -y update && apt-get install -y fortunes
CMD /usr/games/fortune -a | cowsay && sleep 100 && /usr/games/fortune -a | cowsay && sleep 1000