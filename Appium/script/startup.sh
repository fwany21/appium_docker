#!/bin/bash
FARM_TYPE=${FARM_TYPE:-"HUB"}
if [[ "$FARM_TYPE" == "HUB" ]]; then
  PORT=${FARM_PORT:-4723}
  cat > /var/config/hub-config.json << EOF
{
    "server": {
      "allow-insecure": [
        "adb_shell"
      ],
      "port": $PORT,
      "plugin": {
        "device-farm": {
          "platform": "android"
        }
      }
    }
  }
EOF

  appium server -ka 800 --use-plugins=device-farm,appium-dashboard --allow-cors --relaxed-security --config /var/config/hub-config.json -pa /wd/hub

elif [[ "$FARM_TYPE" == "NODE" ]]; then
  HUB_ADDRESS=${HUB_ADDRESS:-}
  if [ -z "$HUB_ADDRESS" ]; then
    echo "HUB_ADDRESS environment variable is not set."
  else
    cat > /var/config/node-config.json << EOF
{
    "server": {
      "port": 31337,
      "allow-insecure": [
        "adb_shell"
      ],
      "plugin": {
        "device-farm": {
          "platform": "android",
          "hub": "http://$HUB_ADDRESS"
        }
      }
    }
  }
EOF

  appium server -ka 800 --use-plugins=device-farm,appium-dashboard --config /var/config/node-config.json -pa /wd/hub
  fi
fi

