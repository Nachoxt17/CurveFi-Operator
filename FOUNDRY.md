# Blockchain Team template for Foundry


## Setup

forge install

## Compilation

Compile contracts:
```sh
forge build
```

### Testing

Run tests with:
```sh
forge test -vv                                   (basic test in local network)
forge test -vvv                                  (test with traces in local network)
forge test -vv --fork-url {RPC_URL}              (basic test in forked network)
forge test -vvv --fork-url {RPC_URL}             (test with traces in forked network)
```

### Cool Features

```sh
forge test -vvv --watch                          (auto-compiles and makes a generic screen to watch execution with traces)
forge bind                                       (rust bindings created in the project)
forge inspect "contract.sol" assembly            (assembly output for the contract)
```
