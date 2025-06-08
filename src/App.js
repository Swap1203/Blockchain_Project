import React, { useState } from "react";
import QRScanner from "./QRScanner";
import Web3 from "web3";
import ProductScanABI from "./abis/ProductScan.json";

const App = () => {
  const [scanResult, setScanResult] = useState("");
  const [qrData, setQRData] = useState("");

  const handleScanComplete = async (decodedQR) => {
    setQRData(decodedQR);

    try {
      // Call Flask API
      const response = await fetch("http://localhost:5000/check-qr", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ qr: decodedQR }),
      });

      const data = await response.json();
      setScanResult(data.result);

      // Send to Ethereum
      const web3 = new Web3(window.ethereum);
      await window.ethereum.request({ method: "eth_requestAccounts" });
      const accounts = await web3.eth.getAccounts();

      const contract = new web3.eth.Contract(
        ProductScanABI,
        "YOUR_CONTRACT_ADDRESS"
      );

      await contract.methods.recordScan(decodedQR, data.result).send({
        from: accounts[0],
      });

      alert(`Scan recorded on blockchain as: ${data.result}`);
    } catch (error) {
      console.error(error);
      alert("Something went wrong!");
    }
  };

  return (
    <div style={{ padding: 20 }}>
      <h2>🧠 Fake Product Detection</h2>
      <QRScanner onScanComplete={handleScanComplete} />
      {qrData && <p><b>Scanned:</b> {qrData}</p>}
      {scanResult && <p><b>Result:</b> {scanResult}</p>}
    </div>
  );
};

export default App