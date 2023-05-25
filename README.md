# DEX subgraph

Subgraph, which allows to index chosen **Ethereum** network and provide queries to retreive data.

**This subgraph is supposed to be used in CI workflows with Linux environment.**

## Setup

Installation process is performed using GNU Make project building system.

Depending on the network you want to deploy DEX core smart contracts to you should select proper GNU Make target parameters.

| Name | Description |  Possible value |
-------| --------------| ------------- |
network | network where the tracked smart contract is deployed | mumbai(default), mainnet |
smart_contract_address | ddress of the smart contract, which will be tracked | 0xa358ADf3864Ea36EdeccB9d4c46EEeb9C02C1ed9 |
ethereum_node_url | URL of the ethereum JSON-RPC node | https://mainnet.infura.io/v3/6852119f9d84410e8039e00faf4928f7 |
graph_deploy | URL of the deployed JSON-RPC admin server of the graph node instance | https://graphnode.test.network/ |
graph_index | URL of the status GraphQL server of the deployed graph node instance | https://graphnode.test.network/status/ |

```shell
make deploy 
  network=mainnet 
  smart_contract_address=0xa358ADf3864Ea36EdeccB9d4c46EEeb9C02C1ed9 
  ethereum_node_url=https://mainnet.infura.io/v3/6852119f9d84410e8039e00faf4928f7 
  graph_deploy=https://graphnode.test.network/ 
  graph_index=https://graphnode.test.network/status/
```
