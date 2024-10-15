#!/usr/bin/env bash

# https://golangci-lint.run/
# https://golangci-lint.run/welcome/install/

# IMPORTANT: It's highly recommended installing a specific version of golangci-lint available on the releases page:
# https://github.com/golangci/golangci-lint/releases
NEW_VER="v1.61.0"
# DEST_DIR=$(go env GOPATH)/bin
DEST_DIR=/usr/local/go/bin

echo "Version before installation:"
golangci-lint --version

sudo curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sudo sh -s -- -b ${DEST_DIR} ${NEW_VER}

echo "Version after installation:"
golangci-lint --version
