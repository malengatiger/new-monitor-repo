"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
class Util {
    static sum(num1, num2) {
        console.log(`\n\n☘️   Util: sum: 🍔 🍔   summing ${num1} 🍔 🍔   ${num2}`);
        return num1 + num2;
    }
    static sendError(res, err, message) {
        console.log(`\n\n ERROR 🍔 ERROR 🍔 ERROR 🍔 ERROR 🍔 ERROR 🍔 ERROR `);
        console.error(err);
        res.status(400).json({
            error: err.stack,
            message,
        });
    }
}
exports.default = Util;
//# sourceMappingURL=util.js.map