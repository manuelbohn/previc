import { describe, expect, test } from "@jest/globals";
import { readFile } from "fs/promises";
import { TestItem, UrrysRule } from "adaptivetesting";
import { CatItem } from "./CatItem";

for (let i = 1; i <= 200; i++) {
    describe("Item Selection Test"+i.toString(), () => {
        test("", async () => {

            //read selected ite
            const selected_item_string = (await readFile(`generated/selected_item ${i} .json`)).toString();
            //correct the index
            const selected_item_estimation_index = (JSON.parse(selected_item_string) as number[])[0] - 1;

            //read generated item bank
            const item_bank_string = (await readFile(`generated/selection_item ${i} .json`)).toString();
            const item_bank_object = JSON.parse(item_bank_string) as CatItem[];
            //map to test items
            const test_items: TestItem[] = item_bank_object.map((item: CatItem) => {
                const i = new TestItem(item.b);
                return i;
            });


            //calculate next item
            const result = UrrysRule(test_items, 0);
            //get the item estimated by catR from the item bank
            const estimated_item = item_bank_object[selected_item_estimation_index];
            //compare the difficulty of both items
            expect(result.Difficulty).toBeCloseTo(estimated_item.b!);


        });


    });
}

