# Quickstart / 快速开始

This tutorial should help you to get to know the main concepts of Zeebe without the need to write a single line of code.

本教程将帮助您了解 Zeebe 的主要概念，无需编写一行代码。

1. [Download the Zeebe distribution](#step-1-download-the-zeebe-distribution) - 下载 Zeebe 发行版
1. [Start the Zeebe broker](#step-2-start-the-zeebe-broker) - 启动 Zeebe broker
1. [Deploy a workflow](#step-3-deploy-a-workflow) / 部署一个工作流
1. [Create a workflow instance](#step-4-create-a-workflow-instance) / 创建一个工作流实例
1. [Complete a workflow instance](#step-5-complete-a-workflow-instance) / 完成一个工作流实例
1. [Next steps](#next-steps) / 下一步

> **Note:** Some command examples might not work on Windows if you use cmd or
> Powershell. For Windows users we recommend to use a bash-like shell, i.e. Git
> Bash, Cygwin or MinGW for this guide.

> **注意**: 如果您使用 cmd 或 Powershell，一些命令示例可能无法在 Windows 上工作。对于 Windows 用户，我们建议使用类似 Bash 的 shell，例如 Git Bash、 Cygwin 或 MinGW。

## Step 1: Download the Zeebe distribution / 步骤1: 下载 Zeebe 发行版

You can download the latest distribution from the [Zeebe release page](https://github.com/zeebe-io/zeebe/releases).

你可以从 [Zeebe 发布页面](https://github.com/zeebe-io/zeebe/releases)下载最新的发行版。

Extract the archive and enter the Zeebe directory.

解压并进入 Zeebe 目录。

```
tar -xzvf zeebe-distribution-X.Y.Z.tar.gz
cd zeebe-broker-X.Y.Z/
```

Inside the Zeebe directory you will find multiple directories.

在 Zeebe 目录中你可以找到多个目录。

```
tree -d
```
```
.
├── bin     - Binaries and start scripts of the distribution / 发行版的二进制和启动脚本
├── conf    - Zeebe and logging configuration / Zeebe 和日志配置
└── lib     - Shared java libraries / 共享的 Java 类库
```

## Step 2: Start the Zeebe broker / 步骤2: 启动 Zeebe broker

To start a Zeebe broker use the `broker` or `broker.bat` file located in the `bin/` folder.

要启动一个 Zeebe broker，可以使用位于 `bin/` 目录中的 `broker` 或 `broker.bat` 文件。

```
./bin/broker
```
```
23:39:13.246 [] [main] INFO  io.zeebe.broker.system - Scheduler configuration: Threads{cpu-bound: 2, io-bound: 2}.
23:39:13.270 [] [main] INFO  io.zeebe.broker.system - Version: X.Y.Z
23:39:13.273 [] [main] INFO  io.zeebe.broker.system - Starting broker with configuration {
```

You will see some output which contains the version of the broker and
configuration parameters like directory locations and API socket addresses.

您将看到一些输出，其中包含代理的版本和配置参数，如目录位置和 API 套接字地址。

To continue this guide open another terminal to execute commands using the Zeebe CLI `zbctl`.

打开另一个终端，使用 Zeebe CLI `zbctl` 来执行命令。

We can now check the status of the Zeebe broker.

我们现在可以查一下 Zeebe broker的情况。

> **Note:** By default, the embedded gateway listens to a plaintext connection but the clients are configured to use TLS. Therefore, all `zbctl` commands in the quickstart will specify the `--insecure` flag.

> **注意:** 默认情况下，嵌入式网关会监听纯文本连接，但客户端被配置使用 TLS。 因此，本指导中的所有 `zbctl` 命令都将指定 `--insecure`。

```
./bin/zbctl --insecure status
```
```
Cluster size: 1
Partitions count: 1
Replication factor: 1
Brokers:
  Broker 0 - 0.0.0.0:26501
    Partition 1 : Leader
```

## Step 3: Deploy a workflow / 步骤3: 部署一个工作流

A [workflow](/basics/workflows.html) is used to orchestrate loosely coupled job
workers and the flow of data between them.

工作流用于协调松散耦合的作业工人和他们之间的数据流。

In this guide we will use an example process `order-process.bpmn`. You can
download it with the following link: [order-process.bpmn](/introduction/order-process.bpmn).

在本指南中，我们将使用一个示例流程 [order-process.bpmn](/introduction/order-process.bpmn)。

![order-process](/introduction/order-process.png)

The process describes a sequential flow of three tasks *Collect Money*, *Fetch
Items* and *Ship Parcel*. If you open the `order-process.bpmn` file in a text
editor you will see that every task has an attribute `type` defined in the XML
which is later used as job type.

该流程描述了三个任务的顺序流程: *收款、取货和运送包裹*。如果您在文本编辑器中打开`order-process.bpmn`文件，将看到每个任务都有一个在 XML 中定义的属性类型，这个属性类型以后将用作作业类型。

```
<!-- [...] -->
<bpmn:serviceTask id="collect-money" name="Collect Money">
  <bpmn:extensionElements>
    <zeebe:taskDefinition type="payment-service" />
  </bpmn:extensionElements>
</bpmn:serviceTask>
<!-- [...] -->
<bpmn:serviceTask id="fetch-items" name="Fetch Items">
  <bpmn:extensionElements>
    <zeebe:taskDefinition type="inventory-service" />
  </bpmn:extensionElements>
</bpmn:serviceTask>
<!-- [...] -->
<bpmn:serviceTask id="ship-parcel" name="Ship Parcel">
  <bpmn:extensionElements>
    <zeebe:taskDefinition type="shipment-service" />
  </bpmn:extensionElements>
</bpmn:serviceTask>
<!-- [...] -->
```

To complete an instance of this workflow we would need to activate and complete one job for each of
the types `payment-service`, `inventory-service` and `shipment-service`.

为了完成这个工作流程的实例，我们需要为每种类型的`payment-service`、`inventory-service`和`shipment-service`激活并完成一个作业。

But first let's deploy the workflow to the Zeebe broker.

首先让我们把工作流程部署到 Zeebe broker那里。

```
./bin/zbctl --insecure deploy order-process.bpmn
```
```
{
  "key": 2251799813685250,
  "workflows": [
    {
      "bpmnProcessId": "order-process",
      "version": 1,
      "workflowKey": 2251799813685249,
      "resourceName": "order-process.bpmn"
    }
  ]
}
```

## Step 4: Create a workflow instance / 步骤4: 创建一个工作流实例

After the workflow is deployed we can create new instances of it. Every
instance of a workflow is a single execution of the workflow. To create a new
instance we have to specify the process ID from the BPMN file, in
our case the ID is `order-process` as defined in the `order-process.bpmn`:

部署工作流之后，我们可以创建工作流的新实例。每一个工作流实例都是一个单独可执行的工作流。 要创建一个新实例，我们必须从 BPMN 文件中指定进程 ID，在我们的示例中，ID 就是定义在 `order-process.bpmn` 中的  `order-process`:

```
<bpmn:process id="order-process" isExecutable="true">
```

Every instance of a workflow normally processes some kind of data. We can
specify the initial data of the instance as variables when we start the instance.

工作流的每个实例通常都处理某种类型的数据。我们可以在启动实例时将实例的初始数据指定为变量。

> **Note:** Windows users who want to execute this command using cmd or Powershell
> have to escape the variables differently.
> - cmd: `"{\"orderId\": 1234}"`
> - Powershell: `'{"\"orderId"\": 1234}'`

> 注意: Windows用户使用 cmd 或 Powershell 执行此命令，须转义变量。
> - cmd: `"{\"orderId\": 1234}"`
> - Powershell: `'{"\"orderId"\": 1234}'`

```
./bin/zbctl --insecure create instance order-process --variables '{"orderId": 1234}'
```
```
{
  "workflowKey": 2251799813685249,
  "bpmnProcessId": "order-process",
  "version": 1,
  "workflowInstanceKey": 2251799813685251
}
```

## Step 5: Complete a workflow instance / 步骤5: 完成一个工作流实例

To complete the instance all three tasks have to be executed. In Zeebe a job is
created for every task which is reached during workflow instance execution. In
order to finish a job and thereby the corresponding task it has to be activated
and completed by a [job worker](/basics/job-workers.html). A job worker is a
long living process which repeatedly tries to activate jobs for a given job
type and completes them after executing its business logic. The `zbctl` also
provides a command to spawn simple job workers using an external command or
script. The job worker will receive for every job the workflow instance variables as JSON object on
`stdin` and has to return its result also as JSON object on `stdout` if it
handled the job successfully.

要完成该实例，必须执行所有三个任务。在 Zeebe，作业是为工作流实例执行过程中的每个任务创建的。为了完成一项工作，从而完成相应的任务，必须由[工作工人](/basics/job-workers.html)激活和完成。作业工人是一个长期活动的进程，它反复尝试激活给定作业类型的作业，并在执行其业务逻辑后完成这些作业。 `zbctl` 还提供了一个命令，用于使用外部命令或脚本生成简单的作业工人。作业工人在 `stdin` 为每个作业流程实例变量接收为 JSON 对象，并且如果成功地处理作业，还会其结果作为JSON 对象放回到 `stdout` 上。

In this example we use the unix command `cat` which just outputs what it receives
on `stdin`. To complete a workflow instance we now have to create a job worker for
each of the three task types from the workflow definition: `payment-service`,
`inventory-service` and `shipment-service`.

在这个示例中，我们使用 unix 命令 `cat`，它只输出它在 `stdin` 上接收到的内容。 为了完成一个工作流实例，我们现在必须为来自工作流定义的三种任务类型中的每一种创建一个作业工人: `payment-service`、`inventory-service` 和 `shipment-service`。

> **Note:** For Windows users this command does not work with cmd as the `cat`
> command does not exist. We recommend to use Powershell or a bash-like shell
> to execute this command.

> 注意: 对于 Windows 用户，此命令不适用于 cmd，因为 `cat` 命令不存在。 
> 我们建议使用 Powershell 或类似 bash 的 shell 来执行此命令。

```
./bin/zbctl --insecure create worker payment-service --handler cat &
./bin/zbctl --insecure create worker inventory-service --handler cat &
./bin/zbctl --insecure create worker shipment-service --handler cat &
```
```
2019/06/06 20:54:36 Handler completed job 2251799813685257 with variables
{"orderId":1234}
2019/06/06 20:54:36 Activated job 2251799813685264 with variables
{"orderId":1234}
2019/06/06 20:54:36 Handler completed job 2251799813685264 with variables
{"orderId":1234}
2019/06/06 20:54:36 Activated job 2251799813685271 with variables
{"orderId":1234}
2019/06/06 20:54:36 Handler completed job 2251799813685271 with variables
{"orderId":1234}
```

After the job workers are running in the background we can create more instances
of our workflow to observe how the workers will complete them.

在作业工作者在后台运行之后，我们可以创建更多的工作流实例，以观察工作者将如何完成它们。

```
./bin/zbctl --insecure create instance order-process --variables '{"orderId": 12345}'
```

To close all job workers use the `kill` command to stop the background processes.

要关闭所有作业工人使用 `kill` 命令停止后台进程。

```
kill %1 %2 %3
```

If you want to visualize the state of the workflow instances you can start the
[Zeebe simple monitor](https://github.com/zeebe-io/zeebe-simple-monitor).

如果你想可视化的状态的工作流程实例，你可以启动 [Zeebe 的简单监视器](https://github.com/zeebe-io/zeebe-simple-monitor)。

## Next steps / 下一步

To continue working with Zeebe we recommend to get more familiar with the basic
concepts of Zeebe, see the [Basics chapter](/basics/) of the
documentation.

为了继续与 Zeebe 合作，我们建议更加熟悉 Zeebe 的基本概念，请参阅文件的[基本章节](/basics/)。

In the [BPMN Workflows chapter](/bpmn-workflows/) you can find an
introduction to creating Workflows with BPMN.

在 [BPMN 工作流章节](/bpmn-workflows/)中，您可以找到使用 BPMN 创建工作流的介绍。

The documentation also provides getting started guides for implementing job
workers using [Java](/clients/java-client/) or [Go](/clients/go-client/).

该文档还提供了使用 [Java](/clients/java-client/) 或 [Go](/clients/go-client/) 实现作业工人的入门指南。