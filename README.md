# Requirements
> On Windows it's running within the WSL.

> CRYSTAL for payment
> https://thirdweb.com/linea/0x21d624c846725ABe1e1e7d662E9fB274999009Aa

> Leaderboard: https://lineascan.build/address/0xD189c9293141f9C28170d2fc5AbB42ae95125380#code
> Lobby: https://lineascan.build/address/0x5d33B7a57eF9cbaBabe4e1B7EB7Ce2553a8f0980#code

# Instructions
1. Deploy Lobby
2. Deploy Leaderboard
3. Set the Lobby Game Parameters.
4. Set the lobby fee receiver.
5. Set the leaderboard on lobby.
6. Set the lobby on leaderboard.
7. Set the server on lobby.

# Tasks

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a Hardhat Ignition module that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat ignition deploy ./ignition/modules/Lobby.ts --network linea
npx hardhat verify --network linea <address> <deployer_address>
```

## Error Resolution
Get list of deployment ids:

```shell
npx hardhat ignition deployments
```

According to Hardhat [documentation](https://hardhat.org/ignition/docs/guides/error-handling#wiping-a-previous-execution)

Wipe the previous execution if the smartcontract was changed.

```shell
npx hardhat ignition wipe chain-59144 LobbyModule#Lobby
```