# Reserve3 Core Contracts

This project is an experiment in building wealth entirely on the blockchain by crowdsourcing the best Uniswap LP Tokens to hold at any given time. Crowdsourcing is done monthly via Governance Proposals proportional to your stake in the collective.

Stakes are held as tradeable NFTs (ERC721) and there is no limit to the number you can hold, minting is eternal. Anyone will be able to mint at a set price of (1ETH) but minting will be stalled to 1 mint per hour. This is to encourage and support secondary sales and allow holders to get out at true value at any time of their choosing. 

We will start at a reinvestment rate of 90%, this rate is subject to change as per the Governance process mentioned above.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
GAS_REPORT=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.ts
```
