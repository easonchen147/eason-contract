import EasonKissNFT from 0xf8d6e0586b0a20c7

pub fun main() {
    let nftOwner = getAccount(0xf8d6e0586b0a20c7)

    let capability = nftOwner.getCapability<&{EasonKissNFT.NFTReceiver}>(EasonKissNFT.CollectionPublicPath)

    let receiverRef = capability.borrow()
            ?? panic("Could not borrow receiver reference")

    log("WHOS HAS : ")
    log(receiverRef.printwhohas(id: 1))
}
 