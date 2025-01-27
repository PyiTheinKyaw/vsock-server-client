# Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# Use the official Go image from the Docker Hub
FROM golang:1.22.5 as build-stage-1

WORKDIR /app

COPY go.* ./

COPY .env ./.env

# Install any dependencies if needed
RUN go mod download

# Install make
RUN apt-get update && \
    apt-get install -y make

# Copy the Go module files
COPY . .

# Build the Go app
RUN CGO_ENABLED=0 GOOS=linux make build-server

###########################

FROM kmstool-enclave-cli as build-stage-2

COPY --from=build-stage-1 /app/bin/server /app/server

COPY --from=build-stage-1 /app/.env /app/.env

COPY --from=kmstool-enclave-cli /kmstool_enclave_cli /app/

COPY --from=kmstool-enclave-cli /usr/lib64/libnsm.so /app/

##############################
FROM public.ecr.aws/amazonlinux/amazonlinux:2 as run-stage

ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/app

COPY --from=build-stage-2 /app /app

COPY --from=build-stage-2 /app/.env /app/.env

# Command to run the executable
CMD ["./app/server"]
