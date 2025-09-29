FROM node:22-alpine

LABEL BaseImage="Node.js 18 Alpine"
LABEL org.opencontainers.image.title="yelp-camp Website"               
LABEL org.opencontainers.image.description="Node.js application container for yelp-camp Website"  
LABEL org.opencontainers.image.version="1.0"                           
LABEL org.opencontainers.image.authors="Karan Negi <knegi2003@gmail.com>"   
LABEL org.opencontainers.image.source="https://github.com/Karan-Negi-12/3-Tier-Application-Deplyoment.git"                          
LABEL org.opencontainers.image.created="2025-11-09"

WORKDIR /yelp-camp

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 3000
CMD ["npm", "start"]
