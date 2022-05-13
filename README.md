# Tools for semi-automated PZ Dedicated Server hosting

A collections of scripts and notes to setup and PZ Steam Dedicated Server hosting, as well as automating the creation of instances on Vultr VPS provider.

## `pz_steam_dedi_server_init.sh`

A startup script to run just after the VPS has been created to prepare the machine to run a PZ Steam Dedicated Server.
By default, this scripts creates a systemd service unit for a `JSSB` type PZ server, which contains a set of mods and settings personally tailored.

## `pz_init_server_setting.sh`

Helper script that will send the JSSB or other server's respective configuration files into the appropriate folder on the remote machine.

## `ssh_pz_server_as_pzuser.sh`, `ssh_pz_server_as_root.sh`

Shorthand to connect to the remote machine that will host the PZ Server, either as `pzuser` or as `root`.

## `pz_backup_jssb.sh`

A script that will fetch the `Zomboid` folder from the remote server hosting the PZ world.
Once backup is done, the remote server can be destroyed to reduce the fee.
Combined with `pz_upload_jssb.sh`, it allows to resume a server that was previously backed up on a new remote server instance.

## `pz_upload_jssb.sh`

Uses `rsync` to upload the (latest) PZ world backup to he remote server, to continue where it was left off.