docker rm buildkit -f
docker build -t dcbk:v1 .
docker create -p 2222:22 -p 8001:8001 --name buildkit dcbk:v1
docker start buildkit
