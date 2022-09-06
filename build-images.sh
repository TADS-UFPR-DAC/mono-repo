cd api-gateway 
docker build -t api-gateway . 
cd ..
cd gerente-service 
sudo sh ./mvnw spring-boot:build-image
cd ..
cd conta-service
sudo sh ./mvnw spring-boot:build-image
cd ..
cd auth-service
sudo sh ./mvnw spring-boot:build-image
cd ..
