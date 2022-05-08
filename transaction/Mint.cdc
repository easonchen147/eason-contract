import EasonKissNFT from 0xf8d6e0586b0a20c7

transaction {

    let receiverRef: &{EasonKissNFT.NFTReceiver}

    let minterRef: &EasonKissNFT.NFTMinter

    prepare(acct: AuthAccount) {
        // 校验是否有权限操作，借用能力
        self.receiverRef = acct.getCapability<&{EasonKissNFT.NFTReceiver}>(EasonKissNFT.CollectionPublicPath)
            .borrow()
            ?? panic("Could not borrow receiver reference")

        self.minterRef = acct.borrow<&EasonKissNFT.NFTMinter>(from: EasonKissNFT.MinterStoragePath)
            ?? panic("Could not borrow minter reference")
    }

    execute {
        let newNFT <- self.minterRef.mintNFT(initDataUri: "hahahah", creator: "Eason")

        self.receiverRef.deposit(token: <-newNFT)

        log("got new NFT self")
    }
}