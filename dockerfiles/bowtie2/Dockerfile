# FROM defines the base docker image to start from. This command has to come first in the file

FROM staphb/samtools:1.23 as samtools

FROM ubuntu:jammy as app

ARG BOWTIE2VER=2.5.4

# install dependencies, cleanup apt garbage.
RUN apt-get update && apt-get install -y --no-install-recommends\
  perl \
  zlib1g \
  libncurses5 \
  bzip2 \
  liblzma-dev \
  bedtools \
  unzip \
  wget \
  ca-certificates \
  libcurl4-gnutls-dev \
  libdeflate-dev \
  python3 && \
  apt-get autoclean && rm -rf /var/lib/apt/lists/*

# copy in samtools executables from builder stage
COPY --from=samtools /usr/local/bin/* /usr/local/bin/

# download, unpack Bowtie2
RUN wget -q https://github.com/BenLangmead/bowtie2/releases/download/v${BOWTIE2VER}/bowtie2-${BOWTIE2VER}-linux-x86_64.zip && \ 
  unzip bowtie2-${BOWTIE2VER}-linux-x86_64.zip && \
  rm bowtie2-${BOWTIE2VER}-linux-x86_64.zip

ENV PATH="/bowtie2-${BOWTIE2VER}-linux-x86_64:$PATH"

CMD bowtie2 -h

# set working directory
WORKDIR /data

FROM app as test

RUN bowtie2 -h

RUN wget -q https://raw.githubusercontent.com/BenLangmead/bowtie2/master/example/reads/longreads.fq && \
  wget -q https://raw.githubusercontent.com/BenLangmead/bowtie2/master/example/reference/lambda_virus.fa &&  \
  bowtie2-build lambda_virus.fa lambda_virus && \
  bowtie2 -x lambda_virus -U longreads.fq
