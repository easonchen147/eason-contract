pub contract EasonKissNFT {

    // 定义NFT的存储路径
    pub let CollectionStoragePath: StoragePath
    pub let CollectionPublicPath: PublicPath
    pub let MinterStoragePath: StoragePath

    // 定义资源拥有的字段
    pub resource NFT {
        pub let creator: String
        pub let id: UInt64
        pub let dataUri: String
        pub(set) var whohas: String

        init(initID: UInt64, initDataUri: String, creator: String) {
            self.id = initID
            self.dataUri = initDataUri
            self.creator = creator
            self.whohas = creator
        }
    }

    // 定义拥有者包含的方法接口
    pub resource interface NFTReceiver {

        pub fun deposit(token: @NFT)

        pub fun getIDs(): [UInt64]

        pub fun idExists(id: UInt64): Bool

        pub fun changeOwner(id: UInt64, whohas: String)

        pub fun withdraw(withdrawID: UInt64): @NFT

        pub fun printwhohas(id: UInt64)
    }

    // 定义集合的资源
    pub resource Collection: NFTReceiver {

        // 拥有的NFT关系表
        pub var ownedNFTs: @{UInt64: NFT}

        init () {
            self.ownedNFTs <- {}
        }

        pub fun withdraw(withdrawID: UInt64): @NFT {
            let token <- self.ownedNFTs.remove(key: withdrawID)!
            return <-token
        }

        // 添加NFT资源
        pub fun deposit(token: @NFT) {
            self.ownedNFTs[token.id] <-! token
        }

        pub fun idExists(id: UInt64): Bool {
            return self.ownedNFTs[id] != nil
        }

        pub fun getIDs(): [UInt64] {
            return self.ownedNFTs.keys
        }

        // 修改拥有者
        pub fun changeOwner(id: UInt64, whohas: String) {
             let token <- self.ownedNFTs.remove(key: id)!
             token.whohas = whohas
             self.ownedNFTs[token.id] <-! token
        }

        pub fun printwhohas(id: UInt64) {
            let token <- self.ownedNFTs.remove(key: id)!
            log(token.whohas)
            self.ownedNFTs[token.id] <-! token
        }

        destroy() {
            destroy self.ownedNFTs
        }
    }

    pub fun createEmptyCollection(): @Collection {
        return <- create Collection()
    }

    // 铸币者资源定义
    pub resource NFTMinter {

        pub var idCount: UInt64

        init() {
            self.idCount = 1
        }

        // 铸币方法实现
        pub fun mintNFT(initDataUri: String, creator: String): @NFT {
            var newNFT <- create NFT(initID: self.idCount, initDataUri: initDataUri, creator: creator)
            self.idCount = self.idCount + 1
            return <-newNFT
        }
    }

	init() {
        // 定义路径保存资源
        self.CollectionStoragePath = /storage/nftTutorialCollection
        self.CollectionPublicPath = /public/nftTutorialCollection
        self.MinterStoragePath = /storage/nftTutorialMinter

		// store an empty NFT Collection in account storage
        self.account.save(<-self.createEmptyCollection(), to: self.CollectionStoragePath)

        // publish a reference to the Collection in storage
        self.account.link<&{NFTReceiver}>(self.CollectionPublicPath, target: self.CollectionStoragePath)

        // store a minter resource in account storage
        self.account.save(<-create NFTMinter(), to: self.MinterStoragePath)
	}
}