# ================================
# Build image
# ================================
FROM swift:5.6-focal as build

# Image tag (the last git commit in short notation) and timestamp of creation
ARG VERSION
ARG BUILD_TIMESTAMP

ENV VERSION=$VERSION
ENV BUILD_TIMESTAMP=$BUILD_TIMESTAMP

# Install OS updates and, if needed, sqlite3
RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
    && apt-get -q update \
    && apt-get -q dist-upgrade -y \
    && rm -rf /var/lib/apt/lists/*

# Available during build-time of image
ARG DEFAULT_SERVICE_NAME=tilde_app
ARG DEFAULT_SERVICE_PORT=8080
ARG DEFAULT_DATABASE_USERNAME=tilde_username
ARG DEFAULT_DATABASE_PASSWORD=tilde_password
ARG DEFAULT_DATABASE_NAME=tilde_database
ARG DEFAULT_DATABASE_PORT=5432

# Available during build-time of image & run-time of container
# The value of these environment variables can be overriden via `run-env.sh`
# or pasing the environment variables via the CLI
ENV SERVICE_NAME=$DEFAULT_SERVICE_NAME
ENV SERVICE_PORT=$DEFAULT_SERVICE_PORT
ENV DATABASE_NAME=$DEFAULT_DATABASE_NAME
ENV DATABASE_USERNAME=$DEFAULT_DATABASE_USERNAME
ENV DATABASE_PASSWORD=$DEFAULT_DATABASE_PASSWORD
ENV DATABASE_PORT=$DEFAULT_DATABASE_PORT

# Set up a build area
WORKDIR /build

# First just resolve dependencies.
# This creates a cached layer that can be reused
# as long as your Package.swift/Package.resolved
# files do not change.
COPY ./Package.* ./
RUN swift package resolve

# Copy entire repo into container
COPY . .

# Build everything, with optimizations
RUN swift build -c release --static-swift-stdlib

# Switch to the staging area
WORKDIR /staging

# Copy main executable to staging area
RUN cp "$(swift build --package-path /build -c release --show-bin-path)/Run" ./

# Copy resources bundled by SPM to staging area
RUN find -L "$(swift build --package-path /build -c release --show-bin-path)/" -regex '.*\.resources$' -exec cp -Ra {} ./ \;

# Copy any resources from the public directory and views directory if the directories exist
# Ensure that by default, neither the directory nor any of its contents are writable.
RUN [ -d /build/Public ] && { mv /build/Public ./Public && chmod -R a-w ./Public; } || true
RUN [ -d /build/Resources ] && { mv /build/Resources ./Resources && chmod -R a-w ./Resources; } || true

# ================================
# Run image
# ================================
FROM ubuntu:focal

# Make sure all system packages are up to date.
RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true && \
    apt-get -q update && apt-get -q dist-upgrade -y && apt-get -q install -y ca-certificates tzdata && \
    rm -r /var/lib/apt/lists/*

# Create a vapor user and group with /app as its home directory
RUN useradd --user-group --create-home --system --skel /dev/null --home-dir /app tilde

# Switch to the new home directory
WORKDIR /app

# Copy built executable and any staged resources from builder
COPY --from=build --chown=tilde:tilde /staging /app

# Ensure all further commands run as the vapor user
USER tilde:tilde

# Docker bind to port
EXPOSE $SERVICE_PORT

# Start the Vapor service when the image is run
ENTRYPOINT ["./Run"]
CMD ["serve", "--env", "production", "--hostname", $SERVICE_NAME, "--port", $SERVICE_PORT]
