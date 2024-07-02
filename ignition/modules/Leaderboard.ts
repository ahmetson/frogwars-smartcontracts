import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const LeaderboardModule = buildModule("LeaderboardModule", (m) => {
  const contract = m.contract("Leaderboard", [], {});

  return { contract };
});

export default LeaderboardModule;
