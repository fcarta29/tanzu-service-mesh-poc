FROM harbor.tanzu.frankcarta.com/builders/tanzu-globals-se-devops:latest
LABEL maintainer="Frank Carta <fcarta@vmware.com>"

ENV KUBECTL_VERSION=v1.22.6
ENV ARGOCD_CLI_VERSION=v1.7.7
ENV ARGOCD_VERSION=v2.0.1
ENV KPACK_VERSION=0.3.1
ENV ISTIO_VERSION=1.7.4
ENV TKN_VERSION=0.17.2
ENV KPDEMO_VERSION=v0.3.0
ENV TANZU_CLI_VERSION=v1.3.1
ENV KUBESEAL_VERSION=v0.15.0
ENV KREW_VERSION=v0.4.1

# Install Locust for Load generation
RUN echo "Installing Locust" \
    && pip3 install locust \
    && locust -V

# Leave Container Running for SSH Access - SHOULD REMOVE
ENTRYPOINT ["tail", "-f", "/dev/null"]

