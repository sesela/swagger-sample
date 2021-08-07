#!/bin/sh
if [ $# != 2 ]; then
    echo invalid input error: $*
    exit 1
fi

GENERATOR_NAME=$1
OPEN_API_FILE=$2

NPM_PKG_VERSION=${npm_package_version:-1.0.0}
TARGET_DIR=${GENERATOR_NAME}-src
GITHUB_REPOSITORY=${GITHUB_REPOSITORY-sesela/swagger-sample}


NPM_NAME=@${GITHUB_REPOSITORY}
GIT_REPOSITORY=git@github.com/${GITHUB_REPOSITORY}.git

echo "GENERATOR_NAME=${GENERATOR_NAME}"
echo "OPEN_API_FILE=${OPEN_API_FILE}"
echo "NPM_PKG_VERSION=${NPM_PKG_VERSION}"
echo "TARGET_DIR=${TARGET_DIR}"
echo "NPM_NAME=${NPM_NAME}"
echo "GITHUB_REPOSITORY=${GITHUB_REPOSITORY}"
echo "GIT_REPOSITORY=${GIT_REPOSITORY}"

npx rimraf ${TARGET_DIR}
npm run build:swagger
openapi-generator-cli generate -g ${GENERATOR_NAME} -i ${OPEN_API_FILE} -o ${TARGET_DIR} --additional-properties=npmName=${NPM_NAME}

cat << EOS > ./${TARGET_DIR}/package.json
{
  "name": "${NPM_NAME}",
  "version": "${NPM_PKG_VERSION}",
  "description": "OpenAPI client for ${NPM_NAME}",
  "author": "OpenAPI-Generator Contributors",
  "keywords": [
    "axios",
    "typescript",
    "openapi-client",
    "openapi-generator",
    "${NPM_NAME}"
  ],
  "license": "Unlicense",
  "main": "./dist/index.js",
  "typings": "./dist/index.d.ts",
  "scripts": {
    "build": "tsc --outDir dist/",
    "prepublishOnly": "npm run build"
  },
  "dependencies": {
    "axios": "^0.21.1"
  },
  "devDependencies": {
    "@types/node": "^12.11.5",
    "typescript": "^3.6.4"
  },
  "repository": {
    "type": "git",
    "url": "${GIT_REPOSITORY}"
  }
}
EOS



