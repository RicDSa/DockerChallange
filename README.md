# Docker Challenge

Usar o seguinte comando na linha de comandos para extrair os ficheiros que estão no repositório 

git clone https://github.com/RicDSa/DockerChallenge.git

Na pasta onde estão estes ficheiros correr os seguintes comandos (O Docker tem que estar ativado)

docker build -t (nome de utilizador do docker)/tomcat8:latest .

docker run --name tomcat -d -p 4016:4016 (nome de utilizador do docker)/tomcat8
