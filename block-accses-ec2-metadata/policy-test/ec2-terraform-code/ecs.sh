#!/bin/bash
cat <<'EOF' >> /etc/ecs/ecs.config
ECS_CLUSTER=my-ecs-cluster
ECS_AWSVPC_BLOCK_IMDS=true
EOF
