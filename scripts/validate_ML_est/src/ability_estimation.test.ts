import { describe, it, expect } from "@jest/globals";
import { readFile } from "fs/promises";
import { MaximumLikelihoodEstimator } from "adaptivetesting";
import { CatItem } from "./CatItem";

for (let i = 1; i <= 500; i++) {

    describe(`Test item ${i}`, () => {
        it("", async () => {
            //read item_bank
            const item_bank_buffer = await readFile(`generated/item_bank ${i} .json`);
            const item_bank = JSON.parse(item_bank_buffer.toString());

            const item_difficulties = item_bank.map((item: CatItem) => {
                return item.b;
            })


            //read responsepattern
            const resposne_buffer = await readFile(`generated/response_pattern ${i} .json`);
            const response_pattern = JSON.parse(resposne_buffer.toString());

            //read estimation
            const estimation_buffer = await readFile(`generated/estimation ${i} .json`);
            const estimation = JSON.parse(estimation_buffer.toString())[0];



            //estimate
            const estimator = new MaximumLikelihoodEstimator();
            const result = estimator.GetMaximumLikelihoodEstimation(response_pattern, item_difficulties);

            //test
            expect(result - estimation).toBeCloseTo(0);
        })
    });
}