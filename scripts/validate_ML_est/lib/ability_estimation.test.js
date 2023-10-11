"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const globals_1 = require("@jest/globals");
const promises_1 = require("fs/promises");
const adaptivetesting_1 = require("adaptivetesting");
for (let i = 1; i <= 500; i++) {
    (0, globals_1.describe)(`Test item ${i}`, () => {
        (0, globals_1.it)("", async () => {
            //read item_bank
            const item_bank_buffer = await (0, promises_1.readFile)(`generated/item_bank ${i} .json`);
            const item_bank = JSON.parse(item_bank_buffer.toString());
            const item_difficulties = item_bank.map((item) => {
                return item.b;
            });
            //read responsepattern
            const resposne_buffer = await (0, promises_1.readFile)(`generated/response_pattern ${i} .json`);
            const response_pattern = JSON.parse(resposne_buffer.toString());
            //read estimation
            const estimation_buffer = await (0, promises_1.readFile)(`generated/estimation ${i} .json`);
            const estimation = JSON.parse(estimation_buffer.toString())[0];
            //estimate
            const estimator = new adaptivetesting_1.MaximumLikelihoodEstimator();
            const result = estimator.GetMaximumLikelihoodEstimation(response_pattern, item_difficulties);
            //test
            (0, globals_1.expect)(result - estimation).toBeCloseTo(0);
        });
    });
}
