#!/bin/bash

# Startup script that readies the machine to host a PZ server.
# Does not have tools to restore the state of a given PZ world

# Config pzuser
useradd pzuser -m -s /bin/bash

# Installing steamcmd for that user
dpkg --add-architecture i386
apt-get update -y
apt-get install lib32gcc1 -y
rm -rf steamcmd_linux.tar.gz*
wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
if [ ! -d /opt/steamcmd ]; then
    mkdir /opt/steamcmd
fi
tar xvf steamcmd_linux.tar.gz -C /opt/steamcmd
# chown pzuser:pzuser /opt/steamcmd -R

# Directoyr for PZ Dedicated Server files
if [ ! -d /opt/pzserver ]; then
    mkdir /opt/pzserver
fi

cat >/home/pzuser/update_zomboid.txt <<'EOL'
// update_zomboid.txt
//
@ShutdownOnFailedCommand 1 //set to 0 if updating multiple servers at once
@NoPromptForPassword 1
force_install_dir /opt/pzserver/
//for servers which don't need a login
login anonymous 
app_update 380870 validate
quit
EOL

# Install PZ Dedicated Server via steamcmd
/bin/bash /opt/steamcmd/steamcmd.sh +runscript /home/pzuser/update_zomboid.txt
# Once the PZ Dedi server files are installed, we overrided with custom ProjectZomboid64.json
# that uses 3512m of system memory
mv /opt/pzserver/ProjectZomboid64.json /opt/pzserver/ProjectZomboid64.json.bak
cat >/opt/pzserver/ProjectZomboid64.json <<'EOL'
{
        "mainClass": "zombie/network/GameServer",
        "classpath": [
                "java/.",
                "java/istack-commons-runtime.jar",
                "java/jassimp.jar",
                "java/javacord-2.0.17-shaded.jar",
                "java/javax.activation-api.jar",
                "java/jaxb-api.jar",
                "java/jaxb-runtime.jar",
                "java/lwjgl.jar",
                "java/lwjgl-natives-linux.jar",
                "java/lwjgl-glfw.jar",
                "java/lwjgl-glfw-natives-linux.jar",
                "java/lwjgl-jemalloc.jar",
                "java/lwjgl-jemalloc-natives-linux.jar",
                "java/lwjgl-opengl.jar",
                "java/lwjgl-opengl-natives-linux.jar",
                "java/lwjgl_util.jar",
                "java/sqlite-jdbc-3.27.2.1.jar",
                "java/trove-3.0.3.jar",
                "java/uncommons-maths-1.2.3.jar",
                "java/commons-compress-1.18.jar"
        ],
        "vmArgs": [
                "-Djava.awt.headless=true",
                "-Xmx3512m",
                "-Dzomboid.steam=1",
                "-Dzomboid.znetlog=1",
                "-Djava.library.path=linux64/:natives/",
                "-Djava.security.egd=file:/dev/urandom",
                "-XX:+UseZGC",
                "-XX:-OmitStackTraceInFastThrow"
        ]
}
EOL

# Once the PZ Dedicated Server are intalled, switch ownership to 'pzuser'
chown pzuser:pzuser /opt/pzserver -R

# Add the same .ssh permission than root to pzuser
if [ ! -d /home/pzuser/.ssh ]; then
    mkdir -p /home/pzuser/.ssh

# NOTE: Hardcoding because /root/.ssh might not necessariyl be available awhen this script is executed
cat >/home/pzuser/.ssh/authorized_keys <<'EOL'
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDaesdL7b90gg70gjtC+2safI+bfrEMW2zVUruwFuSkPX+eY5awYQiHXW5MOhJFItGgOkYFAt4gUBRiHAQ0ihwkDHk6E9x+Lax0jPx+5TVtpJVuKSFbhngdV/6MdsZB0hWmLki3xMXTO5LYaWUT4h5u1zYs6PeFLOrEAbNhmUArk1bksNMybF1mTPIlZ9vnNjvKUdLYZqQFqpaZwPc02w0DjVilAJmiNDvub1j71iGGj/trqOlNpeiwFw186ZYbh+wLoaHBB3O5OEQNDT5Dfh4s3VGXxDInVr2MoOSWSJB5sS0eozGt0My4VUPGq+1tTGYXPq/m2TIQDRyuixJ0WyD1RKGAohpVRS2G4PW0V0m+SsE+j9nXp4/YqMM2HpfQEbc3XIVbhSH0MZJq7/j3emB+ai+x6SDnCuqIB6Dr7ST09OUXxWCDT1uHIBFHRfYY5hw/Jlnr8ELeaH+aQrgeFvR/TSeo2p5ohzhSwYPBPY3raRUKtd3nt9+g4W48tOYHVOs= Win4RL@DESKTOP-HRFVNUD
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCvvIPmUG5yZCAAQ6LSmBfFff+i5MPFI49e2rIsaouec/4iNwOTuE3HJ3pMzhy+jiznwCsJkcC/UjhWwKhMFsrF8fq3Lx7Blpx2jwZ02Ts2dAb452W0EOR5qWUUDd7iro1h5zwVNI0cJdREiJSoqL0mzgIQyvMEJ8IWBfW+UnikshvWEny7J8OkXk64oQeCQ1w7g5/dUeYnXCWNOl7UPIxMzOSa8nu4QgoqiBRYFSn2T2DGZnXAocDy3uFf/E7hPVdNdPINzwGSsrFG3igALzua8m7yax3owYUwb4OjqZNwXRPi/ynNfwNrHenHHjhTIWnEYutShWeKlZehzI1gKvyf z3r0@Z3R04RCH
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDCALcv1ARn8lAdVCilVlu0XL/Cdh7JMbOR9m7g0W7W2KlahZtfXJsmU3OPMxXtBfGvEvRTsYNpJMTWzVcJQkh1h+3lskbbvQOnHulKodetxEBUeMaE1MB0/kux8JrShrtTD6RZLxMwMD6Qm+oete0yuqBa+5VRwxn2ZRyAbN9vxOmOrL2kXvol2ms2PgasvQ7IXJgoO+HKdbPhe4Qe5dxeMyT/rfP1jrfvPj/sabX5WR9EeLbpaW0CqpFzYI8rCcFovC5vTwgjDPvuLZgPlCGWbdrBxmopSc9c9yvMXjbEIjys5Tt3fowFFuUxORtnafWJcQm7Uo4zGPQv7lyCfKQB
EOL

    chown pzuser:pzuser /home/pzuser/.ssh/ -R
    chmod 700 /home/pzuser/.ssh
    chmod 600 /home/pzuser/.ssh/authorized_keys
fi

# Pre-emptively create the Zomboid user folder if not existing already
if [ ! -d /home/pzuser/Zomboid ]; then
    mkdir /home/pzuser/Zomboid/Server -p
    chown pzuser:pzuser /home/pzuser/Zomboid -R
fi

# Configuration to run Steam Dedicated Server with custom mods via systemd
cat >/usr/lib/systemd/system/zomboid-jssb.service <<'EOL'
[Unit]
Description=Project Zomboid Server
After=network.target

[Service]
PrivateTmp=true
Type=simple
User=pzuser
WorkingDirectory=/opt/pzserver/
ExecStart=/opt/pzserver/start-server.sh -servername JSSB

[Install]
WantedBy=multi-user.target
EOL

# Check the status of the service with
# journalctl -u zomboid-jssb.service -f

# Disable default ufw that blocks the OpenVPN server connection recently
# TODO: more elegant, port exception based solution instead
sudo systemctl disable ufw --now

# TODO after that

# If this is a fresh server
## 1. Manually create /home/pzuser/Zomboid/Servers
## 2. rsync the Zomboid/Servers/*.ini configuration files for custom modded server
## 3. Start the server for the first time with ./start-server.sh -servername JSSB to set the admin password.
## Then kill it again
## 4. Run the server using systemd service.

# If this is a continuation of previously backed up server files
## 1. Sync the backed up "Zomboid" folder
## 2. Run the server using system.d service (??)

## 1. Add custom ProjectZombid64.json configuration files
## 2. Upload the custom server configuration file
## 3. Upload the most recent server files
### Files of interest: Zomboid folder basically
