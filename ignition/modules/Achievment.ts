import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const AchievmentModule = buildModule("AchievmentModule", (m) => {
  const _baseURL = "https://gamifiedweb3api.onrender.com/nft-metadata/";
  const _symbol = "L3P_ANFT";
  const _name = "Learn3Play Achievment NFT";
  const AchievementNFT = m.contract("AchievementNFT", [
    _name,
    _symbol,
    _baseURL,
  ]);
  return { AchievementNFT };
});

export default AchievmentModule;
