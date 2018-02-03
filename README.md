# solidity-strings
solidity string function: join, contains, find, replace, remove, concat


###   启动一个测试的私有网路
```python

genensis.json  内容如下

{
  "config": {
        "chainId": 15,  
        "homesteadBlock": 0,
        "eip155Block": 0,
    },
    "coinbase" : "0x0000000000000000000000000000000000000000",
    "difficulty" : "0x40000",
    "extraData" : "",
    "gasLimit" : "0xffffffff",
    "nonce" : "0x0000000000000042",
    "mixhash" : "0x0000000000000000000000000000000000000000000000000000000000000000",
    "parentHash" : "0x0000000000000000000000000000000000000000000000000000000000000000",
    "timestamp" : "0x00",
    "alloc": { }
}

geth --rpc --rpcport "8545" --rpccorsdomain "*" --port "2403"  --ipcapi "admin,debug,eth,db,miner,net,txpool,personal,web3" --rpcapi "db,eth,miner,web3,net" --networkid "101010" --datadir "/data/workspace/eth/data" --nodiscover --maxpeers 0  console
```
### 另启一个终端, 执行一下命令
```python
geth attach "ipc file"  
personal.newAccount("password") # 创建一个账户
myaccounts = eth.accounts
miner.setEtherbase(myaccounts[0])  ＃ 设置挖矿的 coinbase
personal.unlockAccount(myaccounts[0])  # 解锁一个账户， 否则你无法send transaction, 也就意味着你无法调用，测试 solidity
miner.start(1)  ＃ 一个工作线程即可
```
### 

请阅读参考 http://truffleframework.com/docs/


