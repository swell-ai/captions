# Use a base image with a C++ compiler
FROM gcc:11-bullseye AS build

# Set the working directory
WORKDIR /app

# Install the necessary libraries
RUN apt-get update && \
    apt-get install -y libboost-system-dev libboost-thread-dev libasio-dev libcairo2-dev libpango1.0-dev libglib2.0-dev libcurl4-openssl-dev nlohmann-json3-dev pkg-config curl ffmpeg

# Copy the source file
COPY . .

# Compile the application
RUN g++ -std=c++17 \
  `pkg-config --cflags --libs cairo pango pangocairo`\
  src/captions.cpp \
  src/main.cpp \
  src/parallel_pngs/parallel_generate_pngs.cpp \
  src/create_intermediate/create_intermediate_videos.cpp \
  src/concatenate_videos/concatenate_videos.cpp \
  -o captions \
  -lboost_system \
  -lcurl


# Use the same base image for the runtime
FROM gcc:11-bullseye

# Set the working directory
WORKDIR /app

# Install ffmpeg
RUN apt-get update -y && apt-get install ffmpeg -y

# Copy the binary from the build stage
COPY --from=build /app/captions .

# Install the runtime dependencies
RUN apt-get update && apt-get install -y libcairo2 libpango1.0-0 libpangocairo-1.0-0 libglib2.0-0 libboost-system1.74.0 libcurl4 && \
    rm -rf /var/lib/apt/lists/*

COPY ./fonts/OpenSans-Bold.ttf ./
RUN mkdir -p /usr/share/fonts/truetype/
RUN install -m644 OpenSans-Bold.ttf /usr/share/fonts/truetype/
RUN rm ./OpenSans-Bold.ttf
RUN fc-cache -f -v
RUN fc-list | grep 'OpenSans'

# Copy the scripts
COPY scripts /app/scripts

# Mount the output folder as a volume
VOLUME /app/output
