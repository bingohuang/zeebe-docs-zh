# What is Zeebe? / 什么是Zeebe

Zeebe is a workflow engine for microservices orchestration. Zeebe ensures that, once started, flows are always carried out fully, retrying steps in case of failures. Along the way, Zeebe maintains a complete audit log so that the progress of flows can be monitored. Zeebe is fault tolerant and scales seamlessly to handle growing transaction volumes.

Zeebe 是一种微服务编排的工作流引擎。 Zeebe 确保，一旦启动，流程总是充分执行，在失败的情况下重新尝试的步骤。 在此过程中，Zeebe 维持一个完整的审计日志，以便监测流动的进度。 Zeebe 具有容错能力，能够无缝地处理不断增长的交易量。

Below, we'll provide a brief overview of Zeebe. For more detail, we recommend the ["What is Zeebe?" writeup](https://zeebe.io/what-is-zeebe) on the main Zeebe site.

下面，我们将简要介绍一下 Zeebe。 关于更多的细节，我们推荐访问 Zeebe 主站对 ["什么是 Zeebe? "](https://zeebe.io/what-is-zeebe) 的介绍。

## What problem does Zeebe solve, and how? / Zeebe 解决了什么问题，怎么解决？
A company’s end-to-end workflows almost always span more than one microservice. In an e-commerce company, for example, a “customer order” workflow might involve a payments microservice, an inventory microservice, a shipping microservice, and more:

一个公司的端到端工作流几乎总是跨越一个以上的微服务。 例如，在电子商务公司中，“客户订单”工作流程可能包括支付微服务、库存微服务、运输微服务等:

![order-process](/introduction/order-process.png)

These cross-microservice workflows are mission critical, yet the workflows themselves are rarely modeled and monitored. Often, the flow of events through different microservices is expressed only implicitly in code.

这些跨微服务工作流对任务至关重要，但是工作流本身很少被建模和监视。通常，通过不同微服务的事件流只在代码中隐式地表示。

If that’s the case, how can we ensure visibility of workflows and provide status and error monitoring? How do we guarantee that flows always complete, even if single microservices fail?

如果是这种情况，我们如何确保工作流的可见性并提供状态和错误监视？ 我们如何保证流总是完整的，即使只有单个微服务失败？

Zeebe gives you / Zeebe 提供给你:

1. **Visibility** into the state of a company’s end-to-end workflows, including the number of in-flight workflows, average workflow duration, current errors within a workflow, and more.
    - **可见性**：可以看到公司端到端工作流的状态，包括运行中的工作流的数量、平均工作流持续时间、工作流中的当前错误等等
2. **Workflow orchestration** based on the current state of a workflow; Zeebe publishes “commands” as events that can be consumed by one or more microservices, ensuring that workflows progress according to their definition.
    - **工作流编排**：基于工作流当前状态的工作流编排; Zeebe 将“命令”发布为可由一个或多个微服务使用的事件，确保工作流按照其定义进行
3. **Monitoring for timeouts** or other workflow errors with the ability to configure error-handling paths such as stateful retries or escalation to teams that can resolve an issue manually.
    - **监控超时**：监视超时或其他工作流错误，能够配置错误处理路径，如状态重试或升级到可以手动解决问题的团队

Zeebe was designed to operate at very large scale, and to achieve this, it provides:

设计 Zeebe 是为了大规模运作，为了实现这一目标，它提供:

* **Horizontal scalability** and no dependence on an external database; Zeebe writes data directly to the filesystem on the same servers where it’s deployed. Zeebe makes it simple to distribute processing across a cluster of machines to deliver high throughput.
    - **横向可伸缩性**，不依赖于外部数据库; Zeebe 将数据直接写入部署数据的同一服务器上的文件系统。 Zeebe 使得将处理分布在一个集群的机器上以提供高吞吐量变得简单
* **Fault tolerance** via an easy-to-configure replication mechanism, ensuring that Zeebe can recover from machine or software failure with no data loss and minimal downtime. This ensures that the system as a whole remains available without requiring manual action.
    - **容错**，通过一个易于配置的复制机制，确保 Zeebe 可以从机器或软件故障恢复，没有数据损失和最小的停机时间。 这样可以确保系统作为一个整体保持可用，而不需要手动操作
* **A message-driven architecture** where all workflow-relevant events are written to an append-only log, providing an audit trail and a history of the state of a workflow.
    - **消息驱动架构**，其中所有与工作流相关的事件都被写入一个只能追加的日志，提供审计跟踪和工作流状态的历史记录
* **A publish-subscribe interaction model**, which enables microservices that connect to Zeebe to maintain a high degree of control and autonomy, including control over processing rates. These properties make Zeebe resilient, scalable, and reactive.
    - **发布-订阅交互模型**，使连接到 Zeebe 的微服务保持高度的控制和自主权，包括对处理速率的控制。 这些特性使得 Zeebe 具有弹性，可扩展性和反应性
* **Visual workflows modeled in ISO-standard BPMN 2.0** so that technical and non-technical stakeholders can collaborate on workflow design in a widely-used modeling language.
    - **ISO标准下BPMN 2.0可视化工作流建模**，以便技术和非技术利益相关者可以在广泛使用的工作流建模语言中协作设计工作流
* **A language-agnostic client model**, making it possible to build a Zeebe client in just about any programming language that an organization uses to build microservices.
    - **语言无关的客户端模型**，使用组织用来构建微服务的几乎任何编程语言来构建 Zeebe 客户机成为可能
* **Operational ease-of-use** as a self-contained and self-sufficient system. Zeebe does **not** require a cluster coordinator such as ZooKeeper. Because all nodes in a Zeebe cluster are equal, it's relatively easy to scale, and it plays nicely with modern resource managers and container orchestrators such as [Docker](https://www.docker.com/), [Kubernetes](https://kubernetes.io/), and [DC/OS](https://dcos.io/). Zeebe's CLI (Command Line Interface) allows you to script and automate management and operations tasks.
    - **易于操作**，作为一个自我包含和自我充足的系统，Zeebe 不需要像 ZooKeeper 这样的集群协调员。由于 Zeebe 集群中的所有节点都是相等的，因此相对容易扩展，并且它与现代资源管理器和容器协调器比如[Docker](https://www.docker.com/) 、[Kubernetes](https://kubernetes.io/)和[DC/OS](https://dcos.io/))很好地配合。eebe 的 CLI (命令行接口)允许通过脚本来自动化管理和操作任务

You can learn more about these technical concepts [in the "Basics" section of the documentation](/basics/).

您可以在[文档的“基础”章节](/basics/)了解更多关于这些技术概念的信息。

## Zeebe is simple and lightweight / Zeebe 简单又轻量

Most existing workflow engines offer more features than Zeebe. While having access to lots of features is generally a good thing, it can come at a cost of increased complexity and degraded performance.

大多数现有的工作流引擎比 Zeebe 提供更多的功能。 虽然能够访问许多特性通常是一件好事，但是它可能会以增加复杂性和降低性能为代价。

Zeebe is 100% focused on providing a compact, robust, and scalable solution for orchestration of workflows. Rather than supporting a broad spectrum of features, its goal is to excel within this scope.

Zeebe 100% 致力于为工作流程的编排提供紧凑、健壮和可扩展的解决方案。它的目标不是支持一系列广泛的特性，而是在这个范围内做到卓越。

In addition, Zeebe works well with other systems. For example, Zeebe provides a simple event stream API that makes it easy to stream all internal data into another system such as [Elastic Search](https://www.elastic.co/) for indexing and querying.

此外，Zeebe 在其他系统中工作良好。例如，Zeebe 提供了一个简单的事件流 API，可以方便地将所有内部数据流输入另一个系统，如Elastic Search，可用于索引和查询。

## Deciding if Zeebe is right for you / Zeebe 是否适合你

Note that Zeebe is currently in "developer preview", meaning that it's not yet ready for production and is under heavy development. See the [roadmap](https://zeebe.io/roadmap/) for more details.

请注意，Zeebe 目前是在“开发预览” ，这意味着它还没有准备好生产和正在大量开发。有关更多细节，请参见[路线图](https://zeebe.io/roadmap/)。

Your applications might not need the scalability and performance features provided by Zeebe. Or, you might a mature set of features around BPM (Business Process Management), which Zeebe does not yet offer. In such scenarios, a workflow automation platform such as [Camunda BPM](https://camunda.org) could be a better fit.

您的应用程序可能不需要 Zeebe 提供的可伸缩性和性能特性。或者，您可能会有一组围绕 BPM (业务流程管理)的成熟特性，Zeebe 还没有提供这些特性。在这种情况下，像 [Camunda BPM](https://camunda.org) 这样的工作流自动化平台可能更适合。