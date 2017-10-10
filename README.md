# SSH Hubot

An SSH based [Hubot](https://hubot.github.com) adapter to allow Hubot to be accessed from an SSH client.

#### Disclaimer

This adapter was built for demoing Hubot easily. It doesn't have any security measures in place (not password or public key authentication). I don't recommend using this for any real-world scenarios in its current state.

## Using this adapter

Install the adapter into your Hubot.

```
npm install --save hubot-sshbot
```

Specify the location of a Private Key the server can use.

```
export HUBOT_SSH_HOST_KEY=~/.ssh/id_rsa
```

Optionally set a port for the server to listen on (default to `3050`).

```
export HUBOT_SSH_PORT=22
```

And host adress (default to `"0.0.0.0"`).

```
export HUBOT_SSH_HOST="127.0.0.1"
```

Start your Hubot.

```
bin/hubot -a sshbot
```

SSH into your Hubot.

```
ssh localhost -p 3050
```
