## Supported Julia versions

@@row @@col-8
~~~
<table class="downloads table table-hover table-bordered">
  <tbody>
    <tr>
      <th> Release</th>
      <th> Version</th>
      <th> Latest version </th>
    </tr>
    <tr>
      <td> Stable </td>
      <td> {{stable_release_short}} </td>
      <td> {{stable_release}} </td>
    </tr>
    <tr>
      <td> Long Term Stable (LTS) </td>
      <td> {{lts_release_short}}</td>
      <td> {{lts_release}} </td>
    </tr>
    </tbody>
</table>
~~~
@@ @@

## Supported platforms

Julia supports all the major operating systems. Different OSes and architectures have varying [tiers of support](/downloads/support#support_tiers).

@@row @@col-12
~~~
<table class="downloads table table-hover ">
  <tbody>
    <tr>
      <th> Operating System </th>
      <th> OS Version </th>
      <th> Architecture </th>
      <th> Support Tier </th>
    </tr>
    <tr>
      <td rowspan="3"> macOS </td>
      <td> 10.14+ </td>
      <td> x86-64 (64-bit) </td>
      <td> <font color="green">Tier 1</font> </td>
    </tr>
    <tr>
      <td> 11.4+ </td>
      <td> ARMv8 (64-bit) </td>
      <td> <font color="green">Tier 1</font> </td>
    </tr>
    <tr>
      <td> 11.4+ </td>
      <td> Rosetta 2 (x86 on ARM emulation) </td>
      <td> <font color="orange">Tier 2</font> </td>
    </tr>
    <tr>
      <td rowspan="4"> Windows </td>
      <td rowspan="3"> 10+ </td>
      <td> x86-64 (64-bit) </td>
      <td> <font color="green">Tier 1</font> </td>
    </tr>
    <tr>
      <td> i686 (32-bit) </td>
      <td> <font color="green">Tier 1</font> </td>
    </tr>
    <tr>
      <td> WSL 2 (Ubuntu LTS) </td>
      <td> <font color="orange">Tier 2</font> </td>
    </tr>
    <tr>
      <td> 11+ </td>
      <td> Prism (x86 on ARM emulation) </td>
      <td> <font color="orange">Tier 2</font> </td>
    </tr>
    <tr>
      <td rowspan="6"> Linux (Glibc) </td>
      <td rowspan="5"> 2.6.24+ </td>
      <td> x86-64 (64-bit) </td>
      <td> <font color="green">Tier 1</font> </td>
    </tr>
    <tr>
      <td> i686 (32-bit) </td>
      <td> <font color="green">Tier 1</font> </td>
    </tr>
    <tr>
      <td> ARMv8 (64-bit) </td>
      <td> <font color="orange">Tier 2</font> </td>
    </tr>
    <tr>
      <td> ARMv7 (32-bit) </td>
      <td> <font color="black">Tier 4</font> </td>
    </tr>
    <tr>
      <td> PowerPC LE (64-bit) </td>
      <td> <font color="crimson">Tier 3</font> </td>
    </tr>
    <tr>
      <td> 6.4+ </td>
      <td> RISC-V (64-bit) </td>
      <td> <font color="crimson">Tier 3</font> </td>
    </tr>
    <tr>
      <td rowspan="1"> Linux (Musl) </td>
      <td rowspan="1"> 2.6.39+ </td>
      <td> x86-64 (64-bit) </td>
      <td> <font color="crimson">Tier 3</font> </td>
    </tr>
    <tr>
      <td rowspan="2"> FreeBSD </td>
      <td> 13.4+ </td>
      <td> x86-64 (64-bit) </td>
      <td> <font color="orange">Tier 2</font> </td>
    </tr>
    <tr>
      <td> 14.1+ </td>
      <td> ARMv8 (64-bit) </td>
      <td> <font color="crimson">Tier 3</font> </td>
    </tr>
  </tbody>
</table>
~~~
@@ @@

Julia also supports a variety of hardware accelerators, by means of external packages.

@@row @@col-12
~~~
<table class="downloads table table-hover ">
  <tbody>
    <tr>
      <th> Hardware Accelerator </th>
      <th> Platform </th>
      <th> Requirements </th>
      <th> Support Tier </th>
    </tr>
    <tr>
      <td rowspan="2"> <a href="https://juliagpu.org/backends/cuda">NVIDIA GPUs using CUDA</a> </td>
      <td> Linux (64-bit) </td>
      <td rowspan="2"> NVIDIA driver for CUDA 11.0+ </td>
      <td> <font color="green">Tier 1</font> </td>
    </tr>
    <tr>
      <td> Windows (64-bit) </td>
      <td> <font color="orange">Tier 2</font> </td>
    </tr>
    <tr>
      <td> <a href="https://juliagpu.org/backends/metal">Apple GPUs using Metal</a> </td>
      <td> Apple Silicon </td>
      <td> macOS 13+ </td>
      <td> <font color="orange">Tier 2</font> </td>
    </tr>
    <tr>
      <td rowspan="2"> <a href="https://juliagpu.org/backends/oneapi">Intel GPUs with oneAPI</a> </td>
      <td> Linux (64-bit) </td>
      <td> 6.2+ </td>
      <td> <font color="orange">Tier 2</font> </td>
    </tr>
    <tr>
      <td> Windows (64-bit) </td>
      <td> WSL2 </td>
      <td> <font color="crimson">Tier 3</font> </td>
    </tr>
    <tr>
      <td rowspan="2"> <a href="https://juliagpu.org/backends/rocm">AMD GPUs using ROCm</a> </td>
      <td> Linux (64-bit) </td>
      <td rowspan="2"> ROCM 5.3+ </td>
      <td> <font color="crimson">Tier 3</font> </a> </td>
    </tr>
    <tr>
      <td> Windows (64-bit) </td>
      <td> <font color="crimson">Tier 3</font> </a> </td>
    </tr>
  </tbody>
</table>
~~~
@@ @@

## Support tiers

@@row @@col-12
~~~
<ul>
<li> <font color="green">Tier 1</font>: Julia is guaranteed to build from source and pass all tests on these platforms when built with the default options. Official binaries are always available and CI is run on every commit to ensure support is actively maintained.
<li> <font color="orange">Tier 2</font>: Julia is guaranteed to build from source using the default build options, but may or may not pass all tests. Official binaries are available on a case-by-case basis.
<li> <font color="crimson">Tier 3</font>: Julia may or may not build. If it does, it is unlikely to pass tests. Binaries may be available in some cases. When they are, they should be considered experimental. Ongoing support is dependent on community efforts.
<li> Tier 4: Julia built at some point in the past, but is known not to build currently.
</ul>
~~~
@@ @@

---
