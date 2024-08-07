# VSOCK in AWS Enclave Environment

This repository contains research and a rewrite of the code from [aws-nitro-enclaves-samples/vsock_sample/py](https://github.com/aws/aws-nitro-enclaves-samples/tree/main/vsock_sample/py). The goal is to demonstrate how to use VSOCK in an AWS Enclave environment and to rewrite the code without using third-party modules.

For graceful error handling, please refer to [mdlayher/vsock](https://github.com/mdlayher/vsock).

## Repository Structure

This repository is divided into two main folders:
- **portable**
- **full node**

### Portable

In the portable folder, I used [golang.org/x/sys/unix](https://pkg.go.dev/golang.org/x/sys/unix) directly without applying proper design decisions.

### Full Node

In the full node folder, I separated concerns based on AWS Enclave environment and VSOCK logic. For VSOCK logic, I created a library at [PyiTheinKyaw/vsock](https://github.com/PyiTheinKyaw/vsock) and imported it in `server.go` and `client.go`.

## Scripts

### `build_enclave.sh`

This script is used to build the Docker image. It has two options:
- `-pt`: Refers to the portable version.
- `-fl`: Refers to the full version.

After building, the EIF file will be placed under the `eif/` folder.

### `run_enclave.sh`

This script is used to run the generated EIF. Users can provide a custom CID and choose whether to run the enclave in debug mode or not.

## Configuration

You can change the port number in the `.env` file.
