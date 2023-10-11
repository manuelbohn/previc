import { MaximumLikelihoodEstimator } from "adaptivetesting";
import { readFile, writeFile } from "fs/promises";
import { CatItem } from "./CatItem";


async function main() {
    let error_array: number[] = [];
    //dataset loop
    for (let i = 1; i <= 500; i++) {
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
        const estimation: number = JSON.parse(estimation_buffer.toString())[0];



        //estimate
        const estimator = new MaximumLikelihoodEstimator();
        const result = estimator.GetMaximumLikelihoodEstimation(response_pattern, item_difficulties);

        //calculate error
        const error = estimation - result;
        error_array.push(error);
        
    }

    //save error results
    //the file will be saved to ../../saves
    const error_string:string = JSON.stringify(error_array);
    await writeFile("../../saves/estimation_errors.json", error_string);

    console.debug("Finished.");

}

main()