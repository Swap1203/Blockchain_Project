// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract QRScanStorage {

    struct QRScan {
        string qrData;
        string result; // "Malicious" or "Benign"
        uint256 timestamp;
    }

    // Mapping user address to their scan history (array of QRScan)
    mapping(address => QRScan[]) private scanHistory;

    // Event emitted when a new scan is recorded
    event ScanRecorded(address indexed user, string qrData, string result, uint256 timestamp);

    // Record a new scan for msg.sender
    function recordScan(string calldata qrData, string calldata result) external {
        QRScan memory newScan = QRScan({
            qrData: qrData,
            result: result,
            timestamp: block.timestamp
        });
        scanHistory[msg.sender].push(newScan);

        emit ScanRecorded(msg.sender, qrData, result, block.timestamp);
    }

    // Get the number of scans recorded by the caller
    function getScanCount() external view returns (uint256) {
        return scanHistory[msg.sender].length;
    }

    // Get a scan by index for the caller
    function getScan(uint256 index) external view returns (string memory, string memory, uint256) {
        require(index < scanHistory[msg.sender].length, "Index out of bounds");
        QRScan storage scan = scanHistory[msg.sender][index];
        return (scan.qrData, scan.result, scan.timestamp);
    }

    // Get all scans for the caller (if you want to implement, be cautious about gas costs)
    // For demonstration, we'll omit this, as returning dynamic arrays is complex on-chain.
}
