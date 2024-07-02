import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const LobbyModule = buildModule("LobbyModule", (m) => {
  const contract = m.contract("Lobby", [m.getAccount(0)], {});

  return { contract };
});

export default LobbyModule;
