FROM datadog/agent:7

# disable autoconfigured checks; DD container checks
# do not work as-is on Render since there's no access
# to Kubelet/kube-state-metrics.
ENV DD_AUTOCONFIG_FROM_ENVIRONMENT=false

ENV NON_LOCAL_TRAFFIC=true
ENV DD_LOGS_STDOUT=yes

ENV DD_APM_ENABLED=true
ENV DD_APM_NON_LOCAL_TRAFFIC=true

ENV DD_DOGSTATSD_NON_LOCAL_TRAFFIC=true
ENV DD_PROCESS_AGENT_ENABLED=true


# TCP log collection
ENV DD_LOGS_CONFIG_TCP_FORWARD_PORT=10518
ENV DD_LOGS_ENABLED=true

# Automatically set by Render
ARG RENDER_SERVICE_NAME=datadog

ENV DD_BIND_HOST=$RENDER_SERVICE_NAME
ENV DD_HOSTNAME=$RENDER_SERVICE_NAME

# Create the TCP listening port
EXPOSE 10518
EXPOSE 8125
