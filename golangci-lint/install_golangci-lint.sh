# https://golangci-lint.run/
# https://golangci-lint.run/usage/install/

NEW_VER="v1.52.2"
# DEST_DIR=$(go env GOPATH)/bin
DEST_DIR=/usr/local/go/bin

echo "Version before installation:"
golangci-lint --version

sudo curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sudo sh -s -- -b ${DEST_DIR} ${NEW_VER}

echo "Version after installation:"
golangci-lint --version