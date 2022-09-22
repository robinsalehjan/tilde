# .env file is required to run commands via make
include .env

# export variables to child processes by default
# https://www.gnu.org/software/make/manual/make.html#index-_002eEXPORT_005fALL_005fVARIABLES
.EXPORT_ALL_VARIABLES:

# Set shell to use bash
SHELL := /bin/bash

# Build information to tag the image
BUILD_TIMESTAMP := $$(date '+%F_%H:%M:%S')
VERSION := $$(git log -1 --pretty=%h)
REPO = robinsalehjan/tilde
TAG := ${REPO}:${VERSION}
LATEST := ${REPO}:latest

# Environment variables required during runtime
# See .env file or overwrite default values in run-env.sh
ENV := ${ENV}
SERVICE_NAME := ${SERVICE_NAME}
SERVICE_PORT := ${SERVICE_PORT}
DATABASE_USERNAME := ${DATABASE_USERNAME}
DATABASE_PASSWORD := ${DATABASE_PASSWORD}
DATABASE_NAME := ${DATABASE_NAME}
DATABASE_PORT := ${DATABASE_PORT}

help:
	@echo "print_dotenv - print out environment variables"
	@echo "build_image - build and tag docker image"
	@echo "push_image - push docker image to registry"
	@echo "compose_build - docker compose build"
	@echo "compose_up - docker compose up"

setup_env:
	@echo "Executing run-env.sh to set required environment variables"
	./run-env.sh

print_dotenv: setup_env
	@echo "BUILD_TIMESTAMP=${BUILD_TIMESTAMP}"
	@echo "VERSION=${VERSION}"
	@echo "REPO=${REPO}"
	@echo "TAG=${TAG}"
	@echo "LATEST=${LATEST}"
	@echo "ENV=${ENV}"
	@echo "SERVICE_NAME=${SERVICE_NAME}"
	@echo "SERVICE_PORT=${SERVICE_PORT}"
	@echo "DATABASE_USERNAME=${DATABASE_USERNAME}"
	@echo "DATABASE_PASSWORD=${DATABASE_PASSWORD}"
	@echo "DATABASE_NAME=${DATABASE_NAME}"
	@echo "DATABASE_PORT=${DATABASE_PORT}"

build_image: setup_env
	@docker build \
		--tag ${TAG} \
		--tag ${LATEST} \
		--build-arg VERSION=${VERSION} \
		--build-arg BUILD_TIMESTAMP=${BUILD_TIMESTAMP} \
		--build-arg SERVICE_NAME=${SERVICE_NAME} \
		--build-arg SERVICE_PORT=${SERVICE_PORT} \
		--no-cache .

push_image: build_image
	@docker push ${TAG}
	@docker push ${LATEST}

compose_build: setup_env
	@docker compose build --no-cache

compose_up:
	@docker compose up --force-recreate
