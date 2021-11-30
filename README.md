# blockchain-developer-bootcamp-final-project
The final project to complete Blockchain Developer Bootcamp 2021!

**Launchpad which will allow a user to buy token allocations in early stage crypto projects.**


You can access my project here ->> ...

Walkthrough video url ->> ..

Public Ethereum wallet for NFT certificate ->> **0xcf74F7f45999f45992E4e2f6AA3354bE01049b82**


Installation steps:
s

1. Run the **npm install** command to install all dependecies.
2. Run the **truffle compile** command to compile the contract source code files.
3. In another terminal window, run the **ganache-cli** command to start a local blockchain for testing.
4. Run **truffle test** command ti run all the unit tests.
5. Set the correct port number for the local development net in the truffle-config.js file. I was using 8545;
6. Run **truffle migrate** development command to deploy smart contract to local testnet. 


**Overview:**

LaunchpadDeal smart contract is my first take to build my own big launchpad like EthPad or BSCPad. 

It's function is to handle payments during one particular deal. All raised funds are send to the owner of the conract.

I wanted to create my own token for payments so I minted pToken. To avoid problems with passing You this tokens I just made a short contract which sends 150 units to msg.sender on each transaction. 

For now I focused more on the pure logic but in the future I would like to improve UI with features like: status bar, deal info box, account details etc...

Thank you!
