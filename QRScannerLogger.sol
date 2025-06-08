// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ProductScan {
    
    struct QRScan {
        string qrData;
        string result;
        uint256 timestamp;
    }

    mapping(address => QRScan[]) private userScans;

    event ScanRecorded(address indexed user, string qrData, string result, uint256 timestamp);

    function recordScan(string memory qrData, string memory result) external {
        QRScan memory scan = QRScan({
            qrData: qrData,
            result: result,
            timestamp: block.timestamp
        });

        userScans[msg.sender].push(scan);
        emit ScanRecorded(msg.sender, qrData, result, block.timestamp);
    }

    function getMyScanCount() external view returns (uint256) {
        return userScans[msg.sender].length;
    }

    function getMyScanByIndex(uint index) external view returns (string memory, string memory, uint256) {
        require(index < userScans[msg.sender].length, "Index out of bounds");
        QRScan storage scan = userScans[msg.sender][index];
        return (scan.qrData, scan.result, scan.timestamp);
    }

    function getMyScansPaginated(uint offset, uint limit) external view returns (QRScan[] memory) {
        QRScan[] storage scans = userScans[msg.sender];
        require(offset < scans.length, "Offset out of bounds");

        uint end = offset + limit;
        if (end > scans.length) {
            end = scans.length;
        }

        QRScan[] memory paginated = new QRScan[](end - offset);
        for (uint i = offset; i < end; i++) {
            paginated[i - offset] = scans[i];
        }
        return paginated;
    }
}
