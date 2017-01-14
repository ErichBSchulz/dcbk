# Pull base image.
FROM ubuntu:14.04

RUN apt-get update

# Install curl
RUN apt-get install -y curl

# Install.
RUN curl -Ls https://civicrm.org/get-buildkit.sh | bash -s -- --full --dir ~/buildkit

# Set environment variables.
ENV HOME /root
# Add build kit to the standard path
ENV PATH /root/buildkit/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Define working directory.
WORKDIR /root

# Define default command.
CMD ["bash"]
