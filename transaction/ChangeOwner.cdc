import EasonKissNFT from 0xf8d6e0586b0a20c7

transaction(id: UInt64, whohas: String) {

    prepare(acct: AuthAccount) {
        let receiverRef = acct.getCapability<&{EasonKissNFT.NFTReceiver}>(EasonKissNFT.CollectionPublicPath)
            .borrow()
            ?? panic("Could not borrow receiver reference")

        receiverRef.changeOwner(id: id, whohas: whohas)
    }

    execute {
        log("change NFT owner")
    }
}
 