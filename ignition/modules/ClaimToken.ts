import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const ClaimTokenModule = buildModule("ClaimTokenModule", (m) => {
  const _tokenToClaim = process.env.TOKEN_ADDRESS;
  const ClaimToken = m.contract("ClaimToken", [_tokenToClaim!]);
  return { ClaimToken };
});

export default ClaimTokenModule;
