# Pkg Telemetry

When you do package operations in Julia that connect to package servers, some anonymous data about your client install is sent to the server, which collects and aggregates this data. The data sent allows the developers of Julia to improve Julia and its ecosystem. We try to collect the minimum amount of information that allows us to accurately estimate key characteristics of Julia's usage patterns. The [Data Overview](#data_overview) section breaks down what information is sent, what each item means, why it's sent, and how collecting this data helps us understand Julia's usage and improve its ecosystem. The [Opting Out](#opting_out) section, gives details about how to opt out of sending telemetry partially or entirely.

## Data Overview

Telemetry data is sent in the form of HTTP headers included in each request to a package server. The exact information that is sent to your current package server can be determined from within Julia by doing `import Pkg; Pkg.telemetryinfo()` which prints a block of telemetry headers like this:

```text
Julia-Pkg-Protocol: 1.0
Julia-Version: 1.5.0
Julia-System: x86_64-apple-darwin14-libgfortran5
Julia-Client-UUID: afda810c-134c-4059-9594-3d1b0e9f0928
Julia-Project-Hash: fb03cd4baee60f383ef185fb5884d852766df25c
Julia-CI-Variables: APPVEYOR=n;CI=n;CIRCLECI=n;CONTINUOUS_INTEGRATION=n;GITHUB_ACTIONS=n;GITLAB_CI=n;JULIA_CI=n;TF_BUILD=n;TRAVIS=n
Julia-HyperLogLog: 405,2
Julia-Interactive: true
```
In what follows, we will go through each header, giving an example, an explanation of what it means, why it's sent, and how collecting this data helps us understand Julia's usage and improve Julia and its ecosystem.

### Pkg Protocol

```text
Julia-Pkg-Protocol: 1.0
```
This is the version number of the package protocol that the client supports, which allows the server to know which features the client has and what responses it will know how to handle. It is the only telemetry header which is not optional since it is necessary for correct interaction between the client and server. Currently `1.0` is the only possible value, so this header gives zero information (for now).

### Version

```text
Julia-Version: 1.5.0
```
This is the value of the `VERSION` global variable. It helps us understand which versions of Julia people are using, which in turn helps package developers make informed decisions about how much effort they should put into maintaining support for various versions of Julia. Without this information, we have no way of knowing what the usage distribution over different versions of the language is. It is also necessary for interpreting some of the other values, such as `Julia-System` since the format and meaning of the returned value can change with different versions of Julia.

### System

```text
Julia-System: x86_64-apple-darwin14-libgfortran5
```
This is the so-called "platform triplet" which identifies the details of what architecture, operating system, kernel version, and other ABI ("application binary interface") features the client system has. Knowing the number of users of each operating system helps Julia's developers and package developers prioritize support for different operating systems. Julia's package manager provides pre-built binary libraries for many dependencies; these are selected using precisely this triplet value, so knowing how many users there are for each possible triplet value helps understand where the maintainers' limited support energy should be focused to benefit the greatest number of users.

### Client UUID

```text
Julia-Client-UUID: afda810c-134c-4059-9594-3d1b0e9f0928
```
The first time the Julia client connects to a package server, it generates a random client UUID, which it sends with each request (unless you have [opted out](#opting_out) of doing so). This helps us estimate how many Julia installs there are, which in combination with some of the other telemetry data allows estimating the number of Julia users. Having some persistent unique client value is essential for answering this question, since otherwise there's no way to distinguish a single client making a thousand requests from a thousand clients making a single request each. It also helps us answer other significant questions:

@@tight-list
- How often do users upgrade Julia?
- How often do users upgrade packages?
- How many users of each Julia package are there?
- For a given pair of packages, how many clients use both?
- How many package operations does a typical user perform in a given unit of time?
@@

Being able to answer these kinds of questions helps to improve the Julia experience for everyone. For example, if most users upgrade Julia as soon as possible, we should consider making more frequent Julia releases, whereas if most users only upgrade every six months or longer, then we might want to consider making less frequent releases and spend our limited time and energy on other aspects of development.

It's worth noting that *"How many Julia users are there?"* is the first question asked by organizations of all kinds—commercial, philanthropic and governmental—when they are considering investing in Julia, whether by giving grants to support open source work, sponsoring JuliaCon, or adopting the language for development of their own software systems. Being able to reliably and concretely answer this question is essential for promoting the development of the language and its ecosystem.

### Project Hash

```text
Julia-Project-Hash: fb03cd4baee60f383ef185fb5884d852766df25c
```
This hash value uniquely identifies the path of the active project without revealing any information about that path. Having this value allows determining when packages are dependencies of the same project, as opposed to being used in different projects on the same client: if two requests have the same project hash value, they are used by the same project; if they have different project hashes, they are not. No other information is revealed by this cryptographic hash value—you can only compare them to see if they are the same or different. Comparisons of hash values from different clients (or to different servers) are meaningless and provide no information.

Privacy of the user is protected by using a secret, securely generated, random salt value and applying a strong cryptographic hash (SHA2-224): the hash function is applied to the client UUID, the secret salt value, and the active project path. The secret random salt value is generated once for each package server and never sent anywhere. The salt is a 36-character, base-62, random string, providing 214 strongly random bits, generated by `/dev/random` or equivalent. The SHA2-224 hash function is used to combine this salt with the client UUID and project path and then truncated to 180 bits (the same length as SHA1; in this context, shorter hashes are safer). This 180-bit hash value is sent as a 40-byte hexadecimal string.

### CI Variables

```text
Julia-CI-Variables: APPVEYOR=n;CI=n;CIRCLECI=n;CONTINUOUS_INTEGRATION=n;GITHUB_ACTIONS=n
GITLAB_CI=n;JULIA_CI=n;TF_BUILD=n;TRAVIS=n
```
This header gives an indicator for each of a set of environment variables that are commonly set on automated continuous integration (CI) systems, such as AppVeyor, Azure Pipelines, CircleCI, GitHub Actions, GitLab, and Travis CI. On user systems, these will typically not be set. When analyzing requests to package servers, these indicators help to distinguish request from automated CI systems from real users. Automated CI systems can initiate a lot of requests which would significantly pollute statistics about Julia usage by real users. Due to the large volume of requests that can be initiated by CI systems, it is also often necessary to handle these systems specially to reduce service costs, e.g. by setting up a package server that is co-located with the CI service. Without the ability to accurately identify CI requests, it would be hard or impossible to identify and mitigate these costs.

Under no circumstances is the full value of an environment variable sent, which is crucial for preserving user privacy and not potentially leaking sensitive data (secrets are often stored in environment variables). For each environment variable that is checked, only one of four possible values is sent:

@@tight-list
- **None** (`n`): the variable is not set
- **True** (`t`): the variable has one of the values `true`, `t`,  `yes`, `y`, or `1`
- **False** (`f`): the variable has one of the values `false`, `f`,  `no`, `n`, or `0`
- **Other** (`o`): the variable is set but has some other value.
@@

The reason for spelling out the names of all the environment variables is so that if the set of variables changes in the future, it's possible to distinguish whether a variable was checked but unset from whether it was not checked at all.

### HyperLogLog

```text
Julia-HyperLogLog: 405,2
```
The number of distinct values in a stream can be efficiently estimated using the [HyperLogLog](https://en.wikipedia.org/wiki/HyperLogLog) estimator. Each client randomly chooses one of 1024 "buckets" which is the first value of this field and generates a random 64-bit unsigned integer and computes the number of trailing zeros of that value, which is the second value. In total, there are only 66,560 possible values for this header and since the second value is sampled from a heavily skewed distribution, there are many collisions, making it impossible to use this to distinguish all distinct users. Taken in aggregate, however, these random values can be used to roughly estimate the number of unique clients in a set of requests. There are a number of drawbacks and limitations to this approach that make client UUIDs still beneficial for understanding Julia usage, but the HyperLogLog values help understand some aspects of aggregate behavior even when we include users who opt out of sending client UUIDs.

### Interactive

```text
Julia-Interactive: true
```
This is a boolean indicator of whether the client session is interactive (i.e. in the Julia REPL) or non-interactive (i.e. a script or other automated process). This serves two purposes: it further helps distinguish real users from CI systems (the latter are never interactive) and gives insight into how people use the package manager. The current assumption is that most people use Julia's package manager interactively, and thus the bulk of development effort has gone towards supporting and developing that use case. If we learn from this data that a larger than expected portion of people use the package manager in a non-interactive way, then we should devote more resources to supporting that use case.

## Opting Out

You can opt out of sending some or all of the above telemetry data to some or all package servers. This is done by editing `telemetry.toml` files saved in the `~/.julia/servers/` directory on your local system. Telemetry files are [TOML](https://github.com/toml-lang/toml) files used to store persistent data for each client, such as the client UUID, the secret salt string, and HyperLogLog values. For example, this could be the content of a `~/.julia/servers/pkg.julialang.org/telemetry.toml` file:

```toml
HyperLogLog = [405, 2]
client_uuid = "afda810c-134c-4059-9594-3d1b0e9f0928"
secret_salt = "0P7zbWDTAfsOmlh8j7Tq7yYNMiJ8ewIhzsj6"
```

The directory the file appears in indicates that it's for the `pkg.julialang.org` package server. The entry for `HyperLogLog` and `client_uuid` give the plain values that are sent for those headers while the `secret_salt` field is not sent but used when hashing the path of the active project to generate the `Julia-Project-Hash` header. If you want to opt out of sending a client UUID, you can edit this file and set `client_uuid = false` to indicate that you are opting out of sending the client UUID and anything derived from it (i.e. the project hash). After changing that, `Pkg.telemetryinfo()` prints this:

```text
Julia-Pkg-Protocol: 1.0
Julia-Version: 1.6.0-DEV.282
Julia-System: x86_64-apple-darwin14-libgfortran5
Julia-CI-Variables: APPVEYOR=n;CI=n;CIRCLECI=n;CONTINUOUS_INTEGRATION=n;GITHUB_ACTIONS=n;GITLAB_CI=n;JULIA_CI=n;TF_BUILD=n;TRAVIS=n
Julia-HyperLogLog: 405,2
Julia-Interactive: true
```

The `Julia-Client-UUID` and `Julia-Project-Hash` headers are no longer sent. If you want to only opt out of sending the project hash header, you can leave `client_uuid` as (or delete it entirely and a new one will be generated) and set `secret_salt = false`, which results in this telemetry info being sent:

```text
Julia-Pkg-Protocol: 1.0
Julia-Version: 1.6.0-DEV.282
Julia-System: x86_64-apple-darwin14-libgfortran5
Julia-Client-UUID: afda810c-134c-4059-9594-3d1b0e9f0928
Julia-CI-Variables: APPVEYOR=n;CI=n;CIRCLECI=n;CONTINUOUS_INTEGRATION=n;GITHUB_ACTIONS=n;GITLAB_CI=n;JULIA_CI=n;TF_BUILD=n;TRAVIS=n
Julia-HyperLogLog: 405,2
Julia-Interactive: true
```

If you want to opt out of sending telemetry to a server altogether, you can put `telemetry = false` in the server's telemetry file to fully opt out. Only the `Julia-Pkg-Protocol` header will be sent; this header cannot be opted out of since it is necessary for correct interaction between client and server.

Most users will only use the default package server, `pkg.julialang.org`, but some users may connect to multiple different package servers, which may be operated by other entities than the Julia project. The first time you connect to a new server, Julia will print a brief legal notice with a link to this page. The telemetry file for the server will be saved in `~/.julia/servers/$server/telemetry.toml`. If you create a `~/.julia/servers/telemetry.toml` file it is be used as a template for new telemetry files, so if you want to default to opting out of generating and sending a client UUIDs to any new server, you can put `client_uuid = false` in this file. Similarly, if you want to opt out of sending telemetry altogether when connecting to a new package server, you can put `telemetry = false` in this file.

## Data Access, Analysis & Retention

Data sent to `pkg.julialang.org` is only accessible to a limited subset of core Julia developers and is not made public or shared with any third party. Julia 1.5 will be the first version of Julia that talks to package servers by default, so at the time of writing this text, we have not yet begun analyzing request data. Once we start to analyze request data, the details of that analysis will be provided here, including open source code for the analysis, available to be inspected and critiqued by anyone. The fully anonymous aggregated output of this analysis will also be made publicly available for the benefit of the Julia community. We will also establish a data retention policy: all individual request records will be kept for no more than a fixed period of time for analysis and will be securely deleted after the specified period.
