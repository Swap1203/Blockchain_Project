import React, { useEffect } from "react";
import { Html5QrcodeScanner } from "html5-qrcode";

const QRScanner = ({ onScanComplete }) => {
  useEffect(() => {
    const scanner = new Html5QrcodeScanner("qr-reader", { fps: 10, qrbox: 250 });

    scanner.render(
      (decodedText) => {
        scanner.clear();
        onScanComplete(decodedText);
      },
      (error) => {
        console.warn("QR Scan Error:", error);
      }
    );

    return () => scanner.clear().catch(err => console.error("Clear failed", err));
  }, [onScanComplete]);

  return <div id="qr-reader" />;
};

export default QRScanner;
