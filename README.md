# DEX subgraph

Subgraph, which allows to index chosen **Ethereum** network and provide queries to retreive data.

**This subgraph is supposed to be used in CI workflows with Linux environment.**

## Setup

Installation process is performed using GNU Make project building system.

Depending on the network you want to deploy DEX core smart contracts to you should select proper GNU Make target parameters.

For instance, if you want to perform subgraph deployment process for **Mainnet** you should call deploy target with the **mainnet** as the **network** param. By default **goerli** network is used. Also there should be specified **smart_contract_address**(address of the smart contract, which will be tracked), **ethereum_node_url**(URL of the ethereum JSON-RPC node), **graph_deploy**(URL of the deployed JSON-RPC admin server of the graph node instance), **graph_index**(URL of the status GraphQL server of the deployed graph node instance).

```shell
make deploy network=mainnet smart_contract_address=0xa358ADf3864Ea36EdeccB9d4c46EEeb9C02C1ed9 ethereum_node_url=https://mainnet.infura.io/v3/6852119f9d84410e8039e00faf4928f7 graph_node=https://graphnode.test.network/ graph_index=https://graphnode.test.network/status/
```