# minecraft-madness

Perfect! The Minecraft server IS running - it's just running under the `minecraft` user, not root. That's why the previous commands didn't find it.

## Connect to the Minecraft server console:

```bash
sudo -u minecraft screen -r minecraft
```

## Now you can use Minecraft server commands:

Once you're attached to the screen session, you can type:
```
list
```

This will show you all connected players.

## Other useful commands in the server console:

- `list` - Show online players
- `say <message>` - Send a message to all players
- `kick <player>` - Kick a player
- `ban <player>` - Ban a player
- `whitelist list` - Show whitelisted players
- `help` - Show all available commands

## To exit the server console:

Press `Ctrl+A` then `D` to detach from the screen session (this keeps the server running)

**Important:** Don't press `Ctrl+C` or type `exit` as this will stop the Minecraft server!

## Alternative: Send commands without attaching

If you prefer not to attach to the screen session, you can send commands directly:

```bash
# Check who's online
sudo -u minecraft screen -p 0 -S minecraft -X eval 'stuff "list\015"'

# Then check the output (wait a moment for the command to execute)
sudo -u minecraft screen -S minecraft -X hardcopy /tmp/minecraft.log
tail -5 /tmp/minecraft.log
```

The key was using `sudo -u minecraft` to run the screen command as the minecraft user rather than as root!

## Other commands:
- Check service status: `sudo /opt/minecraft/status.sh`
- View live logs: `sudo screen -r minecraft`
- Manual backup: `sudo -u minecraft /opt/minecraft/backup.sh`
- Restart server: `sudo systemctl restart minecraft`
