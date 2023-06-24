- [Notes from HKOSCON 2023](#notes-from-hkoscon-2023)
- [Tools](#tools)
____

# Notes from HKOSCON 2023

- application and runtime in one binary and the binary runs on a hypervisor
- instead of a layered architecture, it composes of different components (os,
  libraries, application code) and makes into one layer
- targeting release of `1.0`  in 2024 Q1
- in theory, compiling a .NET application with a .NET runtime in a binary and
  loading the binary with ABI of Unikraft (Unikernel) should work

# Tools

- [Unicraft](https://unikraft.org/) - a fast, secure and open-source Unikernel
  Development Kit
  - to an application developer, unikraft is a set of libraries (or APIs) to be
    included to build an unikernel application
  - directory setup of unikraft has `apps` and `libs`
    * `apps` are application to be built using unikraft libraries
      + dependencies are defined in `.config`
    * `libs` are dependencies of the applications may needed
  - [Getting start with unikraft](https://unikraft.org/docs/getting-started/)
  - [unikraft/app-helloworld](https://github.com/unikraft/app-helloworld) - an
    example C application

