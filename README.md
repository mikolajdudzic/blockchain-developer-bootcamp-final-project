# blockchain-developer-bootcamp-final-project
The final project to complete Blockchain Developer Bootcamp 2021!

**Launchpad which will allow a user to buy token allocations in early stage crypto projects.**


You can access my project here ->> ...

Walkthrough video url ->> ..

Public Ethereum wallet for NFT certificate ->> **0xcf74F7f45999f45992E4e2f6AA3354bE01049b82**


Ropsten LaunchpadDeal contract address: ->> **0xF3be1424Ed8ffdb457a3D0E3DeE8EF4577724a19**


Ropsten sendToken contract address: ->> **0xfDadDb8FcEA3312d2804b6352E7D418426776220**


Ropsten pToken contract address ->> **0xabeC441aCa68cE757264c89899Ba4820908b801b**


Ropsten Dudzic Token contract address ->> **0x23945a51C9045A622C0797575Cf1E480676eE79e**




Installation steps:
s
1. Run the **truffle compile** command to compile the contract source code files.
2. In another terminal window, run the **ganache-cli** command to start a local blockchain for testing.
3. Run **truffle test** command ti run all the unit tests.
4. Set the correct port number for the local development net in the truffle-config.js file.
5. Run **truffle migrate** development command to deploy smart contract to local testnet. 


**Overview:**

LaunchpadDeal smart contract is my first take to build my own big launchpad like EthPad or BSCPad. 

It's function is to handle payments during one particular deal. All raised funds are send to the owner of the conract.

I wanted to create my own token for payments so I minted pToken. To avoid problems with passing You this tokens I just made a short contract which sends 150 units to msg.sender on each transaction. 

For now I focused more on the pure logic but in the future I would like to improve UI with features like: status bar, deal info box, account details etc...

Thank you!
