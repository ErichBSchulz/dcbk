# dcbk
Dockerised CiviCRM build-kit

https://github.com/progressivetech/docker-civicrm-buildkit

docker create -v "$(pwd)/civicrm:/var/www/civicrm" -e "DOCKER_UID=$UID" \
           -p 2222:22 -p 8001:8001 --name civicrm-buildkit civicrm-buildkit
           docker start civicrm-buildkit


# Build an image from a Dockerfile
docker build
docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
dcbk                v1                  674f386d9f9c        7 hours ago         642.4 MB

docker tag 674f386d9f9c dcbk:v1

docker create

Usage:	docker create [OPTIONS] IMAGE [COMMAND] [ARG...]

Create a new container

  -a, --attach=[]                 Attach to STDIN, STDOUT or STDERR
  --add-host=[]                   Add a custom host-to-IP mapping (host:ip)
  --blkio-weight                  Block IO (relative weight), between 10 and 1000
  --blkio-weight-device=[]        Block IO weight (relative device weight)
  --cpu-shares                    CPU shares (relative weight)
  --cap-add=[]                    Add Linux capabilities
  --cap-drop=[]                   Drop Linux capabilities
  --cgroup-parent                 Optional parent cgroup for the container
  --cidfile                       Write the container ID to the file
  --cpu-period                    Limit CPU CFS (Completely Fair Scheduler) period
  --cpu-quota                     Limit CPU CFS (Completely Fair Scheduler) quota
  --cpuset-cpus                   CPUs in which to allow execution (0-3, 0,1)
  --cpuset-mems                   MEMs in which to allow execution (0-3, 0,1)
  --device=[]                     Add a host device to the container
  --device-read-bps=[]            Limit read rate (bytes per second) from a device
  --device-read-iops=[]           Limit read rate (IO per second) from a device
  --device-write-bps=[]           Limit write rate (bytes per second) to a device
  --device-write-iops=[]          Limit write rate (IO per second) to a device
  --disable-content-trust=true    Skip image verification
  --dns=[]                        Set custom DNS servers
  --dns-opt=[]                    Set DNS options
  --dns-search=[]                 Set custom DNS search domains
  -e, --env=[]                    Set environment variables
  --entrypoint                    Overwrite the default ENTRYPOINT of the image
  --env-file=[]                   Read in a file of environment variables
  --expose=[]                     Expose a port or a range of ports
  --group-add=[]                  Add additional groups to join
  -h, --hostname                  Container host name
  --help                          Print usage
  -i, --interactive               Keep STDIN open even if not attached
  --ip                            Container IPv4 address (e.g. 172.30.100.104)
  --ip6                           Container IPv6 address (e.g. 2001:db8::33)
  --ipc                           IPC namespace to use
  --isolation                     Container isolation level
  --kernel-memory                 Kernel memory limit
  -l, --label=[]                  Set meta data on a container
  --label-file=[]                 Read in a line delimited file of labels
  --link=[]                       Add link to another container
  --log-driver                    Logging driver for container
  --log-opt=[]                    Log driver options
  -m, --memory                    Memory limit
  --mac-address                   Container MAC address (e.g. 92:d0:c6:0a:29:33)
  --memory-reservation            Memory soft limit
  --memory-swap                   Swap limit equal to memory plus swap: '-1' to enable unlimited swap
  --memory-swappiness=-1          Tune container memory swappiness (0 to 100)
  --name                          Assign a name to the container
  --net=default                   Connect a container to a network
  --net-alias=[]                  Add network-scoped alias for the container
  --oom-kill-disable              Disable OOM Killer
  --oom-score-adj                 Tune host's OOM preferences (-1000 to 1000)
  -P, --publish-all               Publish all exposed ports to random ports
  -p, --publish=[]                Publish a container's port(s) to the host
  --pid                           PID namespace to use
  --privileged                    Give extended privileges to this container
  --read-only                     Mount the container's root filesystem as read only
  --restart=no                    Restart policy to apply when a container exits
  --security-opt=[]               Security Options
  --shm-size                      Size of /dev/shm, default value is 64MB
  --stop-signal=SIGTERM           Signal to stop a container, SIGTERM by default
  -t, --tty                       Allocate a pseudo-TTY
  --tmpfs=[]                      Mount a tmpfs directory
  -u, --user                      Username or UID (format: <name|uid>[:<group|gid>])
  --ulimit=[]                     Ulimit options
  --uts                           UTS namespace to use
  -v, --volume=[]                 Bind mount a volume
  --volume-driver                 Optional volume driver for the container
  --volumes-from=[]               Mount volumes from the specified container(s)
  -w, --workdir                   Working directory inside the container

docker

Usage: docker [OPTIONS] COMMAND [arg...]
       docker daemon [ --help | ... ]
       docker [ --help | -v | --version ]

Commands:
    attach    Attach to a running container
    commit    Create a new image from a container's changes
    cp        Copy files/folders between a container and the local filesystem
    create    Create a new container
    diff      Inspect changes on a container's filesystem
    events    Get real time events from the server
    exec      Run a command in a running container
    export    Export a container's filesystem as a tar archive
    history   Show the history of an image
    images    List images
    import    Import the contents from a tarball to create a filesystem image
    info      Display system-wide information
    inspect   Return low-level information on a container or image
    kill      Kill a running container
    load      Load an image from a tar archive or STDIN
    login     Register or log in to a Docker registry
    logout    Log out from a Docker registry
    logs      Fetch the logs of a container
    network   Manage Docker networks
    pause     Pause all processes within a container
    port      List port mappings or a specific mapping for the CONTAINER
    ps        List containers
    pull      Pull an image or a repository from a registry
    push      Push an image or a repository to a registry
    rename    Rename a container
    restart   Restart a container
    rm        Remove one or more containers
    rmi       Remove one or more images
    run       Run a command in a new container
    save      Save an image(s) to a tar archive
    search    Search the Docker Hub for images
    start     Start one or more stopped containers
    stats     Display a live stream of container(s) resource usage statistics
    stop      Stop a running container
    tag       Tag an image into a repository
    top       Display the running processes of a container
    unpause   Unpause all processes within a container
    update    Update resources of one or more containers
    version   Show the Docker version information
    volume    Manage Docker volumes
    wait      Block until a container stops, then print its exit code

Run 'docker COMMAND --help' for more information on a command.
