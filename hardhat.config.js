
/* global ethers task */
require('@nomiclabs/hardhat-waffle')

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task('accounts', 'Prints the list of accounts', async () => {
  const accounts = await ethers.getSigners()

  for (const account of accounts) {
    console.log(account.address)
  }
})

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: '0.8.6',
  settings: {
    optimizer: {
      enabled: true,
      runs: 200
    }
  },

  networks: {
    sepolia: {
      url: 'https://sepolia.infura.io/v3/6fc2771cf8aa4870ae15b35f693c4874',
      accounts: ['b86518af7356f4ae87536e11517f700c4adfe44a3d95f048c6786d8457c80c13'],
    },
  },
  gasReporter: {
    enabled: true
  },
  etherscan: {
    apiKey: "FT9Q2JPMN7SSYJSY13INP4RSI8X7MFTAHG",
},
sourcify: {
  // Disabled by default
  // Doesn't need an API key
  enabled: true
}
}
