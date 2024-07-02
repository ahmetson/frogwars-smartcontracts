# Requirements
> On Windows it's running within the WSL.

> CRYSTAL for payment
> https://thirdweb.com/linea/0x21d624c846725ABe1e1e7d662E9fB274999009Aa

> Leaderboard: https://lineascan.build/address/0xD189c9293141f9C28170d2fc5AbB42ae95125380#code
> Lobby: https://lineascan.build/address/0x80Cbc1f7fd60B7026C0088e5eD58Fc6Ce1180141#code

# Instructions
1. Deploy Lobby
2. Deploy Leaderboard
3. Set the Lobby Game Parameters.
4. Set the lobby fee receiver.
5. Set the leaderboard on lobby.
6. Set the lobby on leaderboard.
7. Set the server on lobby.

# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a Hardhat Ignition module that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat ignition deploy ./ignition/modules/Lock.ts
```
