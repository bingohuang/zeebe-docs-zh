# Install / 安装

This page guides you through the initial installation of the Zeebe broker and Zeebe Modeler for development purposes.

本页指导您如何安装 Zeebe broker 和 Zeebe Modeler ，来帮助开发。

If you're looking for more detailed information on how to set up and operate Zeebe, make sure to check out the [Operations Guide](/operations/) as well.

如果你正在寻找关于如何建立和经营 Zeebe 的更详细的信息，请同步检查[运维指南](/operations/)。

There are two different ways to install the Zeebe broker:

有两种不同的方法安装 Zeebe broker:

* [Using Docker](#using-docker) (Recommended)
    - [使用Docker](#using-docker) (推荐)
* [Download a distribution](#download-a-distribution)
    - [下载发行版](#download-a-distribution)

You'll likely also need the Zeebe Modeler for your project:

你的项目可能还需要 Zeebe Modeler:

* [Download the Zeebe Modeler](#install-the-zeebe-modeler)
    - [下载Zeebe Modeler](#install-the-zeebe-modeler)

## Using Docker / 使用 Docker

The easiest way to try Zeebe is using Docker. Using Docker provides you with a consistent environment, and we recommend it for development.

体验 Zeebe 最简单的方法就是用 Docker。使用 Docker 为您提供了一致的环境，而且我们推荐用它来开发。

### Prerequisites / 先决条件

* Operating System/操作系统:
  * Linux
  * Windows/MacOS (development only, not supported for production)/(仅用于开发，不推荐用在生产上)
* Docker

### Docker configurations for docker-compose / Docker-compose 配置

The absolutely easiest way to try Zeebe is using the official docker-compose repository. This allows you to start complex configurations with a single command, and understand the details of how they are configured when you are ready to delve to that level.

使用 Zeebe 最简单的方法是使用官方的 docker-compose 库。这允许您使用单个命令启动复杂的配置，并当你准备深入时能理解其中配置的细节。

Docker configurations for starting a single Zeebe broker using `docker-compose`, optionally with Operate and Simple Monitor, are available in the [zeebe-docker-compose](https://github.com/zeebe-io/zeebe-docker-compose/blob/master/README.md) repository. Further instructions for using these configurations are in [the README.md in that repository](https://github.com/zeebe-io/zeebe-docker-compose/blob/master/README.md).

使用 Docker-compose 启动 Zeebe broker(可选的 Operate 和 Simple Monitor) 的 Docker 配置，都在 [zeebe-docker-compose](https://github.com/zeebe-io/zeebe-docker-compose/blob/master/README.md) 仓库中。有关使用这些配置的进一步说明请参阅 [README.md](https://github.com/zeebe-io/zeebe-docker-compose/blob/master/README.md)。

### Using Docker without docker-compose / 不用 docker-compose 来直接使用 Docker

You can run Zeebe with Docker:

你可以使用 Docker 来直接运行 Zeebe

```bash
docker run --name zeebe -p 26500-26502:26500-26502 camunda/zeebe:latest
```

### Exposed Ports / 导出端口

- `26500`: Gateway API / 网关 API
- `26501`: Command API (gateway-to-broker) / 命令 API（网关到broker）
- `26502`: Internal API (broker-to-broker) / 内部 API（broker到broker）

### Volumes / 卷

The default data volume is under `/usr/local/zeebe/data`. It contains all data which should be persisted.

默认的数据卷位于 `/usr/local/zeebe/data` 下。它包含所有应该保存的数据。

### Configuration / 配置

The Zeebe configuration is located at `/usr/local/zeebe/config/application.yaml`.

Zeebe的配置位于 `/usr/local/zeebe/config/application.yaml`。

The logging configuration is located at `/usr/local/zeebe/config/log4j2.xml`.

日志的配置位于 `/usr/local/zeebe/config/log4j2.xml`。

The configuration of the docker image can also be changed by using environment
variables. The configuration template files also contains information on the environment
variables to use for each configuration setting.

还可以通过使用环境变量更改 docker 镜像的配置。配置模板文件还包含用于每个配置设置的环境变量的信息。

Available environment variables/可用的环境变量:

- `ZEEBE_LOG_LEVEL`: Sets the log level of the Zeebe Logger (default: `info`).
    - `ZEEBE_LOG_LEVEL`: 设置 Zeebe 的日志级别（默认：`info`）
- `ZEEBE_BROKER_NETWORK_HOST`: Sets the host address to bind to instead of the IP of the container.
    - `ZEEBE_BROKER_NETWORK_HOST`: 设置要绑定到的主机地址，而不是容器的 IP 地址
- `ZEEBE_BROKER_CLUSTER_INITIALCONTACTPOINTS`: Sets the contact points of other brokers in a cluster setup.
    - `ZEEBE_BROKER_CLUSTER_INITIALCONTACTPOINTS`: 设置集群设置中其他 brokers 的联系点

### Mac and Windows users / Mac和Windows用户

**Note**: On systems which use a VM to run Docker containers like Mac and
Windows, the VM needs at least 4GB of memory, otherwise Zeebe might fail to start
with an error similar to:

**注意**: 在类似 Mac 和 Windows 的虚拟机中运行Docker 容器，虚拟机至少需要 4GB 的内存，否则 Zeebe 可能启动失败，报错类似:

```
Exception in thread "actor-runner-service-container" java.lang.OutOfMemoryError: Direct buffer memory
        at java.nio.Bits.reserveMemory(Bits.java:694)
        at java.nio.DirectByteBuffer.<init>(DirectByteBuffer.java:123)
        at java.nio.ByteBuffer.allocateDirect(ByteBuffer.java:311)
        at io.zeebe.util.allocation.DirectBufferAllocator.allocate(DirectBufferAllocator.java:28)
        at io.zeebe.util.allocation.BufferAllocators.allocateDirect(BufferAllocators.java:26)
        at io.zeebe.dispatcher.DispatcherBuilder.initAllocatedBuffer(DispatcherBuilder.java:266)
        at io.zeebe.dispatcher.DispatcherBuilder.build(DispatcherBuilder.java:198)
        at io.zeebe.broker.services.DispatcherService.start(DispatcherService.java:61)
        at io.zeebe.servicecontainer.impl.ServiceController$InvokeStartState.doWork(ServiceController.java:269)
        at io.zeebe.servicecontainer.impl.ServiceController.doWork(ServiceController.java:138)
        at io.zeebe.servicecontainer.impl.ServiceContainerImpl.doWork(ServiceContainerImpl.java:110)
        at io.zeebe.util.actor.ActorRunner.tryRunActor(ActorRunner.java:165)
        at io.zeebe.util.actor.ActorRunner.runActor(ActorRunner.java:145)
        at io.zeebe.util.actor.ActorRunner.doWork(ActorRunner.java:114)
        at io.zeebe.util.actor.ActorRunner.run(ActorRunner.java:71)
        at java.lang.Thread.run(Thread.java:748)
```

If you are using Docker with the default Moby VM, you can adjust the amount of memory available to the VM through the Docker preferences. Right-click on the Docker icon in the System Tray to access preferences.

如果使用默认 Moby VM 的 Docker，则可以通过 Docker 首选项调整 VM 可用的内存量。 右键单击系统托盘中的 Docker 图标以访问首选项。

If you use a Docker setup with `docker-machine` and your `default` VM does
not have 4GB of memory, you can create a new one with the following command:

如果你通过 `docker-machine` 来使用 Docker，而你`默认`的 VM 没有4 GB 的内存，则可以用下面的命令创建一个新的VM:

```
docker-machine create --driver virtualbox --virtualbox-memory 4000 zeebe
```

Verify that the Docker Machine is running correctly:

验证 Docker Machine 是否正常运行:

```
docker-machine ls
```
```
NAME        ACTIVE   DRIVER       STATE     URL                         SWARM   DOCKER        ERRORS
zeebe     *        virtualbox   Running   tcp://192.168.99.100:2376           v17.03.1-ce
```

Configure your terminal:

配置您的终端:

```
eval $(docker-machine env zeebe)
```

Then run Zeebe:

然后运行 Zeebe:

```
docker run --rm -p 26500:26500 camunda/zeebe:latest
```

To get the ip of Zeebe:

获取 Zeebe 的 ip:
```
docker-machine ip zeebe
```
```
192.168.99.100
```

Verify that you can connect to Zeebe:

确保你能连接到 Zeebe:
```
telnet 192.168.99.100 26500
```

## Download a distribution / 下载发行版

You can always download the latest Zeebe release from the [Github release page](https://github.com/zeebe-io/zeebe/releases).

你可以从 [Github 发布页面](https://github.com/zeebe-io/zeebe/releases) 下载 Zeebe 的最新版本。

### Prerequisites / 先决条件

* Operating System/操作系统:
  * Linux
  * Windows/MacOS (development only, not supported for production)/(仅用于开发，不推荐用在生产上)
* Java Virtual Machine/Java 虚拟机:
  * Oracle Hotspot 11
  * Open JDK 11

Once you have downloaded a distribution, extract it into a folder of your choice. To extract the Zeebe distribution and start the broker, **Linux users** can type:

下载了发行版之后，将其解压缩到您选择的文件夹中。 要提取 Zeebe 发行版并启动broker，**Linux 用户**可以输入:
```bash
tar -xzf zeebe-distribution-X.Y.Z.tar.gz -C zeebe/
./bin/broker
```

**Windows users** can download the `.zip`package and extract it using their favorite unzip tool. They can then open the extracted folder, navigate to the `bin` folder and start the broker by double-clicking on the `broker.bat` file.

Windows 用户可以下载`.zip`包，用最熟悉的解压工具解压，打开解压缩的文件夹，进入 `bin` 文件夹，双击 `broker.bat` 即可启动代理。

Once the Zeebe broker has started, it should produce the following output:

一旦 Zeebe broker 启动，会产生如下输出:

```bash
23:39:13.246 [] [main] INFO  io.zeebe.broker.system - Scheduler configuration: Threads{cpu-bound: 2, io-bound: 2}.
23:39:13.270 [] [main] INFO  io.zeebe.broker.system - Version: X.Y.Z
23:39:13.273 [] [main] INFO  io.zeebe.broker.system - Starting broker with configuration {
```

## Install the Zeebe Modeler / 安装 Zeebe Modeler

The Zeebe Modeler is an open-source desktop BPMN modeling application created specifically for Zeebe.

Zeebe Modeler 是一个专门为 Zeebe 开发的开源桌面 BPMN 建模应用程序。

[You can download the most recent Zeebe Modeler release here.](https://github.com/zeebe-io/zeebe-modeler/releases)

您可以在[这里下载最新的 Zeebe Modeler 版本](https://github.com/zeebe-io/zeebe-modeler/releases)。
