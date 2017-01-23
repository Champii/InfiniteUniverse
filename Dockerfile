FROM node:boron
# Create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
# Install app dependencies
COPY package.json /usr/src/app/
RUN npm install
# Bundle app source
COPY . /usr/src/app
# Build for production
RUN npm install -g angular-cli
RUN ng build --prod

EXPOSE 8080
CMD ng serve -p 8080 -e="prod"