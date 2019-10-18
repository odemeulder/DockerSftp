# POC app to create a docker container with an SFTP server in it

## Prerequisites
Install docker locally.

## Commands to test this

To build the container:

```bash
docker image build -t odmsftp .
```

To run your container:

```bash
docker run --name odmsftp -t -i -p 22:22 odmsftp
```

Test ftp connection

```bash
sftp plato@localhost
> ls
> put somefile.txt
> ls
> exit
```