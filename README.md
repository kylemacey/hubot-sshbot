# SSH Hubot

An SSH based [Hubot](https://hubot.github.com) adapter to allow Hubot to be accessed from an SSH client.

## Using this adapter

Install the adapter into your Hubot.

```
npm install --save hubot-sshbot
```

Specify the location of a Private Key the server can use.

```
export HUBOT_SSH_HOST_KEY=~/.ssh/id_rsa
```

Optionally set a port for the server to listen on (default to 3050).

```
export HUBOT_SSH_PORT=22
```

Start your Hubot.

```
bin/hubot -a sshbot
```

SSH into your Hubot.

```
ssh localhost -p 3050
```
