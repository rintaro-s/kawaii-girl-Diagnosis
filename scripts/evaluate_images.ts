// evaluate_images.ts

import fs from 'fs';
import readline from 'readline';

// CSVファイルパス
const ratingsFilePath = './data/user_ratings.csv';
const tagsFilePath = './tags/tags.csv';

// CSVの読み込み
const readTags = (): Promise<string[][]> => {
    return new Promise((resolve, reject) => {
        const data: string[][] = [];
        fs.createReadStream(tagsFilePath)
            .pipe(require('csv-parser')())
            .on('data', (row: any) => {
                data.push([row.ImageNumber, row.Tags]);
            })
            .on('end', () => {
                resolve(data);
            })
            .on('error', reject);
    });
};

const recordRating = (imageNumber: number, rating: number) => {
    const entry = `${imageNumber},${rating}\n`;
    fs.appendFile(ratingsFilePath, entry, (err) => {
        if (err) throw err;
    });
};

// プロンプトを表示してユーザーからの入力を取得
const promptUserForRating = (imageNumber: string, tagList: string) => {
    return new Promise<number>((resolve) => {
        const question = `画像番号 ${imageNumber} (タグ: ${tagList}) に点数を付けてください (0-10): `;
        rl.question(question, (rating) => {
            resolve(Number(rating));
        });
    });
};

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

const promptUserForRatings = async () => {
    const tags = await readTags();

    for (const [imageNumber, tagList] of tags) {
        const rating = await promptUserForRating(imageNumber, tagList);
        recordRating(Number(imageNumber), rating);
    }

    rl.close();
};

promptUserForRatings();
