https://nestprotocol.org/zh/
https://nestdapp.io/

- 拍卖
  - `Nest_NToken_TokenAuction` NToken拍卖
  - `Nest_3_Leveling` 平衡合约
  - `Nest_3_TokenAbonus` 股利逻辑
  - `Nest_3_TokenSave` 锁定合约

- NestToken
`IBNEST` token，初始量 100 亿

- NodeAssignment
  - `NEST_NodeAssignment`
    - `changeMapping`
    - `bookKeeping`
    - `nodeGet`
    - `nodeCount`
    - `checkNodeNum`
  - `NEST_NodeAssignmentData`
    - `changeMapping`
    - `addNest`
    - `checkNodeAllAmount`
    ....

  - `NEST_NodeSave`
    - `changeMapping`
    - `turnOut`

- NestOffer
  - `Nest_3_MiningContract` 挖矿
    - `changeMapping`
    - `oreDrawing`
    - `changeBlockAmountList`
    - `changeAttenuationAmount`

  - `Nest_3_OfferPrice`
    - `changeMapping`
    - `addPrice`
    - `changePrice`
    - `updateAndCheckPriceNow`
    - `updateAndCheckPricePrivate`
    - `updateAndCheckPriceList`
    - `activation`
    - `checkPriceNow`
    - `checkUseNestPrice`
    ...

  - `Nest_3_OfferMain`
    - `offer`
    - `createOffer`
    - `sendEthBuyErc`
    - `sendErcBuyEth`
    - `turnOut`
    - `getPrice`
    - `find`
    - `list`
    - `writeOfferPriceData`
    - `writeUInt`
    - `writeAddress`
    ...

- NTokenOffer
  - `Nest_NToken_OfferMain`
    - `offer`
    - `createOffer`
    - `turnOut`
    - `sendEthBuyErc`
    - `sendErcBuyEth`
    - `oreDrawing`
    - `mining`
    - `comparativePrice`
    - `checkContractState`
    - `changeAttenuationAmount`
    - `getPrice`
    - `find`
    - `list`
    - `writeOfferPriceData`
    - `writeUInt`
    - `writeAddress`
    ......

- VoteContract
  - `Nest_3_VoteFactory`
    - `changeMapping`
    - `createVote`
    - `nestVote`
    - `nestNodeVote`
    - `startChange`
    - `sendNestNodeForStateOfEmergency`
    - `turnOutNestNodeForStateOfEmergency`
    - `changeStateOfEmergency`
    - `checkVoteNow`

  - `Nest_3_VoteContract`
    - `nestVote`
    - `nestVoteCancel`
    - `nestNodeVote`
    - `turnOutNestNode`
    - `startChange`
    - `ifEffective`
    - `checkContractEffective`

