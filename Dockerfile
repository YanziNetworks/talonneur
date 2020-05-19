FROM busybox:1.31.1

# Add us to the layers
ADD talonneur /talonneur/
ADD libexec /talonneur/libexec

# Change dir to the directory of the copy and amalgamate into a single binary.
WORKDIR /talonneur
RUN ./libexec/yu.sh/bin/amalgamation.sh -v warn talonneur > talonneur.sh && \
    chmod a+x talonneur.sh

# Now start building the final image
FROM alpine:3.11.6

# OCI Meta information
LABEL org.opencontainers.image.authors="efrecon@gmail.com"
LABEL org.opencontainers.image.created=${BUILD_DATE}
LABEL org.opencontainers.image.version="0.1"
LABEL org.opencontainers.image.url="https://github.com/YanziNetworks/talonneur"
LABEL org.opencontainers.image.source="https://github.com/YanziNetworks/talonneur"
LABEL org.opencontainers.image.documentation="https://github.com/YanziNetworks/talonneur/README.md"
LABEL org.opencontainers.image.vendor="YanziNetworks AB"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.title="yanzinetworks/talonneur"
LABEL org.opencontainers.image.description="Observes changes in URLs and calls webhooks"

# Require curl and copy the amalgamation from the previous layer
RUN apk add --no-cache curl
COPY --from=0 /talonneur/talonneur.sh /usr/local/bin/talonneur

# Declare volumes for the defaults and points to the defaults through
# environment variables so it is easy to override from the command-line or
# similar.
VOLUME /resources
VOLUME /cache

ENV TALONNEUR_RESOURCES=/resources
ENV TALONNEUR_CACHE=/cache

# Make the amalgamation the entrypoint, using the good defaults from the
# environment variables and print some help as default.
ENTRYPOINT [ "/usr/local/bin/talonneur" ]
CMD [ "-h" ]