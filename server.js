const express = require('express');
const fs = require('fs');
const readline = require('readline');
const path = require('path');
const csv = require('csv-parser');

// Expressアプリケーションの作成
const app = express();
const PORT = 3000;

// 静的ファイル（画像など）を提供するためのミドルウェア
app.use('/images', express.static(path.join(__dirname, 'images')));

// CSVファイルパス
const ratingsFilePath = './data/user_ratings.csv';
const tagsFilePath = './tags/tags.csv';

// CSVの読み込み
const readTags = () => {
    return new Promise((resolve, reject) => {
        const data = [];
        fs.createReadStream(tagsFilePath)
            .pipe(csv())
            .on('data', (row) => {
                data.push([row.ImageNumber, row.Tags]);
            })
            .on('end', () => {
                resolve(data);
            })
            .on('error', reject);
    });
};

const recordRating = (imageNumber, rating) => {
    const entry = `${imageNumber},${rating}\n`;
    fs.appendFile(ratingsFilePath, entry, (err) => {
        if (err) throw err;
    });
};

// ルートエンドポイントで評価フォームを表示
app.get('/', async (req, res) => {
    const tags = await readTags();

    let html = '<h1>画像の評価</h1><form action="/rate" method="POST">';
    
    tags.forEach(([imageNumber, tagList]) => {
        html += `
            <div>
                <img src="/images/${imageNumber}.jpg" alt="Image ${imageNumber}" style="max-width: 300px;"/><br/>
                <label>画像番号 ${imageNumber} の評価 (0-10):</label>
                <input type="number" name="rating_${imageNumber}" min="0" max="10" required><br/><br/>
            </div>
        `;
    });

    html += '<button type="submit">送信</button></form>';
    res.send(html);
});

// POSTエンドポイントで評価を受け取り、保存
app.post('/rate', express.urlencoded({ extended: true }), (req, res) => {
    for (let key in req.body) {
        if (key.startsWith('rating_')) {
            const imageNumber = key.split('_')[1];
            const rating = req.body[key];
            recordRating(imageNumber, rating);
        }
    }
    res.send('<h1>評価が保存されました</h1><a href="/">戻る</a>');
});

// サーバーの起動
app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
