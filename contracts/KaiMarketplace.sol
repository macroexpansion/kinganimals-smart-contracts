// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/utils/math/SafeMath.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/utils/Counters.sol';
import '@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol';
import '@openzeppelin/contracts/token/ERC721/IERC721.sol';
import '@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol';
import '@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol';

contract KaiMarketplace is Ownable, IERC721Receiver {
    using SafeMath for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private _saleIds;
    Counters.Counter private _saleSold;
    Counters.Counter private _saleInactive;

    uint256 public feePercentX10;
    address public feeReceiver;
    IERC20 public token;
    IERC721 public nft;

    constructor(address erc20, address erc721) {
        token = IERC20(erc20);
        nft = IERC721(erc721);

        feePercentX10 = 50; // 5%
        feeReceiver = msg.sender;
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external pure override returns (bytes4) {
        return 0x150b7a02;
    }

    /**
        Fee percent and fee receiver
    */
    function setFee(uint256 newFee) external onlyOwner {
        require(newFee <= 100, 'setFee: Fee percent must be smaller than 10%');
        feePercentX10 = newFee;
    }

    function setFeeReceiver(address newFeeReceiver) external onlyOwner {
        require(newFeeReceiver != address(0), 'setFeeReceiver: null address');
        feeReceiver = newFeeReceiver;
    }

    /**
     * Sale
     */
    struct Sale {
        uint256 saleId;
        uint256 tokenId;
        address seller;
        address buyer;
        uint256 price;
        bool isSold;
        bool isActive;
        uint256 lastUpdated;
    }

    mapping (uint256 => Sale) public salesById;

    event SaleCreated(
        uint256 indexed saleId,
        uint256 indexed tokenId,
        address indexed seller,
        uint256 price,
        bool isSold,
        uint256 lastUpdated
    );
    event SaleUpdated(
        uint256 indexed saleId,
        uint256 indexed tokenId,
        address indexed seller,
        uint256 price,
        uint256 lastUpdated
    );
    event SaleCanceled(
        uint256 indexed saleId,
        uint256 indexed tokenId,
        address indexed seller,
        uint256 price,
        uint256 lastUpdated
    );
    event SaleSold(
        uint256 indexed saleId,
        uint256 indexed tokenId,
        address seller,
        uint256 price,
        bool isSold,
        uint256 lastUpdated
    );
    event FeeTransfered(
        uint256 saleId,
        uint256 tokenId,
        address seller,
        address buyer,
        address feeReceiver,
        uint256 fee,
        uint256 lastUpdated
    );

    modifier onlySeller(uint256 saleId) {
        require(msg.sender == salesById[saleId].seller, 'Invalid sale seller');
        _;
    }

    /* Places an item for sale on the marketplace */
    function createSale(uint256 tokenId, uint256 price) external {
        require(price > 0, 'createSale: Price must be at least 1 wei');
        require(
            nft.ownerOf(tokenId) == msg.sender,
            'createSale: You do not own this token'
        );

        _saleIds.increment();
        uint256 saleId = _saleIds.current();

        nft.safeTransferFrom(msg.sender, address(this), tokenId);

        salesById[saleId] = Sale(
            saleId,
            tokenId,
            msg.sender,
            address(0),
            price,
            false,
            true,
            block.timestamp
        );

        emit SaleCreated(
            saleId,
            tokenId,
            msg.sender,
            price,
            false,
            block.timestamp
        );
    }

    /* Creates the sale of a marketplace item */
    /* Transfers ownership of the item, as well as funds between parties */
    function purchaseSale(uint256 saleId) external {
        Sale storage sale = salesById[saleId];
        uint256 price = sale.price;

        require(
            (sale.isActive == true) && (sale.isSold == false),
            'purchase: Sale was ended.'
        );
        require(
            msg.sender != sale.seller,
            'purchaseSale: Buyer is seller of this item.'
        );

        // transfer to fee receiver
        bool feeReceiverTxSuccess = token.transferFrom(
            msg.sender,
            feeReceiver,
            price.mul(feePercentX10).div(1000)
        );
        require(feeReceiverTxSuccess, 'purchaseSale: Failed to transfer fee');

        // transfer to seller
        bool sellerTxSuccess = token.transferFrom(
            msg.sender,
            sale.seller,
            price.mul(1000 - feePercentX10).div(1000)
        );
        require(sellerTxSuccess, 'Failed to transfer token');

        uint256 tokenId = sale.tokenId;
        nft.transferFrom(address(this), msg.sender, tokenId);
        uint256 currentTime = block.timestamp;

        sale.isSold = true;
        sale.isActive = false;
        sale.buyer = msg.sender;
        sale.lastUpdated = currentTime;

        _saleSold.increment();

        emit SaleSold(
            saleId,
            tokenId,
            sale.seller,
            price,
            sale.isSold,
            currentTime
        );

        emit FeeTransfered(
            saleId,
            tokenId,
            sale.seller,
            sale.buyer,
            feeReceiver,
            price.mul(feePercentX10).div(1000),
            currentTime
        );
    }

    function changeSalePrice(uint256 saleId, uint256 newPrice)
        external
        onlySeller(saleId)
    {
        Sale storage sale = salesById[saleId];
        require(
            sale.isActive && !sale.isSold,
            'changeSalePrice: Sale was ended.'
        );
        require(newPrice > 0, 'changeSalePrice: Price must be at least 1 wei');

        sale.price = newPrice;

        emit SaleUpdated(
            saleId,
            sale.tokenId,
            sale.seller,
            sale.price,
            block.timestamp
        );
    }

    function cancelSale(uint256 saleId) external onlySeller(saleId) {
        Sale storage sale = salesById[saleId];
        require(sale.isActive, 'cancelSale: Sale was ended.');

        nft.transferFrom(address(this), msg.sender, sale.tokenId);
        sale.isActive = false;

        _saleInactive.increment();

        emit SaleCanceled(
            saleId,
            sale.tokenId,
            sale.seller,
            sale.price,
            block.timestamp
        );
    }

    function getActiveSalesByPage(uint256 page, uint256 size)
        external
        view
        returns (
            uint256[] memory saleIds,
            uint256[] memory tokenIds,
            address[] memory sellers,
            uint256[] memory prices,
            uint256[] memory lastUpdateds
        )
    {
        require(
            page >= 0 && size > 0,
            'getActiveSalesByPage: Page and size must be greater than 0'
        );

        uint256 activeSaleCount = _saleIds.current() - _saleInactive.current() - _saleSold.current();
        if (activeSaleCount < page * size) {
            saleIds = new uint256[](0);
            tokenIds = new uint256[](0);
            sellers = new address[](0);
            prices = new uint256[](0);
            lastUpdateds = new uint256[](0);
            return (saleIds, tokenIds, sellers, prices, lastUpdateds);
        }

        uint256 saleSize = (page + 1) * size > activeSaleCount
            ? activeSaleCount - page * size
            : size;

        saleIds = new uint256[](saleSize);
        tokenIds = new uint256[](saleSize);
        sellers = new address[](saleSize);
        prices = new uint256[](saleSize);
        lastUpdateds = new uint256[](saleSize);

        uint256 currentIndex = 0;
        uint256 count = 0;
        for (uint256 i = 1; i <= _saleIds.current(); i++) {
            if (salesById[i].isActive) {
                count++;
                if (count > page * size) {
                    Sale storage sale = salesById[i];

                    saleIds[currentIndex] = sale.saleId;
                    tokenIds[currentIndex] = sale.tokenId;
                    sellers[currentIndex] = sale.seller;
                    prices[currentIndex] = sale.price;
                    lastUpdateds[currentIndex] = sale.lastUpdated;
                    
                    if (currentIndex++ == size - 1) break;
                }
            }
        }

        return (saleIds, tokenIds, sellers, prices, lastUpdateds);
    }

    /* Returns only sales that a user has purchased */
    // function getUserPurchasedSales() external view returns (Sale[] memory) {
    //     uint256 saleCount = _saleIds.current();
    //     uint256 count = 0;
    //     uint256 currentIndex = 0;

    //     for (uint256 i = 1; i <= saleCount; i++) {
    //         if (salesById[i].buyer == msg.sender) {
    //             count += 1;
    //         }
    //     }

    //     Sale[] memory sales = new Sale[](count);
    //     for (uint256 i = 1; i <= saleCount; i++) {
    //         if (salesById[i].buyer == msg.sender) {
    //             Sale storage sale = salesById[i];
    //             sales[currentIndex++] = sale;
    //         }
    //     }

    //     return sales;
    // }

    /* Returns only sales that a user has created */
    function getUserCreatedSales()
        external
        view
        returns (
            uint256[] memory saleIds,
            uint256[] memory tokenIds,
            address[] memory sellers,
            uint256[] memory prices,
            uint256[] memory lastUpdateds
        )
    {
        uint256 saleCount = _saleIds.current();
        uint256 count = 0;

        for (uint256 i = 1; i <= saleCount; i++) {
            if (salesById[i].seller == msg.sender && salesById[i].isActive) {
                count += 1;
            }
        }

        saleIds = new uint256[](count);
        tokenIds = new uint256[](count);
        sellers = new address[](count);
        prices = new uint256[](count);
        lastUpdateds = new uint256[](count);

        uint256 currentIndex = 0;
        for (uint256 i = 1; i <= saleCount; i++) {
            if (salesById[i].seller == msg.sender && salesById[i].isActive) {
                Sale storage sale = salesById[i];

                saleIds[currentIndex] = sale.saleId;
                tokenIds[currentIndex] = sale.tokenId;
                sellers[currentIndex] = sale.seller;
                prices[currentIndex] = sale.price;
                lastUpdateds[currentIndex] = sale.lastUpdated;

                if (currentIndex++ == count) break;
            }
        }

        return (saleIds, tokenIds, sellers, prices, lastUpdateds);
    }
}
