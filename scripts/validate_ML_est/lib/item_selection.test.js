"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const globals_1 = require("@jest/globals");
const promises_1 = require("fs/promises");
const adaptivetesting_1 = require("adaptivetesting");
for (let i = 1; i <= 200; i++) {
    (0, globals_1.describe)("Item Selection Test" + i.toString(), () => {
        (0, globals_1.test)("", async () => {
            //read selected ite
            const selected_item_string = (await (0, promises_1.readFile)(`generated/selected_item ${i} .json`)).toString();
            //correct the index
            const selected_item_estimation_index = JSON.parse(selected_item_string)[0] - 1;
            //read generated item bank
            const item_bank_string = (await (0, promises_1.readFile)(`generated/selection_item ${i} .json`)).toString();
            const item_bank_object = JSON.parse(item_bank_string);
            //map to test items
            const test_items = item_bank_object.map((item) => {
                const i = new adaptivetesting_1.TestItem(item.b);
                return i;
            });
            //calculate next item
            const result = (0, adaptivetesting_1.UrrysRule)(test_items, 0);
            //get the item estimated by catR from the item bank
            const estimated_item = item_bank_object[selected_item_estimation_index];
            //compare the difficulty of both items
            (0, globals_1.expect)(result.Difficulty).toBeCloseTo(estimated_item.b);
        });
    });
}
