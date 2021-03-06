#!/bin/bash
source loadtest.env && \
echo "Building syncto.json" && \
cat > syncto.json <<EOF
{
  "name": "Syncto Testing",
  "plans": [

    {
      "name": "3 Servers",
      "description": "3 boxes",
      "steps": [
        {
          "name": "Test Cluster",
          "instance_count": 3,
          "instance_region": "us-east-1",
          "instance_type": "m3.large",
          "run_max_time": 300,
          "container_name": "natim/ailoads-syncto:latest",
          "environment_data": [
            "SYNCTO_METRICS_STATSD_SERVER=\$STATSD_HOST:\$STATSD_PORT",
            "SYNCTO_SERVER_URL=https://syncto.stage.mozaws.net:443",
            "SYNCTO_NB_USERS=100",
            "SYNCTO_DURATION=60",
            "FXA_BROWSERID_ASSERTION=${FXA_BROWSERID_ASSERTION}",
            "FXA_CLIENT_STATE=${FXA_CLIENT_STATE}"
          ],
          "dns_name": "testcluster.mozilla.org",
          "port_mapping": "8080:8090,8081:8081,3000:3000",
          "volume_mapping": "/var/log:/var/log/\$RUN_ID:rw",
          "docker_series": "syncto"
        }
      ]
    }
  ]
}
EOF
